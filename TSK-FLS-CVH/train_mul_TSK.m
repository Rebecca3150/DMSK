function [TSK_cell, lamda_scale] = train_mul_TSK( mulview_data_cell, TSK_cell, T, options)
%Enter multi-view data ancestors and class labels, output the TSK model for each view, TSK_cell a perspective model for each behavior, first as pg, second as v, third as b
view_nums = options.view_nums;
lamda_scale = zeros(3,1);

c = size(T,2);  %The number of categories
N = size( mulview_data_cell{1,1}, 1);   %The number of samples
lamda1 = options.lamda1;    %Regularization factor
lamda2 = options.lamda2;    %Synergy coefficient
lamda3 = options.lamda3;    %Weight item coefficient
maxIter = options.maxIter;

for i = 1:maxIter
    %Calculate the denominator in the weight update
    sum_weight = 0;
    for view_num = 1:view_nums
        temp_pg = TSK_cell{ view_num,1 };
        temp_v = TSK_cell{ view_num, 2 };
        temp_b = TSK_cell{ view_num, 3 };
        temp_x = mulview_data_cell{view_num,1};
        temp_x = fromXtoZ(temp_x,temp_v,temp_b);
        
        a=temp_x * temp_pg;
        b=a-T;
        c=sum(b);
        d=c';
        f=c*d;
        sum_variance = (sum(temp_x * temp_pg - T))*sum(temp_x * temp_pg - T)';
        sum_variance = exp(-lamda3*sum_variance);
        sum_weight = sum_weight+sum_variance;
    end
    %Update the weight and the rear output
    for view_num = 1:view_nums
        acc_pg = TSK_cell{ view_num,1 };
        acc_v = TSK_cell{ view_num, 2 };
        acc_b = TSK_cell{ view_num, 3 };
        acc_x = mulview_data_cell{view_num,1};
        x = fromXtoZ(acc_x,acc_v,acc_b);
        variance = (sum(x * acc_pg - T))*sum(x * acc_pg - T)';
        acc_w = exp(-lamda3*variance)/sum_weight;
        sum_y = zeros(N,2);
        for j = 1:view_nums     %compute y_cooperate
            if j ~= view_num
                temp_pg = TSK_cell{j,1};
                temp_v = TSK_cell{j,2};
                temp_b = TSK_cell{j,3};
                temp_x = mulview_data_cell{j,1};
                temp_x = fromXtoZ(temp_x,temp_v,temp_b);
                sum_y = sum_y + temp_x*temp_pg;
                lamda_scale(1,1) = lamda1;
                lamda_scale(2,1) = lamda2;
                lamda_scale(3,1) = lamda3;
            end
        end

        y_cooperate = sum_y/(view_nums - 1);
        z = acc_w*(x)'*x;
        TSK_cell{ view_num, 1 } = pinv( z + lamda1 * eye( size( z)) +lamda2*(x)'*x)*(acc_w*x'*T+lamda2*x'*y_cooperate);
        TSK_cell{ view_num, 4 } = acc_w;
    end %end view_num
        
end
