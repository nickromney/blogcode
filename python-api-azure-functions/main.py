# main.py
import random
from fastapi import FastAPI

app = FastAPI()

@app.get("/v1/generate_name")
def generate_name():
    return {"name": random.choice(["Minnie", "Margaret", "Myrtle"])}
