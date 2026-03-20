from fastapi import FastAPI, Request
import logging
import time

app = FastAPI()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)
logger = logging.getLogger("threatlab")

@app.get("/")
async def root():
    logger.info("Root endpoint accessed")
    return {"message": "AWS Threat Lab backend is running"}

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/login")
async def fake_login(username: str = "guest"):
    logger.warning("Login attempt for username=%s", username)
    return {"message": f"Login attempt recorded for {username}"}

@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    response = await call_next(request)
    duration = time.time() - start

    logger.info(
        "method=%s path=%s status=%s duration=%.4f",
        request.method,
        request.url.path,
        response.status_code,
        duration
    )
    return response