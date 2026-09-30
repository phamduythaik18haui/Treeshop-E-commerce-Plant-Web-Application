package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Roles;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.repository.RoleRepository;
import com.devpro.treeshop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Controller
@RequestMapping("/client/auth")
public class SocialAuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${social.google.client-id:}")
    private String googleClientId;

    @Value("${social.google.client-secret:}")
    private String googleClientSecret;

    @Value("${social.google.redirect-uri:http://localhost:8080/client/auth/google/callback}")
    private String googleRedirectUri;

    @Value("${social.facebook.client-id:}")
    private String facebookClientId;

    @Value("${social.facebook.client-secret:}")
    private String facebookClientSecret;

    @Value("${social.facebook.redirect-uri:http://localhost:8080/client/auth/facebook/callback}")
    private String facebookRedirectUri;

    @GetMapping("/google")
    public ResponseEntity<Void> google(HttpSession session) {
        if (googleClientId == null || googleClientId.isBlank() || googleClientSecret == null || googleClientSecret.isBlank()) {
            return redirectToLogin("Google login chưa được cấu hình trong application.properties");
        }
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state_google", state);
        String url = UriComponentsBuilder.fromHttpUrl("https://accounts.google.com/o/oauth2/v2/auth")
                .queryParam("client_id", googleClientId)
                .queryParam("redirect_uri", googleRedirectUri)
                .queryParam("response_type", "code")
                .queryParam("scope", "openid profile email")
                .queryParam("state", state)
                .queryParam("prompt", "select_account")
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        return ResponseEntity.status(HttpStatus.FOUND).location(URI.create(url)).build();
    }

    @GetMapping("/google/callback")
    public String googleCallback(@RequestParam(value = "code", required = false) String code,
                                 @RequestParam(value = "state", required = false) String state,
                                 @RequestParam(value = "error", required = false) String error,
                                 HttpSession session) {
        if (error != null) {
            return redirectToLoginPath("Google login bị hủy hoặc bị từ chối: " + error);
        }
        if (!isValidState(session, "oauth_state_google", state) || code == null || code.isBlank()) {
            return redirectToLoginPath("Phiên đăng nhập Google không hợp lệ, vui lòng thử lại.");
        }

        try {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("code", code);
        form.add("client_id", googleClientId);
        form.add("client_secret", googleClientSecret);
        form.add("redirect_uri", googleRedirectUri);
        form.add("grant_type", "authorization_code");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        Map tokenResponse = restTemplate.postForObject("https://oauth2.googleapis.com/token", new HttpEntity<>(form, headers), Map.class);
        String accessToken = tokenResponse == null ? null : String.valueOf(tokenResponse.get("access_token"));
        if (accessToken == null || accessToken.isBlank()) {
            return "redirect:/client/login?error=google_token";
        }

        HttpHeaders userHeaders = new HttpHeaders();
        userHeaders.setBearerAuth(accessToken);
        ResponseEntity<Map> userInfoResponse = restTemplate.exchange("https://openidconnect.googleapis.com/v1/userinfo", HttpMethod.GET, new HttpEntity<>(userHeaders), Map.class);
        Map body = userInfoResponse.getBody();
        if (body == null) {
            return "redirect:/client/login?error=google_profile";
        }

        String email = body.get("email") == null ? "google_" + body.get("id") + "@treeshop.local" : String.valueOf(body.get("email"));
        String name = body.get("name") == null ? "Google User" : String.valueOf(body.get("name"));
        Users user = createOrUpdateSocialUser(email, name, "GOOGLE");
        session.setAttribute("user", user);
        return "redirect:/client/indexs";
        } catch (Exception ex) {
            return redirectToLoginPath("Đăng nhập Google thất bại: " + safeMessage(ex));
        }
    }

    @GetMapping("/facebook")
    public ResponseEntity<Void> facebook(HttpSession session) {
        if (facebookClientId == null || facebookClientId.isBlank() || facebookClientSecret == null || facebookClientSecret.isBlank()) {
            return redirectToLogin("Facebook login chưa được cấu hình trong application.properties");
        }
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state_facebook", state);
        String url = UriComponentsBuilder.fromHttpUrl("https://www.facebook.com/dialog/oauth")
                .queryParam("client_id", facebookClientId)
                .queryParam("redirect_uri", facebookRedirectUri)
                .queryParam("scope", "email,public_profile")
                .queryParam("state", state)
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        return ResponseEntity.status(HttpStatus.FOUND).location(URI.create(url)).build();
    }

    @GetMapping("/facebook/callback")
    public String facebookCallback(@RequestParam(value = "code", required = false) String code,
                                   @RequestParam(value = "state", required = false) String state,
                                   @RequestParam(value = "error", required = false) String error,
                                   HttpSession session) {
        if (error != null) {
            return redirectToLoginPath("Facebook login bị hủy hoặc bị từ chối: " + error);
        }
        if (!isValidState(session, "oauth_state_facebook", state) || code == null || code.isBlank()) {
            return redirectToLoginPath("Phiên đăng nhập Facebook không hợp lệ, vui lòng thử lại.");
        }

        try {
        String tokenUrl = UriComponentsBuilder.fromHttpUrl("https://graph.facebook.com/oauth/access_token")
                .queryParam("client_id", facebookClientId)
                .queryParam("client_secret", facebookClientSecret)
                .queryParam("redirect_uri", facebookRedirectUri)
                .queryParam("code", code)
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        Map tokenResponse = restTemplate.getForObject(tokenUrl, Map.class);
        String accessToken = tokenResponse == null ? null : String.valueOf(tokenResponse.get("access_token"));
        if (accessToken == null || accessToken.isBlank()) {
            return "redirect:/client/login?error=facebook_token";
        }

        String userInfoUrl = UriComponentsBuilder.fromHttpUrl("https://graph.facebook.com/me")
                .queryParam("fields", "id,name,email")
                .queryParam("access_token", accessToken)
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        Map body = restTemplate.getForObject(userInfoUrl, Map.class);
        if (body == null) {
            return "redirect:/client/login?error=facebook_profile";
        }

        String email = body.get("email") == null ? "facebook_" + body.get("id") + "@treeshop.local" : String.valueOf(body.get("email"));
        String name = body.get("name") == null ? "Facebook User" : String.valueOf(body.get("name"));
        Users user = createOrUpdateSocialUser(email, name, "FACEBOOK");
        session.setAttribute("user", user);
        return "redirect:/client/indexs";
        } catch (Exception ex) {
            return redirectToLoginPath("Đăng nhập Facebook thất bại: " + safeMessage(ex));
        }
    }

    private boolean isValidState(HttpSession session, String key, String state) {
        Object expected = session.getAttribute(key);
        session.removeAttribute(key);
        return expected != null && expected.equals(state);
    }

    private Users createOrUpdateSocialUser(String email, String name, String provider) {
        Optional<Users> existing = userService.findByEmailIgnoreCase(email);
        if (existing.isPresent()) {
            Users user = existing.get();
            user.setFullName(name);
            user.setProvider(provider);
            return userService.saveUser(user);
        }

        Roles role = roleRepository.findById(3).orElseGet(() -> {
            Roles fallback = new Roles();
            fallback.setId(3);
            fallback.setName("USER");
            return fallback;
        });

        Users user = new Users();
        user.setUsername(email);
        user.setEmail(email);
        user.setFullName(name);
        user.setPassword(UUID.randomUUID().toString().substring(0, 12));
        user.setProvider(provider);
        user.setRoles(role);
        return userService.saveUser(user);
    }

    private String redirectToLoginPath(String message) {
        String url = UriComponentsBuilder.fromPath("/client/login")
                .queryParam("message", message)
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        return "redirect:" + url;
    }

    private String safeMessage(Exception ex) {
        String message = ex.getMessage();
        if (message == null || message.isBlank()) {
            return "lỗi không xác định";
        }
        return message.length() > 160 ? message.substring(0, 160) + "..." : message;
    }

    private ResponseEntity<Void> redirectToLogin(String message) {
        String url = UriComponentsBuilder.fromPath("/client/login")
                .queryParam("message", message)
                .build()
                .encode(StandardCharsets.UTF_8)
                .toUriString();
        return ResponseEntity.status(HttpStatus.FOUND).location(URI.create(url)).build();
    }
}
