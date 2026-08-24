package com.duitlah.api.auth;

import com.duitlah.api.users.UserResponse;

public record AuthTokenResponse(String accessToken, UserResponse user) {}
