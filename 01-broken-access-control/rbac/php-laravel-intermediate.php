<?php
// Feature        : Role-Based Access Control (RBAC) — Laravel Gates and Policies
// Language       : PHP 8.2
// Framework      : Laravel 11
// Level          : Intermediate
// OWASP          : A01 — Broken Access Control
// Protects       : Against unauthorised access using Laravel's built-in gate system
// Does NOT cover : Fine-grained resource ownership beyond simple policies
// Dependencies   : See composer.json in this folder
// Tested on      : PHP 8.2.15, Laravel 11.0.3
// Last reviewed  : 2024-03-01

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// File 1: app/Models/User.php
// Add a 'role' column to your users table migration first:
//   $table->string('role')->default('viewer');
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    protected $fillable = ['name', 'email', 'password', 'role'];

    // Role hierarchy — method to check if user meets minimum role
    const ROLE_HIERARCHY = ['viewer' => 10, 'editor' => 20, 'admin' => 40];

    public function hasRole(string $role): bool
    {
        $userLevel = self::ROLE_HIERARCHY[$this->role] ?? 0;
        $requiredLevel = self::ROLE_HIERARCHY[$role] ?? 0;
        return $userLevel >= $requiredLevel;
    }

    public function isAdmin(): bool    { return $this->hasRole('admin'); }
    public function isEditor(): bool   { return $this->hasRole('editor'); }
    public function isViewer(): bool   { return $this->hasRole('viewer'); }
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// File 2: app/Providers/AppServiceProvider.php
// Register gates in the boot() method
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        // Define gates using the role hierarchy
        Gate::define('view-posts',   fn(User $u) => $u->hasRole('viewer'));
        Gate::define('edit-posts',   fn(User $u) => $u->hasRole('editor'));
        Gate::define('admin-access', fn(User $u) => $u->hasRole('admin'));

        // Superadmin bypass — admins pass all gate checks automatically
        Gate::before(fn(User $u) => $u->role === 'admin' ? true : null);
    }
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// File 3: app/Http/Controllers/PostController.php
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

use Illuminate\Http\{Request, JsonResponse};
use Illuminate\Support\Facades\{Auth, Gate};

class PostController
{
    // Middleware approach — apply in constructor or route definition
    public function __construct()
    {
        $this->middleware('auth');
        $this->middleware(fn($req, $next) =>
            Auth::user()->hasRole('editor') ? $next($req) : abort(403)
        )->only(['store', 'update', 'destroy']);
    }

    public function index(): JsonResponse
    {
        // Gate::authorize throws 403 automatically if denied
        Gate::authorize('view-posts');
        return response()->json(['posts' => []]);
    }

    public function store(Request $request): JsonResponse
    {
        Gate::authorize('edit-posts');
        return response()->json(['created' => true], 201);
    }

    public function destroy(string $id): JsonResponse
    {
        Gate::authorize('admin-access');
        return response()->json(['deleted' => $id]);
    }
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// File 4: routes/api.php — Route-level middleware
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/posts', [PostController::class, 'index']);

    Route::middleware(fn($req, $next) =>
        $req->user()->hasRole('editor') ? $next($req) : abort(403, 'Editor role required')
    )->group(function () {
        Route::post('/posts', [PostController::class, 'store']);
    });

    Route::middleware(fn($req, $next) =>
        $req->user()->hasRole('admin') ? $next($req) : abort(403, 'Admin role required')
    )->group(function () {
        Route::delete('/admin/users/{id}', fn($id) => response()->json(['deleted' => $id]));
    });
});
