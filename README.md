# 🐶 Pawspective: Dog Breed Detective
This app uses artificial intelligence to predict any dog's breed from picture.

<p align="center">
<img alt="app demo" src="app_demo.gif" />
</p>

The frontend is written in Flutter and it sends RESTful API calls to the backend, written with Python's FastAPI.
The backend receives an encoded image and responds with neural network's prediction - probabilities for every breed present in training dataset.
The user is then shown all breeds with predicted probability higher than or equal to 10%.

## The AI model
The AI model was written with TensorFlow. It uses transfer learning from MobileNetV2. Dataset used for training consists of 7946 images of 70 dog breeds ([link to the dataset](https://www.kaggle.com/datasets/gpiosenka/70-dog-breedsimage-data-set)). To achieve better accuracy, it also uses data augmentation with random flips and rotations. 

Accuracy measured on a testing dataset is ~95%.

## Running the app
1. Activate the virtual environment

        $ cd backend
        $ python3 -m venv venv
        $ source venv/bin/activate
        $ pip install -r requirements.txt

2. Run the server

        $ uvicorn main:app

3. Start mobile simulator and run command

        $ cd frontend
        $ flutter run