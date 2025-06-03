# O11y Fly Shipper

A Fly.io log shipper application for observability (o11y) infrastructure.

## Overview

This application uses the official Fly.io log shipper Docker image to collect and forward logs for observability purposes.

## Configuration

The application is configured via `fly.toml`:

- **App Name**: fly_shipper
- **Primary Region**: ewr (Newark)
- **Memory**: 1GB
- **CPU**: 1 shared CPU
- **Image**: `ghcr.io/superfly/fly-log-shipper:latest`

## Deployment

To deploy this application to Fly.io:

```bash
# Install flyctl if you haven't already
curl -L https://fly.io/install.sh | sh

# Deploy the application
fly deploy
```

## Features

- Automatic HTTPS
- Auto-stop/start machines based on demand
- Minimum 0 machines running (cost-effective)
- Internal port 8080

## Requirements

- Fly.io account
- flyctl CLI tool

## License

This project is part of the Autoflows.dev ecosystem. 