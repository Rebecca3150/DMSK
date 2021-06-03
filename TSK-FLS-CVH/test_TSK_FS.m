function [Y] = test_TSK_FS( test_data , pg, v, b)
%test_data is N*D£¬Y£ºN*C 
test_data = fromXtoZ(test_data,v,b);
Y = test_data*pg;
