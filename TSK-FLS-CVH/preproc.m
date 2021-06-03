function [v,b]=preproc(data,M)
N = size(data,1);
x=data;

if N>1000
    data0=x(1:round(N./1000):N,:);
else
    data0=x;
end

[v,U,obj_fcn] = fcm(data0,M,2); 

[N0,d0]=size(data0);
for i=1:M
    v1=repmat (v(i,:),N0,1);
    u=U(i,:);
    uu=repmat (u',1,d0);
    b(i,:)=sum( ( data0-v1).^2.*uu,1)./sum(uu)./1;
end
