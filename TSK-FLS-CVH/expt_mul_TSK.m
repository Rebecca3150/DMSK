function [final_best_result,TSK_cell,TSK_result,TSK_canshu,TSK_fold]= expt_mul_TSK(mulview_tr_cell, mulview_te_cell, tr_label, te_label)
%The data parameters are initialized
view_nums = size(mulview_te_cell,1);
TSK_cell = cell(view_nums,4); %First list pg, second list v, third column b, fourth list w (weight)
folds_num = 5;
options.view_nums = view_nums;
maxIter = 10;
options.maxIter = maxIter;
lamda1s = 2.^(-6:6);
lamda2s = 2.^(-6:6);
lamda3s = 2.^(-6:6);
n = size(tr_label,2);

  
%Normalize the data
for view_num = 1:view_nums
    for i =1:folds_num
        auc_data = mulview_tr_cell{view_num,i};
        auc_data = mapminmax(auc_data', 0, 1)';
        mulview_tr_cell{view_num,i} = auc_data;
    end
end
for view_num = 1:view_nums
    for i =1:5
        auc_data = mulview_te_cell{view_num,i};
        auc_data = mapminmax(auc_data', 0, 1)';
        mulview_te_cell{view_num,i} = auc_data;
    end
end



%Train a TSK for each view
tic;
for view_num = 1:view_nums
    [pg, v, b,best_lamda,best_M,best_index,best_result] = train_TSK_FS(mulview_tr_cell(view_num,:),mulview_te_cell(view_num,:), tr_label, te_label, folds_num, view_num);
    TSK_cell{ view_num, 1 } = pg;
    TSK_cell{ view_num, 2 } = v;
    TSK_cell{ view_num, 3 } = b;
    TSK_cell{ view_num, 4 } = 1/view_nums;
    TSK_result(view_num,1) = best_result.auc;
    TSK_result(view_num,2) = best_result.f1;
    TSK_canshu(view_num,1) = best_lamda;
    TSK_canshu(view_num,2) = best_M;
    TSK_fold{view_num,1}=best_index;
end


mulview_tr_cell_copy = mulview_tr_cell;mulview_te_cell_copy = mulview_te_cell;
mulview_tr_cell={mulview_tr_cell_copy{1,TSK_fold{1}};mulview_tr_cell_copy{2,TSK_fold{2}};mulview_tr_cell_copy{3,TSK_fold{3}};mulview_tr_cell_copy{4,TSK_fold{4}};mulview_tr_cell_copy{5,TSK_fold{5}}};
mulview_te_cell={mulview_te_cell_copy{1,TSK_fold{1}};mulview_te_cell_copy{2,TSK_fold{2}};mulview_te_cell_copy{3,TSK_fold{3}};mulview_te_cell_copy{4,TSK_fold{4}};mulview_te_cell_copy{5,TSK_fold{5}}};             

%mul_H_TSK
best_auc_te = 0;
a = 0;  
for lamda1 = lamda1s
    a = a + 1;
    b = 0;
    for lamda2 = lamda2s
        b = b + 1;
        c = 0;
        for lamda3 = lamda3s
            tic;
            c = c + 1;
            options.lamda1 = lamda1;
            options.lamda2 = lamda2;
            options.lamda3 = lamda3;
            options.view_nums = view_nums;
            result = zeros(1,2);
            try
                [best_TSK_cell, best_lamada_scale] = train_mul_TSK( mulview_tr_cell, TSK_cell, tr_label, options);
                [te_Y] = test_mul_TSK( mulview_te_cell ,best_TSK_cell, view_nums, n);
                [~,~,~,auc]=perfcurve(te_label(:,2),te_Y(:,2),1);
                te_Y = vec2lab(te_Y);
                f1=f1_score(te_label(:,2),te_Y);
                result(1,1) = auc;
                result(1,2) = f1;
            catch err
                disp(err);
                    warning('Something wrong when using function pinv!');
                break;
            end
            auc_te_mean = mean(result(:,1));
            f1_te_mean = mean(result(:,2));
            if (auc_te_mean>best_auc_te)
                best_auc_te = auc_te_mean;
                final_best_result.best_model = best_TSK_cell;
                final_best_result.auc_mean = auc_te_mean;
                final_best_result.f1_mean = f1_te_mean;   
                final_best_result.lamda_scale = best_lamada_scale;
            end
            fprintf('train mul TSK FS:\nNumber of iterations:%d-----%d-----%d\n', a, b, c);
            fprintf('best auc result:\nauc:%.4f  f1:%.4f\n',final_best_result.auc_mean, final_best_result.f1_mean);
        toc;
        end %end lamda3s
    end %end lamda2s
end %end lamda1s
toc;