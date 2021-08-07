clear;
clc;

home_dir='F:/PycharmProjects/DMSK/';
name='ALKBH5';
tic;
for k=10:10:50
load([home_dir 'models/deep_feature_h/' char(name) '_' char(k) '.mat']);
[~] = expt_H_TSK(H, H_test, double(train_Y), double(test_Y));

end
toc;
