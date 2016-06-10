function [output] = getActivationOutput(activationFcn, data)

output = [];

switch (activationFcn)
    case 'softmax'
        output = softmax(data')';
    case 'logsig'
        output = logsig(data);
    case 'tansig'
        output = tansig(data);
    case 'purelin'
        output = purelin(data);
end

end