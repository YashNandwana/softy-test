# ── Build Stage ───────────────────────────────────────────────────────────────
FROM golang:1.20-alpine AS builder

# Set working dir
WORKDIR /app

# Cache and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o basic-go-app .

# ── Runtime Stage ─────────────────────────────────────────────────────────────
FROM scratch

# Copy the statically-linked binary
COPY --from=builder /app/basic-go-app /basic-go-app

EXPOSE 8080

ENTRYPOINT ["/basic-go-app"]
