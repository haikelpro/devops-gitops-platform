from fastapi import FastAPI
import os

app = FastAPI()

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
