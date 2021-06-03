function [out_data] = changeShape(data,n)%1*a*b*c  change to a*b*c
data=data(n,:,:,:);
out_data=reshape(data,size(data,2),size(data,3),size(data,4)) ;
end

