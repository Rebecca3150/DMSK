import os
import numpy as np
import matplotlib as mpl

mpl.use('Agg')
from keras.models import Sequential, Model, load_model
from keras.layers.core import Dense, Dropout, Activation, Flatten
from keras.optimizers import Adam
from keras.layers.recurrent import LSTM
from keras.layers import Bidirectional
from keras.layers.convolutional import Convolution1D, AveragePooling1D
from keras.callbacks import EarlyStopping
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import KFold

def view_feature_model(parser, trainXeval, trainYeval, M, N, view_num):
    print('view_model')
    protein = parser.protein
    batch_size = 50
    hiddensize = 120
    nbfilter =100

    path = '../models/feature_model/' + protein + '/'
    if not os.path.exists(path):
        os.makedirs(path)

    kf = KFold(n_splits=5)
    index = 0
    aucs = []
    losses = []
    accs = []
    for train_index, eval_index in kf.split(trainXeval):
        train_X = trainXeval[train_index]
        train_y = trainYeval[train_index]
        eval_X = trainXeval[eval_index]
        eval_y = trainYeval[eval_index]
        model = Sequential()
        model.add(
            Convolution1D(input_shape=(M, N), filters=nbfilter, kernel_size=7, padding="valid",
                          activation="relu", strides=1))
        model.add(AveragePooling1D(pool_size=5))
        model.add(Dropout(0.5))
        model.add(Bidirectional(LSTM(hiddensize, return_sequences=True)))
        model.add(Flatten())
        model.add(Dense(100, activation='relu'))
        model.add(Dropout(0.25))
        model.add(Dense(2))
        model.add(Activation('softmax'))

        model.compile(loss='categorical_crossentropy', optimizer=Adam(lr=1e-4), metrics=['accuracy'])
        print('model training',index)
        earlystopper = EarlyStopping(monitor='val_loss', patience=5, verbose=0)
        history = model.fit(train_X, train_y, batch_size=batch_size, epochs=30,
                            validation_data=(eval_X, eval_y),
                            callbacks=[earlystopper])
        a = model.predict_proba(train_X)
        predictions = model.predict_proba(train_X)[:, 1]
        auc = roc_auc_score(train_y[:, 1], predictions)
        aucs.append(auc)
        losses.append(history.history['loss'][len(history.history['loss']) - 1])
        accs.append(history.history['val_acc'][len(history.history['val_acc']) - 1])

        model.save(path + 'view' + str(view_num) + '_' + str(index) + '.h5')
        index += 1
def feature_extracting(protein, X, axis_x, view_num):
    features = np.zeros((5, axis_x, 100))
    for index in range(5):
        model = load_model(
            '../models/feature_model/' +protein + '/view' + str(view_num) + '_' + str(
                index) + '.h5')
        representation_model = Model(inputs=model.inputs, outputs=model.layers[6].output)
        feature = representation_model.predict(X)
        features[index, :, :] = feature
    return features
def changeShape_matlab(data):#5list,n*d
    df_data = []
    for i in range(5):
        f = data[i][0]
        for j in range(len(data[0])):
            f = np.vstack((f,data[i][j]))
        df_data.append(f[1:f.shape[0],:])
    return df_data
def list_cell(data):
    data_ = np.empty((5,), dtype=np.object)
    for i in range(5):
        data_[i] = data[i]
    return data_
