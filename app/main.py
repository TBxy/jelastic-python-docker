import sys


class App:
    def __init__(self, scope):
        assert scope["type"] == "http"
        self.scope = scope

    async def __call__(self, receive, send):
        await send(
            {
                "type": "http.response.start",
                "status": 200,
                "headers": [[b"content-type", b"text/html"]],
            }
        )
        version = f"{sys.version_info.major}.{sys.version_info.minor}"
        message = f"<h1>Hello Jelastic!</h1> From Uvicorn with Gunicorn. Using <b>Python {version}</b>".encode(
            "utf-8"
        )
        await send({"type": "http.response.body", "body": message})


app = App
