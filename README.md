# DMSK
circRNA-binding protein sites prediction based on multi-view deep learning, subspace learning and multi-view classifier  

# Dependency 
Keras 2.2.5 library  
sklearn  
python 3.7  

# Content 
./Datasets: the dataset with label and sequence. circRNAs and linear RNA datasets.  
./circRNA2Vec: the circRNA word vector model.  
./linRNA2Vec: the linear RNA word vector model.   
./process_DF_H: extraction of circRNA sequences with individual view features and common features.  
./TSK-FLS-CVH: the TSK-FLS with the Cooperation of Visible and Hidden views (TSK-FLS-CVH).   

# Usage
python DMSK.py [-h] [--protein <data_file>] [--weights WEIGHTS]
## Use case:
Take ALKBH5 as an example, we train the binding site model of ALKBH5 binding protein on circRNAs in the following steps. The model is in two parts, firstly, deep features of the four views are extracted by hybrid neural network, and then common features are extracted by WGCCA. And the above five features are saved to a mat file. This part corresponds to the "process_DF_H" file.
The second part puts the above five features through TSK-FLS-CVH for effective cooperative learning, which is used to reproduce our results.This part corresponds to the "TSK-FLS-CVH" file.

## step 1:
python DMSK.py --protein=ALKBH5  
For the first part, it will save 'ALKBH5.mat'. This includes the deep features of the four views and their common features.Note that at this stage, make sure that you can successfully call the matlab code.
Extracting deep features for each view will be done automatically. If you need to save the hybrid neural network model during the process, please specify the path yourself.
## step 2:
The "auto_expt_mul_TSK.m" script is called to train the multi-view collaborative learning model to reproduce our results.
Note that the path to home_dir should be set to the absolute path of the project. For example, home_dir='home/DMSK/'.  

# Extension
## how to extend the model to integrate more features
If we add a new feature, we need to add the specific method to extract the feature in the "process_DF_H" file, such as 'getFeature_new.py'. Then we need to add the following code in the 'DMSK.py' file at the appropriate location.  
 ```Python
 from getFeature_new import *
 dataX_new = dealwithNewFeature(protein, indexes)  #extract the original feature
 ```     
The later operations are all the same as the operation of pseudo-amino acid sequence feature. That is, a hybrid model of new feature is trained and deep feature is extracted from it, and common feature are extracted from all features. Finally, the above six features are passed through TSK-FLS-CVH for effective cooperative learning.  
## how to train (test) the method when more circRNA datasets become available in the future
Our method DMSK is modeled for each RBP (37 models in total). If more circRNA-RBP datasets are available in the future, corresponding positive and negative samples will be created as described in the "Benchmark dataset" section of the paper. There are two cases here.  
 1. We only need to train (test) a new model without changing the original 37 models if a new RBP appears.  
 2. If no new RBP appears, we need to integrate the new circRNAs data with the existing data of the corresponding RBP. The training set and test set are redivided in the ratio of 4:1.

The specific code implementation is only updated with "./Datasets/circRNA-RBP/" file with the data.  
## How to learn the dimension of common feature in a new application scenarios
When learning the common features of multiple deep features in a new application scenario, we choose from a given range of subspace dimensions from 10 to 50. The specific steps are as follows.  
 1. In the './process_DF_H/DMSK.py' file, we get the five common features {10,20,30,40,50} in the following code. Specifically, we get the corresponding features by specifying the dimension k in the './process_DF_H/wgcca.py' file.  
 ```Java
 H = main(feature1,feature2,feature3,feature4, model, weights, scale_by_sv, save_g_with_model)
 ```   
 2. Each of the five features on all datasets is separately input into the TSK-FS classifier, i.e., the './TSK-FLS-CVH/auto_expt_H_TSK.m' file to obtain the final AUC metrics.  
 3. We average the results on all datasets corresponding to the five features to select the optimal dimension of the common feature.

<br/>
 If you have any suggestions or questions, please email me at 6191611007@stu.jiangnan.edu.cn.
