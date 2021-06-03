clear;
clc;

home_dir='F:/PycharmProjects/DMSK/';
name='ALKBH5';
tic;
load([home_dir 'models/deep_feature_h/' char(name) '.mat']);
mulview_tr_cell=cell(5,5);mulview_tr_cell(1,:)=feature1;mulview_tr_cell(2,:)=feature2;mulview_tr_cell(3,:)=feature3;mulview_tr_cell(4,:)=feature4;mulview_tr_cell(5,:)=H;
mulview_te_cell=cell(5,5);mulview_te_cell(1,:)=feature1_test;mulview_te_cell(2,:)=feature2_test;mulview_te_cell(3,:)=feature3_test;mulview_te_cell(4,:)=feature4_test;mulview_te_cell(5,:)=H_test;
[final_best_result] = expt_mul_TSK( mulview_tr_cell, mulview_te_cell, double(train_Y), double(test_Y));
save([home_dir 'models/final_best_result/' char(name)  '.mat'],'final_best_result');
toc;

