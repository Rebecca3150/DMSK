function [K] = kernel(ker,x,y)
% Calculate kernel function.   
%
% x: ��������,d��n1�ľ���,n1Ϊ��������,dΪ����ά��
% y: ��������,d��n2�ľ���,n2Ϊ��������,dΪ����ά��
%
% ker  �˲���(�ṹ�����)
% the following fields:
%   type   - linear :  k(x,y) = x'*y
%            poly   :  k(x,y) = (x'*y+c)^d
%            gauss  :  k(x,y) = exp(-0.5*(norm(x-y)/s)^2)
%            tanh   :  k(x,y) = tanh(g*x'*y+c)
%   degree - Degree d of polynomial kernel (positive scalar).
%   offset - Offset c of polynomial and tanh kernel (scalar, negative for tanh).
%   width  - Width s of Gauss kernel (positive scalar).
%   gamma  - Slope g of the tanh kernel (positive scalar).
%
% ker = struct('type','linear');
% ker = struct('type','ploy','degree',d,'offset',c);
% ker = struct('type','gauss','width',s);
% ker = struct('type','tanh','gamma',g,'offset',c);
%
% K: ����˲���,n1��n2�ľ���

%-------------------------------------------------------------%

switch ker.type
    case 'linear'
        K = x'*y;
    case 'ploy'
        d = ker.degree;
        c = ker.offset;
        K = (x'*y+c).^d;
    case 'gauss'
        dist_X1_X2= sum((x - y).^2);
%         SIGmat=ones(size(x,1),size(y,1))*ker.width;
        SIGmat = 2*(ker.width)^2;
        K=exp(-dist_X1_X2./SIGmat);
    case 'tanh'
        g = ker.gamma;
        c = ker.offset;
        K = tanh(g*x'*y+c);
    otherwise
        K = 0;
end