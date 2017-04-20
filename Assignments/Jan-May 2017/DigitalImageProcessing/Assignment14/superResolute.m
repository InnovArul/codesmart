clear all;
close all;

%frequencies
f0 = 4; % Hz
deltaF = 0.3; % Hz
f1 = f0 + deltaF;

Ts = 0.1; % seconds

refN = ceil(1 / (Ts * deltaF)) + 5;
if(mod(refN, 2) == 1) refN = refN + 1; end

x = [];

%generate X
for i = 1:refN
    nTs = i * Ts;
    x(i) = sin(2 * pi * f0 * nTs) + sin(2 * pi * f1 * nTs);
end

% determine W1 and W2
W1 = eye(length(x));
W2 = zeros(length(x));

W2i = zeros(1, length(x));
W2i(1,1) = 0.7;
W2i(1,2) = 0.3;
for i = 1:length(x)
    W2(i, :) = circshift(W2i, [0 i-1]);
end

% determine D which is a downsampler by 2
D = zeros(refN/2, refN);
Di = zeros(1, length(x));
Di(1, 1) = 1;
Di(1,2) = 1;

for i = 1:refN/2
    D(i, :) = circshift(Di, [0 (i-1)*2]);
end
D = 0.5 * D;

y1 = D * W1 * x';
y2 = D * W2 * x';

x1 = pinv([D*W1; D*W2;]) * [y1; y2;];
plot(x', '-*r');
hold on;
plot(x1, '-db');
legend({'original x', 'reconstructed x'});

MSE = norm(x' - x1)

