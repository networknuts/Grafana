"""
openai_prometheus_app.py

Exposes:
- /ask?q=...
- /metrics (Prometheus)

Tracks:
OpenAI Call ID -> Tokens Consumed
"""

from fastapi import FastAPI
from prometheus_client import Counter, make_asgi_app
from openai import OpenAI

# ---------------------------------------------------------
# OpenAI Client
# ---------------------------------------------------------
client = OpenAI()

# ---------------------------------------------------------
# Prometheus Metrics
# ---------------------------------------------------------
openai_tokens = Counter(
    "openai_tokens_total",
    "OpenAI token usage per call",
    ["call_id", "model", "direction"]
)

# ---------------------------------------------------------
# FastAPI App
# ---------------------------------------------------------
app = FastAPI(title="OpenAI + Prometheus Demo")

# Prometheus endpoint
app.mount("/metrics", make_asgi_app())

# ---------------------------------------------------------
# OpenAI Call Wrapper
# ---------------------------------------------------------
def run_openai_call(prompt: str) -> str:
    response = client.responses.create(
        model="gpt-4.1-mini",
        input=prompt,
    )

    call_id = response.id
    model = response.model
    usage = response.usage

    # Export metrics
    openai_tokens.labels(
        call_id=call_id,
        model=model,
        direction="input"
    ).inc(usage.input_tokens)

    openai_tokens.labels(
        call_id=call_id,
        model=model,
        direction="output"
    ).inc(usage.output_tokens)

    openai_tokens.labels(
        call_id=call_id,
        model=model,
        direction="total"
    ).inc(usage.total_tokens)

    return response.output_text

# ---------------------------------------------------------
# API Endpoint
# ---------------------------------------------------------
@app.get("/ask")
def ask(q: str):
    answer = run_openai_call(q)
    return {
        "answer": answer
    }

# ---------------------------------------------------------
# Run:
# uvicorn openai_prometheus_app:app --host 0.0.0.0 --port 8000
# ---------------------------------------------------------
