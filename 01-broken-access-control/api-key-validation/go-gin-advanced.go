// Feature        : API Key Validation — Prefixed keys, HMAC hashing, scopes
// Language       : Go 1.22
// Framework      : Gin 1.9
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against plain-text key storage, brute force, scope bypass
// Does NOT cover : Key rotation UI, distributed key store
// Dependencies   : See go.mod in this folder
// Tested on      : Go 1.22, Gin 1.9.1
// Last reviewed  : 2024-03-01

package apikey

import (
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

const keyPrefix = "wss_"
const prefixLen = 8

type KeyRecord struct {
	Hash       string
	ClientID   string
	Scopes     []string
	Active     bool
	CreatedAt  time.Time
	LastUsedAt *time.Time
}

type Store struct {
	mu   sync.RWMutex
	keys map[string]*KeyRecord // prefix → record
}

func NewStore() *Store { return &Store{keys: make(map[string]*KeyRecord)} }

func hmacSecret() []byte { return []byte(os.Getenv("HMAC_SECRET")) }

func hashKey(raw string) string {
	mac := hmac.New(sha256.New, hmacSecret())
	mac.Write([]byte(raw))
	return hex.EncodeToString(mac.Sum(nil))
}

func (s *Store) Issue(clientID string, scopes []string) (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil { return "", err }
	random  := base64.RawURLEncoding.EncodeToString(b)
	prefix  := random[:prefixLen]
	rawKey  := fmt.Sprintf("%s%s_%s", keyPrefix, prefix, random[prefixLen:])

	s.mu.Lock()
	defer s.mu.Unlock()
	s.keys[prefix] = &KeyRecord{
		Hash: hashKey(rawKey), ClientID: clientID,
		Scopes: scopes, Active: true, CreatedAt: time.Now(),
	}
	return rawKey, nil
}

func (s *Store) Verify(rawKey string) *KeyRecord {
	if !strings.HasPrefix(rawKey, keyPrefix) { return nil }
	withoutPrefix := rawKey[len(keyPrefix):]
	if len(withoutPrefix) < prefixLen { return nil }
	prefix := withoutPrefix[:prefixLen]

	s.mu.RLock()
	record, ok := s.keys[prefix]
	s.mu.RUnlock()
	if !ok || !record.Active { return nil }

	expected, _ := hex.DecodeString(record.Hash)
	incoming, _ := hex.DecodeString(hashKey(rawKey))
	if subtle.ConstantTimeCompare(expected, incoming) != 1 { return nil }

	now := time.Now()
	record.LastUsedAt = &now
	return record
}

func (s *Store) Revoke(clientID string) int {
	s.mu.Lock()
	defer s.mu.Unlock()
	count := 0
	for _, r := range s.keys {
		if r.ClientID == clientID && r.Active { r.Active = false; count++ }
	}
	return count
}

func (s *Store) Middleware(scopes ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		rawKey := c.GetHeader("X-API-Key")
		if rawKey == "" { c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "api key required"}); return }

		record := s.Verify(rawKey)
		if record == nil { c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid key"}); return }

		for _, required := range scopes {
			found := false
			for _, s := range record.Scopes { if s == required { found = true; break } }
			if !found { c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "insufficient scope", "required": required}); return }
		}

		c.Set("client", record)
		c.Next()
	}
}

func SetupRouter(store *Store) *gin.Engine {
	r := gin.New()

	r.POST("/keys", func(c *gin.Context) {
		var body struct { ClientID string `json:"clientId"`; Scopes []string `json:"scopes"` }
		if err := c.ShouldBindJSON(&body); err != nil { c.JSON(400, gin.H{"error": err.Error()}); return }
		key, err := store.Issue(body.ClientID, body.Scopes)
		if err != nil { c.JSON(500, gin.H{"error": "key generation failed"}); return }
		c.JSON(201, gin.H{"key": key, "warning": "store securely — not shown again"})
	})

	r.GET("/api/data",  store.Middleware("read:data"),  func(c *gin.Context) { c.JSON(200, gin.H{"data": []interface{}{}}) })
	r.POST("/api/data", store.Middleware("write:data"), func(c *gin.Context) { c.JSON(201, gin.H{"created": true}) })

	return r
}
