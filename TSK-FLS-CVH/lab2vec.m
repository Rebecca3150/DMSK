function [ vectors ] = lab2vec( labels )
%LAB2VEC Summary of this function goes here
%   Detailed explanation goes here

N=length(labels);
M=max(labels);

vectors=zeros(N,M);
for m=1:M
    indices=(labels==m);
    vectors(indices,m)=1;
end

end

