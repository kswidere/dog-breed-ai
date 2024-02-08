from fastapi import FastAPI
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
from models import ImageData
from utils import model_predict

model = {}


@asynccontextmanager
async def lifespan(app: FastAPI):
    model["model"] = model_predict
    yield
    model.clear()


app = FastAPI(lifespan=lifespan)


@app.post("/breed-prediction")
def get_breed_prediction(image: ImageData):
    predictions = model["model"](image)
    print(predictions)
    return JSONResponse(content=predictions)
