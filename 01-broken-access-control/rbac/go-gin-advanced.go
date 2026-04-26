// Feature        : Role-Based Access Control (RBAC) — Gin middleware
// Language       : Go 1.22
// Framework      : Gin 1.9
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against unauthorised route access via JWT role claims
// Does NOT cover : Database-backed dynamic roles, multi-tenancy
// Dependencies   : See go.mod in this folder
// Tested on      : Go 1.22, Gin 1.9.1, golang-jwt/jwt v5.2.1
// Last reviewed  : 2024-03-01

package rbac

import (
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

type Role int

const (
	RoleViewer    Role = 10
	RoleEditor    Role = 20
	RoleModerator Role = 30
	RoleAdmin     Role = 40
	RoleSuperAdmin Role = 50
)

var roleMap = map[string]Role{
	"viewer":     RoleViewer,
	"editor":     RoleEditor,
	"moderator":  RoleModerator,
	"admin":      RoleAdmin,
	"superadmin": RoleSuperAdmin,
}

type Claims struct {
	Sub  string `json:"sub"`
	Role string `json:"role"`
	jwt.RegisteredClaims
}

func secretKey() []byte {
	return []byte(os.Getenv("SECRET_KEY"))
}

// Authenticate verifies the JWT and injects claims into the Gin context.
func Authenticate() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "authentication required"})
			return
		}

		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
		claims := &Claims{}

		token, err := jwt.ParseWithClaims(tokenStr, claims, func(t *jwt.Token) (interface{}, error) {
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return secretKey(), nil
		})

		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
			return
		}

		c.Set("claims", claims)
		c.Next()
	}
}

// RequireRole middleware enforces a minimum role level.
func RequireRole(minimum Role) gin.HandlerFunc {
	return func(c *gin.Context) {
		raw, exists := c.Get("claims")
		if !exists {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "no claims"})
			return
		}

		claims := raw.(*Claims)
		userRole, ok := roleMap[strings.ToLower(claims.Role)]
		if !ok || userRole < minimum {
			c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "insufficient role"})
			return
		}

		c.Next()
	}
}

// SetupRouter returns a configured Gin router with RBAC-protected routes.
func SetupRouter() *gin.Engine {
	r := gin.New()
	r.Use(gin.Recovery())

	auth := r.Group("/")
	auth.Use(Authenticate())
	{
		auth.GET("/posts", RequireRole(RoleViewer), func(c *gin.Context) {
			claims := c.MustGet("claims").(*Claims)
			c.JSON(http.StatusOK, gin.H{"posts": []string{}, "user": claims.Sub})
		})

		auth.POST("/posts", RequireRole(RoleEditor), func(c *gin.Context) {
			c.JSON(http.StatusCreated, gin.H{"created": true})
		})

		auth.DELETE("/admin/users/:id", RequireRole(RoleAdmin), func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"deleted": c.Param("id")})
		})

		auth.PATCH("/config", RequireRole(RoleSuperAdmin), func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"updated": true})
		})
	}

	return r
}
