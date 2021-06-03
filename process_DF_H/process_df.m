function [df_feature1,df_feature2,df_feature3,df_feature4,df_feature1_test,df_feature2_test,df_feature3_test,df_feature4_test] = process_df(feature,feature_test)
feature1=changeShape(feature,1);
feature2=changeShape(feature,2);
feature3=changeShape(feature,3);
feature4=changeShape(feature,4);

feature1_test=changeShape(feature_test,1);
feature2_test=changeShape(feature_test,2);
feature3_test=changeShape(feature_test,3);
feature4_test=changeShape(feature_test,4);

feature1=permute(feature1,[2 3 1]);feature1_test=permute(feature1_test,[2 3 1]);
feature2=permute(feature2,[2 3 1]);feature2_test=permute(feature2_test,[2 3 1]);
feature3=permute(feature3,[2 3 1]);feature3_test=permute(feature3_test,[2 3 1]);
feature4=permute(feature4,[2 3 1]);feature4_test=permute(feature4_test,[2 3 1]);
mulview_tr_cell = {feature1; feature2; feature3;feature4};mulview_te_cell = {feature1_test;feature2_test;feature3_test;feature4_test};

views_num=4;
folds_num=5;pro_indexes=cell(views_num,folds_num);
mulview_tr_cell_copy=cell(views_num,folds_num);mulview_te_cell_copy=cell(views_num,folds_num);

for view_num=1:views_num
    for fold=1:folds_num
        tr_data=mulview_tr_cell{view_num,1}(:,:,fold);
        te_data=mulview_te_cell{view_num,1}(:,:,fold);
        %处理特征
        [tr_data,pro_index] = pro_feature(tr_data);
        te_data=te_data(:,pro_index);
        pro_indexes{view_num,fold}=pro_index;
        %更新特征
        mulview_tr_cell_copy{view_num,fold}=tr_data;
        mulview_te_cell_copy{view_num,fold}=te_data;
    end
end

df_feature1=mulview_tr_cell_copy(1,:);df_feature1_test=mulview_te_cell_copy(1,:);
df_feature2=mulview_tr_cell_copy(2,:);df_feature2_test=mulview_te_cell_copy(2,:);
df_feature3=mulview_tr_cell_copy(3,:);df_feature3_test=mulview_te_cell_copy(3,:);
df_feature4=mulview_tr_cell_copy(4,:);df_feature4_test=mulview_te_cell_copy(4,:);
% pro_index1=pro_indexes(1,:);pro_index2=pro_indexes(2,:);
% pro_index3=pro_indexes(3,:);pro_index4=pro_indexes(4,:);
end

