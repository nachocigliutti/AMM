function [Y, X] = get_data(p)

e = randn(p.N, 1);
%X = randn(p.N, 1);
%e = lognrnd(1, 2, p.N, 1);
X = lognrnd(1, 2, p.N, 1);
e = e - mean(e);
X = X - mean(X);
Y = p.parT * X + e;

end
