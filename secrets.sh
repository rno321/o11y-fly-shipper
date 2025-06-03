fly secrets set ORG=<your-fly-org-name>
fly secrets set ACCESS_TOKEN=$(fly tokens create readonly <your-fly-org-name>)
fly secrets set LOKI_URL="https://<your-grafana-stack>.grafana.net/loki/api/v1/push"
fly secrets set LOKI_USERNAME="<your-grafana-loki-username>"
fly secrets set LOKI_PASSWORD="<your-grafana-loki-api-key>"
