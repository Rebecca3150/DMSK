function [best_pg, best_v, best_b,best_lamda,best_M,best_index,best_result] = train_TSK_FS(tr_data, te_data, tr_label, te_label,folds_num, view_num)
% train classifier of each view
tr_data_copy=tr_data;
te_data_copy=te_data;
Ms = [2:2:20];
lamdas = [0,2.^(-5:5)];

a = 0;
best_auc = 0;
for lamda = lamdas
    a = a + 1;
    c = 0;
    for M = Ms
        c = c + 1;
        %5 cross-validation
        can = cell(folds_num,3);
        result = zeros(folds_num,2);
        for fold=1:folds_num
            tic;
            tr_data=tr_data_copy{:,fold};
            te_data=te_data_copy{:,fold};
            [v,b] = preproc(tr_data, M);
            Xg = fromXtoZ(tr_data,v,b);   %Xg:N*K
            Xg1 = Xg'*Xg;
            pg = pinv(Xg1 + lamda*eye( size(Xg1)))*Xg'*tr_label;    %Solving the consequent parameters of the TSK-FS
            [te_Y] = test_TSK_FS( te_data , pg, v, b);
            te_l = te_Y;
            te_l= mapminmax(te_l', 0, 1)';
            [~,~,~,auc]=perfcurve(te_label(:,2),te_l(:,2),1);
            te_Y = vec2lab(te_Y);
            f1=f1_score(te_label(:,2),te_Y);
            result(fold,1)=auc;result(fold,2)=f1;
            can{fold,1}=pg; can{fold,2}=v; can{fold,3}=b;
            toc;
        end
        auc_te_mean = mean(result(:,1));
        f1_te_mean = mean(result(:,2));
        %Find the best auc for the pro_index
        max_auc=max(result(:,1));
        [row,~]=find(result(:,1)==max_auc);
        %Preferred
        if auc_te_mean >best_auc
            best_auc = auc_te_mean ;
            best_result.auc = auc_te_mean ;
            best_result.f1 = f1_te_mean;
            best_pg = can{row,1};
            best_v = can{row,2};
            best_b = can{row,3};
            best_lamda=lamda;
            best_M=M;
            best_index=row;
        end
        fprintf('train TSK FS:------view:%d\nNumber of iterations:%d/%d------%d/%d\n', view_num, a, size(lamdas,2), c, size(Ms,2));
        fprintf('best auc result:\nauc:%.4f   f1:%.4f   lamda:%.4f   M:%.4f\n\n',best_result.auc,best_result.f1,best_lamda,best_M);
    end %end M
end %end lamda
