"use client";

import { useQuery } from "@tanstack/react-query";
import { UsersIcon } from "lucide-react";
import Link from "next/link";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { groupTypes } from "@/lib/validation/group";
import type { Group } from "@/types/group";
import { CreateGroupDialog } from "./create-group-dialog";
import { JoinGroupDialog } from "./join-group-dialog";

function groupIcon(type: string) {
  return groupTypes.find((t) => t.value === type)?.icon ?? "👥";
}

export default function GroupsPage() {
  const { data: groups, isLoading } = useQuery({
    queryKey: ["groups"],
    queryFn: () => apiClient.get<Group[]>("/api/v1/groups"),
  });

  const activeGroups = groups?.filter((g) => !g.archived) ?? [];

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <h1 className="text-2xl font-semibold tracking-tight">Groups</h1>
            <div className="flex gap-2">
              <JoinGroupDialog />
              <CreateGroupDialog />
            </div>
          </div>

          {isLoading && (
            <div className="space-y-3">
              {Array.from({ length: 2 }).map((_, i) => (
                <Skeleton key={i} className="h-16 w-full" />
              ))}
            </div>
          )}

          {activeGroups.length === 0 && !isLoading && (
            <EmptyState
              icon={UsersIcon}
              title="No groups yet."
              description="Create a group for housemates, a trip, or friends — and split shared expenses without the awkward math."
              action={<CreateGroupDialog />}
            />
          )}

          <div className="space-y-2">
            {activeGroups.map((group) => (
              <Link key={group.id} href={`/groups/${group.id}`}>
                <Card>
                  <CardContent className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium">
                        {groupIcon(group.type)} {group.name}
                      </p>
                      <p className="text-muted-foreground text-xs">
                        {group.memberCount} {group.memberCount === 1 ? "member" : "members"}
                      </p>
                    </div>
                    {group.yourRole === "OWNER" && (
                      <span className="text-muted-foreground text-xs">Owner</span>
                    )}
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        </div>
      </AppShell>
    </RequireAuth>
  );
}
