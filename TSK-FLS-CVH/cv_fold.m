function [ masks_te ] = cv_fold( folds_num, labels )
%CV_FOLD 交叉验证折叠分组
%	[ indices_folds_tr, indices_folds_te ] = cv_fold( folds_num, labels )
%   输入：
%       folds_num           - 折叠分组组数
%       labels              - N维列向量，类标签，对应数据集
%   输出：
%       masks_te           - folds_num*1的元胞数组，folds_num组测试用数据的01掩码

    N=length(labels);
    masks_te=cell(folds_num,1);
    
    for fold=1:folds_num
        
        indices_te=(fold:folds_num:N);
        
        group=zeros(N,1);
        group(indices_te)=1;
        
        masks_te{fold,1}=logical(group);
        
    end

end

