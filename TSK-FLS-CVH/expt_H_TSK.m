function [TSK_result]= expt_mul_TSK(H, H_test, tr_label, te_label)
%The data parameters are initialized
view_nums=1;
TSK_cell = cell(view_nums,4); %First list pg, second list v, third column b, fourth list w (weight)
folds_num = 1;
view_nums=1;
options.view_nums = 1;
maxIter = 10;
options.maxIter = maxIter;
lamda1s = 2.^(-6:6);
lamda2s = 2.^(-6:6);
lamda3s = 2.^(-6:6);
n = size(tr_label,2);

  
%Normalize the data
auc_data = H_train;
auc_data = mapminmax(auc_data', 0, 1)';
H_train = auc_data;
auc_data = H_test;
auc_data = mapminmax(auc_data', 0, 1)';
H_test = auc_data;

%Train a TSK for H
tic;
[pg, v, b,best_lamda,best_M,~,best_result] = train_TSK_FS( {H_train},{H_test}, tr_label, te_label,folds_num, 1);
toc;

fprintf('*****train H_TSK:best auc:%d***best f1:%d\n',best_result.auc ,best_result.f1);

TSK_result(1,1) = best_result.auc;
TSK_result(1,2) = best_result.f1;
TSK_canshu(1,1) = best_lamda;
TSK_canshu(1,2) = best_M;
TSK_cell{ 1, 1 } = pg;
TSK_cell{1, 2 } = v;
TSK_cell{1, 3 } = b;
TSK_cell{1, 4 } = 1/view_nums;

save([home_dir 'models/G_result/' char(name) '_' char(k) '.mat'],  'TSK_cell', 'TSK_result','H_train','H_test','TSK_canshu');

