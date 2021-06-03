function [pro_data,pro_index] = pro_feature(data)
% If the number of zeros in a column is greater than half, the column is removed.
pro_index=zeros(1,size(data,2));
in=0;
for i=1:size(data,2)
    num=sum(data(:,i)==0);
    if num*2<size(data,1)
        in=in+1;
        pro_index(1,in)=i;
    end
end

in=1;
while(pro_index(1,in)~=0)
    in=in+1;
end
pro_index=pro_index(1,1:in-1);
pro_data=data(:,pro_index);
end


