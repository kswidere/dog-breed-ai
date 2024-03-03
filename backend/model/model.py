import tensorflow as tf
import matplotlib.pyplot as plt

IMG_SIZE = (160, 160)
IMG_SHAPE = IMG_SIZE + (3,)
BATCH_SIZE = 32
AUTOTUNE = tf.data.AUTOTUNE


def get_image_dataset(directory: str):
    return tf.keras.utils.image_dataset_from_directory(
        directory,
        shuffle=True,
        batch_size=BATCH_SIZE,
        image_size=IMG_SIZE,
        labels="inferred",
        label_mode="categorical"
    )


def create_model(learning_rate: float):
    # adding random flips and rotations to acquire more training samples
    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomFlip('horizontal'),
        tf.keras.layers.RandomRotation(0.2),
    ])

    # knowledge transfer from MobileNetV2
    preprocess_input = tf.keras.applications.mobilenet_v2.preprocess_input
    base_model = tf.keras.applications.MobileNetV2(input_shape=IMG_SHAPE,
                                                   include_top=False,
                                                   weights='imagenet')
    base_model.trainable = False

    global_average_layer = tf.keras.layers.GlobalAveragePooling2D()

    prediction_layer = tf.keras.layers.Dense(70, activation="softmax")

    # putting together all layers
    inputs = tf.keras.Input(shape=IMG_SHAPE)
    x = data_augmentation(inputs)
    x = preprocess_input(x)
    x = base_model(x, training=False)
    x = global_average_layer(x)
    x = tf.keras.layers.Dropout(0.25)(x)
    outputs = prediction_layer(x)
    model = tf.keras.Model(inputs, outputs)

    model.compile(
        optimizer=tf.keras.optimizers.legacy.Adam(learning_rate=learning_rate),
        loss=tf.keras.losses.CategoricalCrossentropy(),
        metrics=["accuracy"]
    )

    return model


def fit_model(model, epochs, train_dir="data/train", val_dir="data/valid"):
    # load datasets
    train_dataset = get_image_dataset(train_dir)
    valid_dataset = get_image_dataset(val_dir)

    # prefetch for better performance
    train_dataset = train_dataset.prefetch(buffer_size=AUTOTUNE)
    valid_dataset = valid_dataset.prefetch(buffer_size=AUTOTUNE)

    return model.fit(train_dataset,
                     epochs=epochs,
                     validation_data=valid_dataset)


def test_model(model, test_dir="data/test"):
    test_dataset = get_image_dataset(test_dir)
    test_dataset = test_dataset.prefetch(buffer_size=AUTOTUNE)
    return model.evaluate(test_dataset)


if __name__ == "__main__":
    model = create_model(0.0001)
    history = fit_model(model, 25)
    model.save("dog_breeds.keras")

    _, test_acc = test_model(model)

    plt.plot(history.history['accuracy'], label='accuracy', linewidth=2)
    plt.plot(history.history['val_accuracy'], label='val_accuracy', linewidth=2)
    plt.legend()
    plt.xlabel('Epochs')
    plt.ylabel('Score')
    plt.title('Accuracy')
    plt.savefig("accuracy.png")
