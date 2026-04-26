// Feature        : Attribute-Based Access Control (ABAC) — Gin policy middleware
// Language       : Go 1.22
// Framework      : Gin 1.9
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against context-insensitive access decisions
// Does NOT cover : External policy engines (OPA, Cedar)
// Dependencies   : See go.mod in this folder
// Tested on      : Go 1.22, Gin 1.9.1, golang-jwt/jwt v5.2.1
// Last reviewed  : 2024-03-01

package abac

import (
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// ── Attribute types ───────────────────────────────────────────────────────────

type Subject struct {
	UserID      string
	Role        string
	MFAVerified bool
	Clearance   int
}

type Resource struct {
	ID                string
	OwnerID           string
	Status            string
	ClearanceRequired int
}

type Environment struct {
	IsBusinessHours bool
	IP              string
}

type PolicyFn func(Subject, Resource, Environment) (bool, string)

// ── JWT parsing ───────────────────────────────────────────────────────────────

type claims struct {
	Sub         string `json:"sub"`
	Role        string `json:"role"`
	MFAVerified bool   `json:"mfa_verified"`
	Clearance   int    `json:"clearance"`
	jwt.RegisteredClaims
}

func subjectFromContext(c *gin.Context) (Subject, bool) {
	raw, exists := c.Get("subject")
	if !exists { return Subject{}, false }
	s, ok := raw.(Subject)
	return s, ok
}

func AuthMiddleware() gin.HandlerFunc {
	key := []byte(os.Getenv("SECRET_KEY"))
	return func(c *gin.Context) {
		header := c.GetHeader("Authorization")
		if !strings.HasPrefix(header, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "token required"})
			return
		}
		cl := &claims{}
		tok, err := jwt.ParseWithClaims(strings.TrimPrefix(header, "Bearer "), cl, func(t *jwt.Token) (interface{}, error) {
			return key, nil
		})
		if err != nil || !tok.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
			return
		}
		c.Set("subject", Subject{UserID: cl.Sub, Role: cl.Role, MFAVerified: cl.MFAVerified, Clearance: cl.Clearance})
		c.Next()
	}
}

// ── Policy middleware ─────────────────────────────────────────────────────────

func ABAC(policy PolicyFn, loadResource func(*gin.Context) Resource) gin.HandlerFunc {
	return func(c *gin.Context) {
		subject, ok := subjectFromContext(c)
		if !ok { c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "no subject"}); return }

		resource := loadResource(c)
		now := time.Now().UTC()
		env := Environment{
			IsBusinessHours: now.Hour() >= 9 && now.Hour() < 18 && now.Weekday() > 0 && now.Weekday() < 6,
			IP:              c.ClientIP(),
		}

		allowed, reason := policy(subject, resource, env)
		if !allowed { c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "access denied", "reason": reason}); return }

		c.Set("resource", resource)
		c.Next()
	}
}

// ── Policies ──────────────────────────────────────────────────────────────────

func CanRead(s Subject, r Resource, e Environment) (bool, string) {
	if r.Status == "published" && s.Clearance >= r.ClearanceRequired { return true, "published+clearance" }
	if r.OwnerID == s.UserID { return true, "owner" }
	if s.Role == "editor" || s.Role == "admin" { return true, "editor/admin" }
	return false, "no read policy matched"
}

func CanEdit(s Subject, r Resource, e Environment) (bool, string) {
	if r.Status == "archived" { return false, "archived" }
	if r.OwnerID == s.UserID && r.Status == "draft" { return true, "owner editing draft" }
	if s.Role == "admin" && e.IsBusinessHours && s.MFAVerified { return true, "admin+MFA+hours" }
	return false, "no edit policy matched"
}

func CanDelete(s Subject, r Resource, e Environment) (bool, string) {
	if s.Role == "admin" && s.MFAVerified { return true, "admin+MFA" }
	return false, "requires admin+MFA"
}

// ── Resource loaders (replace with DB) ───────────────────────────────────────

func LoadDocument(c *gin.Context) Resource {
	return Resource{ID: c.Param("id"), OwnerID: "user_42", Status: "draft", ClearanceRequired: 1}
}

// ── Router ────────────────────────────────────────────────────────────────────

func SetupRouter() *gin.Engine {
	r := gin.New()
	r.Use(AuthMiddleware())

	r.GET("/documents/:id",    ABAC(CanRead,   LoadDocument), func(c *gin.Context) { c.JSON(200, gin.H{"doc": c.Param("id")}) })
	r.PATCH("/documents/:id",  ABAC(CanEdit,   LoadDocument), func(c *gin.Context) { c.JSON(200, gin.H{"updated": true}) })
	r.DELETE("/documents/:id", ABAC(CanDelete, LoadDocument), func(c *gin.Context) { c.JSON(200, gin.H{"deleted": true}) })

	return r
}
