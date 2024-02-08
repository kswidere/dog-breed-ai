import base64
import numpy as np
import tensorflow as tf

LABELS = [
    "Afghan",
    "African Wild Dog",
    "Airedale",
    "American Hairless",
    "American Spaniel",
    "Basenji",
    "Basset",
    "Beagle",
    "Bearded Collie",
    "Bermaise",
    "Bichon Frise",
    "Blenheim",
    "Bloodhound",
    "Bluetick",
    "Border Collie",
    "Borzoi",
    "Boston Terrier",
    "Boxer",
    "Bull Mastiff",
    "Bull Terrier",
    "Bulldog",
    "Cairn",
    "Chihuahua",
    "Chinese Crested",
    "Chow",
    "Clumber",
    "Cockapoo",
    "Cocker",
    "Collie",
    "Corgi",
    "Coyote",
    "Dalmation",
    "Dhole",
    "Dingo",
    "Doberman",
    "Elk Hound",
    "French Bulldog",
    "German Sheperd",
    "Golden Retriever",
    "Great Dane",
    "Great Perenees",
    "Greyhound",
    "Groenendael",
    "Irish Spaniel",
    "Irish Wolfhound",
    "Japanese Spaniel",
    "Komondor",
    "Labradoodle",
    "Labrador",
    "Lhasa",
    "Malinois",
    "Maltese",
    "Mex Hairless",
    "Newfoundland",
    "Pekinese",
    "Pit Bull",
    "Pomeranian",
    "Poodle",
    "Pug",
    "Rhodesian",
    "Rottweiler",
    "Saint Bernard",
    "Schnauzer",
    "Scotch Terrier",
    "Shar_Pei",
    "Shiba Inu",
    "Shih-Tzu",
    "Siberian Husky",
    "Vizsla",
    "Yorkie",
]


def model_predict(image):
    image = process_image(image.image)
    model = tf.keras.models.load_model("model/dog_breeds.keras")
    prediction = model.predict(image)
    prediction_labels = dict(
        map(lambda x, y: (x, round(float(y), 2)), LABELS, prediction[0])
    )
    return prediction_labels


def process_image(image):
    image_bytes = base64.b64decode(image)
    image = tf.image.decode_image(image_bytes, channels=3)
    image = tf.image.resize(image, (160, 160))
    input_arr = tf.keras.utils.img_to_array(image)
    input_arr = np.array([input_arr])
    return input_arr
