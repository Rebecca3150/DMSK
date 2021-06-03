function [ masks_te ] = cv_fold( folds_num, labels )
%CV_FOLD ������֤�۵�����
%	[ indices_folds_tr, indices_folds_te ] = cv_fold( folds_num, labels )
%   ���룺
%       folds_num           - �۵���������
%       labels              - Nά�����������ǩ����Ӧ���ݼ�
%   �����
%       masks_te           - folds_num*1��Ԫ�����飬folds_num����������ݵ�01����

    N=length(labels);
    masks_te=cell(folds_num,1);
    
    for fold=1:folds_num
        
        indices_te=(fold:folds_num:N);
        
        group=zeros(N,1);
        group(indices_te)=1;
        
        masks_te{fold,1}=logical(group);
        
    end

end

