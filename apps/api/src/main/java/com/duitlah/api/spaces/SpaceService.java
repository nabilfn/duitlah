package com.duitlah.api.spaces;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The one place space membership and role are resolved. Every future Business-domain module should
 * depend on {@link #requireMembership} for authorization rather than querying {@code space_members}
 * directly -- the same "one chokepoint" shape {@code JwtAuthenticationFilter} already is for
 * identity. {@link #requirePermission} is the same chokepoint for Business RBAC (spec section 33).
 */
@Service
public class SpaceService {

  private final FinancialSpaceRepository spaces;
  private final SpaceMemberRepository members;
  private final BusinessProfileRepository businessProfiles;
  private final UserRepository users;

  public SpaceService(
      FinancialSpaceRepository spaces,
      SpaceMemberRepository members,
      BusinessProfileRepository businessProfiles,
      UserRepository users) {
    this.spaces = spaces;
    this.members = members;
    this.businessProfiles = businessProfiles;
    this.users = users;
  }

  /**
   * Called once, from {@code AuthService.register}, in the same transaction as account creation.
   * Existing users instead receive their PERSONAL space via V16's own one-time SQL backfill -- this
   * method is only ever for brand-new users going forward.
   */
  @Transactional
  public void createPersonalSpaceForNewUser(UUID userId) {
    FinancialSpace space = new FinancialSpace(SpaceType.PERSONAL, "Personal", userId);
    spaces.save(space);
    members.save(new SpaceMember(space.getId(), userId, SpaceRole.OWNER));
  }

  @Transactional
  public FinancialSpaceResponse createBusinessSpace(
      UUID userId, CreateBusinessSpaceRequest request) {
    FinancialSpace space = new FinancialSpace(SpaceType.BUSINESS, request.name().trim(), userId);
    spaces.save(space);
    members.save(new SpaceMember(space.getId(), userId, SpaceRole.OWNER));

    BusinessProfile profile = new BusinessProfile(space.getId(), request.legalName().trim());
    profile.setTradeName(request.tradeName());
    profile.setRegistrationNumber(request.registrationNumber());
    profile.setTin(request.tin());
    profile.setBusinessType(request.businessType());
    profile.setIndustry(request.industry());
    profile.setSstNumber(request.sstNumber());
    profile.setFinancialYearStart(request.financialYearStart());
    profile.setFinancialYearEnd(request.financialYearEnd());
    profile.setAddress(request.address());
    profile.setPhone(request.phone());
    profile.setEmail(request.email());
    if (request.currency() != null && !request.currency().isBlank()) {
      profile.setCurrency(request.currency().trim().toUpperCase());
    }
    businessProfiles.save(profile);

    return FinancialSpaceResponse.of(space, SpaceRole.OWNER);
  }

  public List<FinancialSpaceResponse> listMySpaces(UUID userId) {
    return members.findByUserIdAndStatus(userId, MemberStatus.ACTIVE).stream()
        .map(
            member ->
                spaces
                    .findById(member.getSpaceId())
                    .map(space -> FinancialSpaceResponse.of(space, member.getRole())))
        .flatMap(Optional::stream)
        .toList();
  }

  /**
   * For {@code crossspace}'s "which business?" picker (spec section 58) — every active BUSINESS
   * space the user belongs to, regardless of role.
   */
  public List<FinancialSpaceResponse> listBusinessSpacesFor(UUID userId) {
    return listMySpaces(userId).stream()
        .filter(space -> space.type() == SpaceType.BUSINESS)
        .toList();
  }

  public FinancialSpaceResponse getSpace(UUID userId, UUID spaceId) {
    SpaceMember member = requireMembership(userId, spaceId);
    FinancialSpace space = spaces.findById(spaceId).orElseThrow(() -> notFound());
    return FinancialSpaceResponse.of(space, member.getRole());
  }

  public BusinessProfileResponse getBusinessProfile(UUID userId, UUID spaceId) {
    requireMembership(userId, spaceId);
    return BusinessProfileResponse.of(requireBusinessProfile(spaceId));
  }

  @Transactional
  public BusinessProfileResponse updateBusinessProfile(
      UUID userId, UUID spaceId, UpdateBusinessProfileRequest request) {
    requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    BusinessProfile profile = requireBusinessProfile(spaceId);
    profile.setLegalName(request.legalName().trim());
    profile.setTradeName(request.tradeName());
    profile.setRegistrationNumber(request.registrationNumber());
    profile.setTin(request.tin());
    profile.setBusinessType(request.businessType());
    profile.setIndustry(request.industry());
    profile.setSstNumber(request.sstNumber());
    profile.setFinancialYearStart(request.financialYearStart());
    profile.setFinancialYearEnd(request.financialYearEnd());
    profile.setAddress(request.address());
    profile.setPhone(request.phone());
    profile.setEmail(request.email());
    if (request.currency() != null && !request.currency().isBlank()) {
      profile.setCurrency(request.currency().trim().toUpperCase());
    }
    profile.setAnnualRevenue(request.annualRevenue());
    businessProfiles.save(profile);
    return BusinessProfileResponse.of(profile);
  }

  /**
   * Public -- {@code businesstax}/{@code einvoice} need the real entity (TIN, SST number, annual
   * revenue) to build readiness checks and e-Invoice payloads.
   */
  public BusinessProfile requireBusinessProfile(UUID spaceId) {
    return businessProfiles
        .findBySpaceId(spaceId)
        .orElseThrow(
            () ->
                new NotFoundException("BUSINESS_PROFILE_NOT_FOUND", "Business profile not found."));
  }

  /**
   * Every user has exactly one PERSONAL space (V16's invariant) -- used by personal-finance
   * features (AutoTrack, Receipt Vault, statement import) that tag their rows with a space id but
   * don't yet expose a "choose which space" control, since nothing outside Personal reads them yet
   * (see docs/autotrack.md).
   */
  public UUID personalSpaceIdFor(UUID userId) {
    return spaces
        .findByOwnerUserIdAndType(userId, SpaceType.PERSONAL)
        .orElseThrow(this::notFound)
        .getId();
  }

  /**
   * 404s (never 403) for anyone who isn't an active member -- the same "don't leak existence"
   * pattern every other ownership/membership check in this codebase already uses.
   */
  public SpaceMember requireMembership(UUID userId, UUID spaceId) {
    return members
        .findBySpaceIdAndUserId(spaceId, userId)
        .filter(SpaceMember::isActive)
        .orElseThrow(this::notFound);
  }

  /**
   * Server-enforced Business RBAC (spec section 33) — 403, since the caller already knows the space
   * exists.
   */
  public SpaceMember requirePermission(UUID userId, UUID spaceId, BusinessPermission permission) {
    SpaceMember member = requireMembership(userId, spaceId);
    if (!BusinessPermissions.allows(member.getRole(), permission)) {
      throw new ForbiddenException(
          "INSUFFICIENT_PERMISSION", "Your role doesn't allow this action.");
    }
    return member;
  }

  @Transactional
  public SpaceMemberResponse addMember(
      UUID actingUserId, UUID spaceId, AddSpaceMemberRequest request) {
    requirePermission(actingUserId, spaceId, BusinessPermission.MANAGE_TEAM);
    User invitee =
        users
            .findByEmailIgnoreCase(request.email().trim())
            .orElseThrow(
                () ->
                    new NotFoundException("USER_NOT_FOUND", "No Duitlah account with that email."));

    Optional<SpaceMember> existing = members.findBySpaceIdAndUserId(spaceId, invitee.getId());
    SpaceMember member;
    if (existing.isPresent() && existing.get().isActive()) {
      throw new ConflictException("ALREADY_A_MEMBER", "This user is already on the team.");
    } else if (existing.isPresent()) {
      member = existing.get();
      member.setRole(request.role());
      member.setStatus(MemberStatus.ACTIVE);
    } else {
      member = new SpaceMember(spaceId, invitee.getId(), request.role());
    }
    members.save(member);
    return toMemberResponse(member, invitee);
  }

  public List<SpaceMemberResponse> listMembers(UUID userId, UUID spaceId) {
    requireMembership(userId, spaceId);
    return members.findBySpaceIdAndStatus(spaceId, MemberStatus.ACTIVE).stream()
        .map(member -> toMemberResponse(member, users.findById(member.getUserId()).orElse(null)))
        .toList();
  }

  @Transactional
  public SpaceMemberResponse changeRole(
      UUID actingUserId, UUID spaceId, UUID memberId, ChangeSpaceMemberRoleRequest request) {
    requirePermission(actingUserId, spaceId, BusinessPermission.MANAGE_TEAM);
    SpaceMember member = requireTeamMember(spaceId, memberId);
    if (member.getRole() == SpaceRole.OWNER
        && request.role() != SpaceRole.OWNER
        && soleOwner(spaceId, member)) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "LAST_OWNER",
          "A business space must always have at least one owner.");
    }
    member.setRole(request.role());
    members.save(member);
    return toMemberResponse(member, users.findById(member.getUserId()).orElse(null));
  }

  @Transactional
  public void removeMember(UUID actingUserId, UUID spaceId, UUID memberId) {
    requirePermission(actingUserId, spaceId, BusinessPermission.MANAGE_TEAM);
    SpaceMember member = requireTeamMember(spaceId, memberId);
    if (member.getRole() == SpaceRole.OWNER && soleOwner(spaceId, member)) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "LAST_OWNER",
          "A business space must always have at least one owner.");
    }
    member.setStatus(MemberStatus.REMOVED);
    members.save(member);
  }

  /**
   * System-use only (no acting-user check) — for scheduled jobs that need to notify whoever can act
   * on something in a space, without a specific member driving the call (e.g. {@code
   * inventory.LowStockAlertScheduler}).
   */
  public List<UUID> listActiveMemberUserIdsWithPermission(
      UUID spaceId, BusinessPermission permission) {
    return members.findBySpaceIdAndStatus(spaceId, MemberStatus.ACTIVE).stream()
        .filter(m -> BusinessPermissions.allows(m.getRole(), permission))
        .map(SpaceMember::getUserId)
        .toList();
  }

  private boolean soleOwner(UUID spaceId, SpaceMember owner) {
    return members.findBySpaceIdAndStatus(spaceId, MemberStatus.ACTIVE).stream()
        .filter(m -> m.getRole() == SpaceRole.OWNER)
        .allMatch(m -> m.getId().equals(owner.getId()));
  }

  private SpaceMember requireTeamMember(UUID spaceId, UUID memberId) {
    return members
        .findById(memberId)
        .filter(m -> m.getSpaceId().equals(spaceId) && m.isActive())
        .orElseThrow(() -> new NotFoundException("MEMBER_NOT_FOUND", "Team member not found."));
  }

  private static SpaceMemberResponse toMemberResponse(SpaceMember member, User user) {
    return new SpaceMemberResponse(
        member.getId(),
        member.getUserId(),
        user != null ? user.getDisplayName() : null,
        user != null ? user.getEmail() : null,
        member.getRole(),
        member.getStatus());
  }

  private NotFoundException notFound() {
    return new NotFoundException("SPACE_NOT_FOUND", "Space not found.");
  }
}
