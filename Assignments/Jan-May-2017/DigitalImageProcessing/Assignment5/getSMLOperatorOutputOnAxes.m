function SMLoutput = getSMLOperatorOutputOnAxes(frame)
%% return the Fxx and Fyy

FxxFilter = [0 1 0; 0 -2 0; 0 1 0];
FyyFilter = [0 0 0; 1 -2 1; 0 0 0];

SMLxOutput = conv2(frame, FxxFilter, 'same');
SMLyOutput = conv2(frame, FyyFilter, 'same');

SMLoutput{1} = abs(SMLxOutput);
SMLoutput{2} = abs(SMLyOutput);

end