# O11y Fly Shipper

A Fly.io log shipper application for observability (o11y) infrastructure.

## Overview

This application uses the official Fly.io log shipper Docker image to collect and forward logs for observability purposes.

## Configuration

The application is configured via `fly.toml`:

- **App Name**: o11y
- **Primary Region**: ewr (Newark)
- **Memory**: 1GB
- **CPU**: 1 shared CPU
- **Image**: `ghcr.io/superfly/fly-log-shipper:latest`
- **Internal Port**: 8686

## Quick Start

### Prerequisites

- Fly.io account
- flyctl CLI tool
- Grafana Cloud Loki instance (or other Loki endpoint)

### Installation

```bash
# Install flyctl if you haven't already
curl -L https://fly.io/install.sh | sh

# Clone and navigate to project
cd fly_shipper

# Deploy the application
fly deploy
```

## Secret Management

The app requires several secrets to be configured:

```bash
# Set your organization (use the slug, not display name)
fly secrets set ORG="personal" -a o11y

# Set Loki credentials
fly secrets set LOKI_USERNAME="your-username" -a o11y
fly secrets set LOKI_PASSWORD="your-grafana-cloud-api-key" -a o11y
fly secrets set LOKI_URL="https://logs-prod-xxx.grafana.net/loki/api/v1/push" -a o11y

# Set access token (if required)
fly secrets set ACCESS_TOKEN="your-fly-access-token" -a o11y
```

### Finding Your Organization Slug

Your organization slug is different from the display name:

```bash
# List your organizations
fly orgs list

# Use the "Slug" column value, not the "Name" column
# Example: "personal" not "Arno Burnuk"
```

## Troubleshooting

### Checking Access to Your Fly App

```bash
# 1. Verify you're logged in
flyctl auth whoami

# 2. List your apps
flyctl apps list

# 3. Check specific app status
flyctl status --app o11y

# 4. Check running machines
flyctl machines list --app o11y
```

### Common Issues and Solutions

#### 1. Authentication Errors ("You must be authenticated to view this")

**Problem**: Using display name instead of organization slug
```bash
# ❌ Wrong - using display name
fly secrets set ORG="ORG NAME" -a o11y

# ✅ Correct - using slug
fly secrets set ORG="org slug" -a o11y
```

#### 2. NATS Authorization Violations (Crash Loop)

**Symptoms**:
```
ERROR vector::topology: Configuration error. error=Source "nats": NATS Connect Error: unexpected line while connecting: Err("Authorization Violation")
INFO Main child exited normally with code: 78
```

**Solution**: Set the correct ORG secret using your organization slug:
```bash
fly secrets set ORG="personal" -a o11y
```

#### 3. Loki 404 Errors

**Symptoms**:
```
ERROR vector::topology::builder: msg="Healthcheck failed." error=A non-successful status returned: 404 Not Found component_kind="sink" component_type="loki"
```

**Solution**: Verify your Loki URL format. Vector expects the base URL, not the full push endpoint:
```bash
# Check current URL
fly secrets list -a o11y

# Update if needed (example for Grafana Cloud)
fly secrets set LOKI_URL="https://logs-prod-xxx.grafana.net" -a o11y
```

### Health Monitoring

#### Check App Logs
```bash
# View recent logs
fly logs -a o11y

# Follow logs in real-time
fly logs -a o11y -f

# Check specific machine logs
fly logs -i MACHINE_ID
```

#### Check App Status
```bash
# General status
fly status -a o11y

# List secrets (shows names only, not values)
fly secrets list -a o11y

# Check machine details
fly machines list -a o11y
```

#### Healthy Log Indicators
- ✅ `Vector has started` message
- ✅ `API server running` on port 8686
- ✅ `Healthcheck passed` messages
- ✅ No NATS authorization errors
- ✅ No crash/reboot cycles

#### Unhealthy Log Indicators
- ❌ NATS `Authorization Violation` errors
- ❌ `Main child exited normally with code: 78`
- ❌ Frequent reboots/restarts
- ❌ Loki `404 Not Found` errors
- ❌ `Events dropped` messages

## Architecture

- **Vector**: Log processing engine
- **NATS**: Message queue for Fly.io logs
- **Loki**: Log storage and querying (Grafana Cloud or self-hosted)
- **Prometheus**: Metrics endpoint available on port 9598

## Ports

- **8686**: Vector API server and playground
- **9598**: Prometheus metrics endpoint
- **22**: SSH access

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `ORG` | Fly.io organization slug | `"personal"` |
| `LOKI_USERNAME` | Loki username | `"123456"` |
| `LOKI_PASSWORD` | Loki API key/password | `"glc_xxx..."` |
| `LOKI_URL` | Loki endpoint URL | `"https://logs-prod-xxx.grafana.net"` |
| `ACCESS_TOKEN` | Fly access token (if needed) | `"fo1_xxx..."` |

## Features

- Automatic HTTPS
- Auto-stop/start machines based on demand
- Minimum 0 machines running (cost-effective)
- Built-in health checks
- Prometheus metrics export
- SSH access for debugging

## Cost Optimization

This configuration is designed to be cost-effective:
- Uses shared CPU (cheaper than dedicated)
- Auto-scales to 0 when not needed
- 1GB RAM is sufficient for most log volumes

## License

This project is part of the Autoflows.dev ecosystem.
