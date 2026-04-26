// Feature        : Role-Based Access Control (RBAC) — ASP.NET Core authorization
// Language       : C# 12 / .NET 8
// Framework      : ASP.NET Core 8
// Level          : Intermediate
// OWASP          : A01 — Broken Access Control
// Protects       : Against unauthorised endpoint access using ASP.NET Core role claims
// Does NOT cover : Resource-based authorization, policy composition
// Dependencies   : Microsoft.AspNetCore.Authentication.JwtBearer (included in SDK)
// Tested on      : .NET 8.0, ASP.NET Core 8.0
// Last reviewed  : 2024-03-01

using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// REPLACE: load from configuration, not hardcoded
var secretKey = builder.Configuration["Jwt:SecretKey"]
    ?? throw new InvalidOperationException("JWT SecretKey not configured");

// ── Authentication and Authorization setup ────────────────────────────────────
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
            ValidateIssuer   = false,  // Set to true and configure ValidIssuer in production
            ValidateAudience = false,  // Set to true and configure ValidAudience in production
            ValidateLifetime = true,
            ClockSkew        = TimeSpan.Zero, // No tolerance on token expiry
        };
    });

// Define named authorization policies mapped to roles
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("ViewerOrAbove", policy => policy.RequireRole("viewer", "editor", "admin"));
    options.AddPolicy("EditorOrAbove", policy => policy.RequireRole("editor", "admin"));
    options.AddPolicy("AdminOnly",     policy => policy.RequireRole("admin"));
});

builder.Services.AddControllers();

var app = builder.Build();

app.UseAuthentication(); // Must come before UseAuthorization
app.UseAuthorization();

// ── Minimal API route examples ────────────────────────────────────────────────

// Public — no authentication required
app.MapGet("/public", () => Results.Ok(new { message = "Public endpoint" }));

// Requires any authenticated user with viewer role or above
app.MapGet("/posts", (ClaimsPrincipal user) =>
{
    var userId = user.FindFirstValue(ClaimTypes.NameIdentifier);
    return Results.Ok(new { posts = Array.Empty<string>(), user = userId });
}).RequireAuthorization("ViewerOrAbove");

// Requires editor or admin
app.MapPost("/posts", () =>
    Results.Created("/posts/1", new { created = true })
).RequireAuthorization("EditorOrAbove");

// Requires admin only
app.MapDelete("/admin/users/{id}", (string id) =>
    Results.Ok(new { deleted = id })
).RequireAuthorization("AdminOnly");

app.MapControllers();
app.Run();


// ── Controller-based approach with [Authorize] attribute ──────────────────────

[ApiController]
[Route("[controller]")]
[Authorize] // Requires authentication for the entire controller
public class AdminController : ControllerBase
{
    [HttpGet("users")]
    [Authorize(Policy = "AdminOnly")] // Override with stricter policy
    public IActionResult GetUsers()
    {
        var currentUser = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Ok(new { users = new[] { "user_1", "user_2" }, requestedBy = currentUser });
    }

    [HttpDelete("users/{id}")]
    [Authorize(Roles = "admin")] // Can also use Roles directly
    public IActionResult DeleteUser(string id)
    {
        return Ok(new { deleted = id });
    }
}
