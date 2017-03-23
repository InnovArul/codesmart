% create the Markov-1 process matrix
R = CreateMarkovMatrix(0.91, 8)
rou = 0.91;

%% WHT transformation

[U, S, V] = svd(R);

C = dctmtx(8)
R_dct = C * R * C'
[V, E] = eig(R);
eigVectorsR = U
PE_dct = getPackingEfficiency(R_dct);
DE_dct = getDecorrelationEfficiency(R_dct, R)

%% hadamard transformation

H = hadamard(8);
R_wht = (H * R * H) / (2 * sqrt(2))
PE_wht = getPackingEfficiency(R_wht);
DE_wht = getDecorrelationEfficiency(R_wht, R)

% plot the packing efficiencies
figure();
plot(PE_dct, 'color', 'r', 'marker', '*');
hold on;
plot(PE_wht, 'color', 'b', 'marker', 'o');
xlabel('M');
ylabel('energy packing efficiency');
legend({'DCT', 'WHT'});
title('Energy packing efficiency for different number (M) of basis functions');


%% find beta^2 R^-1
betaa = (1 - rou^2) / (1 + rou^2);
betaSqrRinv = betaa * pinv(R)

%% find Q - a tri diagonal matrix
alphaa = rou / (1 + rou^2);
Q = full(gallery('tridiag', 8, -alphaa, 1 , -alphaa));
Q(1, 1) = 1 - alphaa; Q(8, 8) = 1 - alphaa

% yes, beta^2 R^-1 is close to tridiagonal matrix Q
% During DCT transformation, we get similar diagonalization.

dct_Q = C * Q * C'
dct_betaSqrRinv = C * betaSqrRinv * C'