function zt=fromXtoZ(xt,v,b)

Nt=size(xt,1);
xt1=[xt,ones(Nt,1)];
% xt1=1;
[M,d0]=size(v);

for i=1:M
    v1=repmat(v(i,:),Nt,1);
    bb=repmat (b(i,:),Nt,1);
    wt(:,i)=exp(-sum((xt-v1).^2./bb,2));
end



wt2=sum(wt,2);
wt=wt./repmat(wt2,1,M);

zt=[];
for i=1:M
    wt1=wt(:,i);
    wt2=repmat(wt1,1,d0+1);
    zt=[zt,xt1.*wt2];
end
Mask = isnan(zt);
zt(Mask) = 1e-5;
%zt:N*K