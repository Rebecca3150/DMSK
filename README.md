# DMSK
circRNA-binding protein sites prediction based on multi-view deep learning, subspace learning and multi-view classifier  

# Dependency 
Keras 2.2.5 library  
sklearn  
python 3.7  

# Content 
./Datasets: the dataset with label and sequence, including circRNAs and linear RNA datasets.  
./circRNA2Vec: the circRNA word vector model.  
./linRNA2Vec: the linear RNA word vector model.   
./process_DF_H: extraction of circRNA sequences with individual view features and common features.  
./TSK-FLS-CVH: the TSK-FLS with the Cooperation of Visible and Hidden views (TSK-FLS-CVH).   

# Usage
python DMSK.py [-h] [--protein <data_file>] [--weights WEIGHTS]
## Use case:
Take ALKBH5 as an example, we train the binding site model of ALKBH5 binding protein on circRNAs in the following steps. The model is constructed with two steps: In the first step, deep features of the four views are extracted by hybrid neural network, and then common features are extracted by WGCCA. And then the above five features are saved to a mat file. This step corresponds to the "process_DF_H" file. The second step puts the above five views as the inputs of the multi-view classifier TSK-FLS-CVH for the effective cooperative learning, which is used to train a classifier to predict the binding site for future test datasets. This step corresponds to the "TSK-FLS-CVH" file.

## step 1:
python DMSK.py --protein=ALKBH5  
For the first step, it will save 'ALKBH5.mat'. This includes the deep features of the four original views and their common features.Note that at this stage, make sure that you can successfully call the matlab code.
Extracting deep features for each view will be done automatically. If you need to save the hybrid neural network model during the process, please specify the path yourself.
## step 2:
The "auto_expt_mul_TSK.m" script is called to train the multi-view collaborative learning model as a classifier to predict the results for the future test data.
Note that the path to home_dir should be set to the absolute path of the project. For example, home_dir='home/DMSK/'.  

# Extension
## How to extend the model to integrate more features
If we add new features from a new view, we need to add the specific method to extract the features in the "process_DF_H" file, such as 'getFeature_new.py'. Then we need to add the following code in the 'DMSK.py' file at the appropriate location.  
 ```Python
 from getFeature_new import *
 dataX_new = dealwithNewFeature(protein, indexes)  #extract the original feature
 ```     
The later operations are all the same as the operation of pseudo-amino acid sequence feature. That is, a hybrid model for features in a new view is first trained and then deep features are learned from these new features, and common features of all views are extracted again. Finally, a six views are passed through TSK-FLS-CVH for effective cooperative learning and a trained new multi-view classifier will be obtained.  
## how to train (test) the method when more circRNA datasets become available in the future
Our method DMSK is modeled for each RBP (37 models in total). If more circRNA-RBP datasets are available in the future, corresponding positive and negative samples will be created as described in the "Benchmark dataset" section of the paper. There are two cases here.  
 1. We only need to train (test) a new model without changing the original 37 models if a new RBP appears.  
 2. If no new RBP appears, we need to integrate the new circRNAs data with the existing data of the corresponding RBP. Then the training set and test set are redivided in the ratio of 4:1 and the proposed DMSK is trained and tested again with the updated training and test sets.

The specific code implementation is only updated with "./Datasets/circRNA-RBP/" file with the data.  
## How to set the appropriate dimension of common features in a new application scenario
When learning the common features of multiple views in a new application scenario, we can choose an appropriate value from a given range of subspace dimensions, such as [10:10:50]. The specific steps are as follows.  
 1. In the './process_DF_H/DMSK.py' file, we get the five common features under different setting in {10,20,30,40,50} in the following code. Specifically, we get the corresponding features by specifying the dimension k in the './process_DF_H/wgcca.py' file.  
 ```Python
 H = main(feature1,feature2,feature3,feature4, model, weights, scale_by_sv, save_g_with_model)
 ```   
 2. The common features extracted under different parameter settings on all da-tasets are separately input into the TSK-FS classifier, i.e., the './TSK-FLS-CVH/auto_expt_H_TSK.m' file to obtain the final AUC metrics.  
 3. We average the results on all datasets corresponding to different parameter settings, and the setting with the highest AUC metric is selected as the optimal dimension of the common features.

<br/>
 If you have any suggestions or questions, please email me at 6191611007@stu.jiangnan.edu.cn.
