function [ labels ] = vec2lab( vectors )
%VEC2LAB Summary of this function goes here
%   Detailed explanation goes here

[~,labels]=max(vectors,[],2);
labels=labels-1;

end

