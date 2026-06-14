from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
import os

app = FastAPI()

Instrumentator().instrument(app).expose(app)

VERSION = os.getenv("APP_VERSION", "v1")

@app.get("/")
def home():
    return {
        "service": "user-service",
        "message": "Hello from user-service",
        "version": VERSION
    }

@app.get("/healthz")
def health():
    return {"status": "healthy"}

@app.get("/readyz")
def ready():
    return {"status": "ready"}

@app.get("/version")
def version():
    return {"version": VERSION}
