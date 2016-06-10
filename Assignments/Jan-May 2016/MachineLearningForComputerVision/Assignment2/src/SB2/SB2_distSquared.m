function D2 = SB2_distSquared(X,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Support function to compute basis
%
nx	= size(X,1);
ny	= size(Y,1);
%
D2 = (sum((X.^2), 2) * ones(1,ny)) + (ones(nx, 1) * sum((Y.^2),2)') - ...
     2*X*Y';
end