// Feature        : Role-Based Access Control (RBAC) — Spring Security
// Language       : Java 21
// Framework      : Spring Boot 3.2
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against unauthorised access using Spring Security method and route security
// Does NOT cover : Row-level security, multi-tenancy, ABAC
// Dependencies   : See pom.xml in this folder
// Tested on      : Java 21, Spring Boot 3.2.3, jjwt 0.12.5
// Last reviewed  : 2024-03-01

package com.websecuritysnippets.rbac;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.*;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

// ── JWT Utility ───────────────────────────────────────────────────────────────
class JwtUtil {
    private final SecretKey key;

    public JwtUtil(@Value("${jwt.secret}") String secret) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    public Claims parse(String token) {
        return Jwts.parser().verifyWith(key).build()
                .parseSignedClaims(token).getPayload();
    }
}

// ── JWT Filter ────────────────────────────────────────────────────────────────
class JwtAuthFilter extends OncePerRequestFilter {
    private final JwtUtil jwtUtil;

    JwtAuthFilter(JwtUtil jwtUtil) { this.jwtUtil = jwtUtil; }

    @Override
    protected void doFilterInternal(HttpServletRequest req,
                                    HttpServletResponse res,
                                    FilterChain chain)
            throws java.io.IOException, jakarta.servlet.ServletException {

        String header = req.getHeader("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            chain.doFilter(req, res);
            return;
        }

        try {
            Claims claims = jwtUtil.parse(header.substring(7));
            String role = claims.get("role", String.class);

            List<SimpleGrantedAuthority> authorities = List.of(
                    new SimpleGrantedAuthority("ROLE_" + role.toUpperCase())
            );

            UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(claims.getSubject(), null, authorities);

            SecurityContextHolder.getContext().setAuthentication(auth);
        } catch (JwtException ignored) {
            res.setStatus(HttpStatus.UNAUTHORIZED.value());
            return;
        }

        chain.doFilter(req, res);
    }
}

// ── Security Config ───────────────────────────────────────────────────────────
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, JwtUtil jwtUtil) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers(org.springframework.http.HttpMethod.POST, "/posts").hasAnyRole("EDITOR", "ADMIN")
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/posts").hasAnyRole("VIEWER", "EDITOR", "ADMIN")
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthFilter(jwtUtil), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}

// ── Controller ────────────────────────────────────────────────────────────────
@RestController
class PostController {

    @GetMapping("/posts")
    @PreAuthorize("hasAnyRole('VIEWER','EDITOR','ADMIN')")
    public Map<String, Object> listPosts() {
        return Map.of("posts", List.of("Post 1", "Post 2"));
    }

    @PostMapping("/posts")
    @PreAuthorize("hasAnyRole('EDITOR','ADMIN')")
    public Map<String, Boolean> createPost() {
        return Map.of("created", true);
    }

    @DeleteMapping("/admin/users/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Map<String, String> deleteUser(@PathVariable String id) {
        return Map.of("deleted", id);
    }
}
