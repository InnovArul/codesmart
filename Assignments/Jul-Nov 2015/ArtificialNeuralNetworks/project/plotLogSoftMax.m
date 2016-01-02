function [] = plotLogSoftMax( )
%PLOTLOGSOFTMAX plot the logsoftmax surface plot

probabilities = linspace(0, 1, 100);

[x, y] = meshgrid(probabilities);

xSoftmax = log(exp(x) ./ (exp(x) + exp(y)));
ySoftmax = log(exp(y) ./ (exp(x) + exp(y)));
xToyRatio = ySoftmax ./ xSoftmax;

surf(x, y, xSoftmax, gradient(xSoftmax));
%hold on; 
%surf(x, y, ySoftmax, gradient(ySoftmax));
xlabel('probability x');
ylabel('probability y');
zlabel('softmax for x & y');
title('x Soft max')

figure;
surf(x, y, xToyRatio, gradient(xToyRatio));
xlabel('probability x');
ylabel('probability y');
zlabel('softmax ratio y / x');
title('softmax ratio y / x')

end

