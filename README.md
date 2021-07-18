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

 If you have any suggestions or questions, please email me at 6191611007@stu.jiangnan.edu.cn.
