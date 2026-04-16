#!/usr/bin/env bash

API_URL="http://localhost:8000/ask"

QUESTIONS=(
  "Explain Kubernetes in one line"
  "What is a Kubernetes Pod?"
  "Explain ConfigMaps vs Secrets"
  "What is a Service in Kubernetes?"
  "Explain Horizontal Pod Autoscaler"
  "What is Kubernetes Scheduler?"
  "Explain etcd in Kubernetes"
  "What is a DaemonSet?"
  "Explain StatefulSets vs Deployments"
  "What is a Kubernetes Ingress?"
)

echo "🚀 Generating OpenAI metrics..."
echo "--------------------------------"

for q in "${QUESTIONS[@]}"; do
  echo "➡️  Asking: $q"

  curl -s -G "$API_URL" \
    --data-urlencode "q=$q" \
    > /dev/null

  sleep 1
done

echo "--------------------------------"
echo "✅ Done. Check /metrics and Grafana."
