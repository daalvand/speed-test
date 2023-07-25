from fastapi import FastAPI

app = FastAPI()


@app.get("/hello-world")
async def helloWorld():
    return "Hello World"