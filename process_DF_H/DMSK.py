import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
from keras.backend.tensorflow_backend import set_session

os.environ["CUDA_VISIBLE_DEVICES"] = "1"
import argparse
import scipy.io as sio
import matlab.engine

from utils import *
from getSequence import *
from getSequenceAndStructure import *
from getPoly import *
from getCircRNA2Vec import *
from sklearn.model_selection import train_test_split
from wgcca import *



def parse_arguments(parser):#for example:--protein ALKBH5 --weights 1.0 1.0 1.0 1.0
    parser.add_argument('--protein', type=str, metavar='<data_file>', required=True,
                        help='the protein for training model')
    parser.add_argument('--weights', default='[1.0,1.0,1.0,1.0]',
                        type=float, nargs='+',
                        help='how much to weight each view in the WGCCA objective -- defaults to equal weighting')

    args = parser.parse_args()
    return args



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    args = parse_arguments(parser)
    protein=args.protein
    weights=args.weights

    #Predict the secondary structure and the annotation structure
    # path = '../data/seq'
    # path2 = '../data/sturct'
    # cmd1 = 'RNAfold.exe <' + path + ' >' + path2
    # os.system(cmd1)
    # path3 = '../data/seq_sturct'
    # import pysster.utils as utils
    # utils.annotate_structures(path2, path3)

    dataX1, dataY, indexes = dealwithSequence(protein)
    dataX2 = dealwithSequenceAndStructure(protein, indexes)
    dataX3 = dealwithPoly(protein, indexes)
    dataX4, embedding_matrix = dealwithCircRNA2Vec(protein, indexes)
    dataX4=dataX4.reshape(dataX4.shape[0],dataX4.shape[1],1)
    train_X1, test_X1,train_X2, test_X2,train_X3, test_X3,  train_X4, test_X4,train_Y, test_Y = train_test_split(dataX1,dataX2, dataX3,dataX4,dataY, test_size=0.2)
    #Deep model training
    view_feature_model(args, train_X1, train_Y, 99, 21, 1)
    view_feature_model(args, train_X2, train_Y, 101, 24, 2)
    view_feature_model(args, train_X3, train_Y, 400, 10, 3)
    view_feature_model(args, train_X4, train_Y, 101, 1, 4)
    feature1 = feature_extracting(protein, train_X1, train_X1.shape[0], 1)#Extract the depth model
    feature1_test = feature_extracting(protein, test_X1, test_X1.shape[0], 1)
    feature2 = feature_extracting(protein, train_X2, train_X2.shape[0], 2)
    feature2_test = feature_extracting(protein, test_X2, test_X2.shape[0], 2)
    feature3 = feature_extracting(protein, train_X3, train_X3.shape[0], 3)
    feature3_test = feature_extracting(protein, test_X3, test_X3.shape[0], 3)
    feature4 = feature_extracting(protein, train_X4, train_X4.shape[0], 4)
    feature4_test = feature_extracting(protein, test_X4, test_X4.shape[0], 4)

    feature=np.zeros((4,5,feature1.shape[1],100))
    feature_test = np.zeros((4, 5, feature1_test.shape[1], 100))
    feature[0,:,:,:]=feature1
    feature[1, :, :, :] = feature2
    feature[2, :, :, :] = feature3
    feature[3, :, :, :] = feature4

    feature_test[0, :, :, :] = feature1_test
    feature_test[1, :, :, :] = feature2_test
    feature_test[2, :, :, :] = feature3_test
    feature_test[3, :, :, :] = feature4_test

    save_fn = '../models/deep_feature/' + protein + '.mat'
    sio.savemat(save_fn,
                {'feature': feature, 'feature_test': feature_test})

    eng = matlab.engine.start_matlab()#Call matlab to reduce the dimension
    feature1,feature2,feature3,feature4,feature1_test, feature2_test, feature3_test, feature4_test= eng.process_df(matlab.double(feature.tolist()),matlab.double(feature_test.tolist()),nargout=8)
    feature1 =changeShape_matlab(feature1)
    feature2 = changeShape_matlab(feature2)
    feature3 = changeShape_matlab(feature3)
    feature4 = changeShape_matlab(feature4)
    feature1_test = changeShape_matlab(feature1_test)
    feature2_test = changeShape_matlab(feature2_test)
    feature3_test = changeShape_matlab(feature3_test)
    feature4_test = changeShape_matlab(feature4_test)

    scale_by_sv = False#Calculate common features
    save_g_with_model = True
    model=[]
    model.append('../models/WGCCA/' + protein + '1.pickle')
    model.append('../models/WGCCA/' + protein + '2.pickle')
    model.append('../models/WGCCA/' + protein + '3.pickle')
    model.append('../models/WGCCA/' + protein + '4.pickle')
    model.append('../models/WGCCA/' + protein + '5.pickle')
    H = main(feature1,feature2,feature3,feature4, model, weights, scale_by_sv, save_g_with_model)
    H_test = main_APPLY(feature1_test,feature2_test,feature3_test,feature4_test, model, scale_by_sv)
    save_fn ='../models/deep_feature_h/'+protein+'.mat'#Save deep and common features to perform TSK-FLS-CVH
    sio.savemat(save_fn,
                {'feature1': list_cell(feature1), 'feature2': list_cell(feature2), 'feature3': list_cell(feature3),'feature4': list_cell(feature4),
                 'H': list_cell(H),'feature1_test': list_cell(feature1_test), 'feature2_test': list_cell(feature2_test), 'feature3_test': list_cell(feature3_test),
                  'feature4_test': list_cell(feature4_test), 'H_test': list_cell(H_test),'train_Y':train_Y, 'test_Y': test_Y})









