%% Daniel Jiang & Xiaoya Kang
function [model] = precipitation()
% Load csv
filename = 'data/jan-dec.csv'; 

% Read the data
data = readtable(filename);
data = data{1:end,1};

model = @(t) data(round(t));

% P = @(t) -1.03E7 + 823040*(t) -28897*(t).^2 + 585*(t).^3 -7.54*(t).^4 + 0.0638*(t).^5 -3.55E-4*(t).^6 + 1.25E-6*(t).^7 -2.52E-9 *(t).^8 + 2.2E-12*(t).^9;
% P = @(x) -1.03E+07 + 823040*x - 28897*x.^2 + 585*x.^3 - 7.54*x.^4 ...
%         + 0.0638*x.^5 - (3.55E-04)*x.^6 + (1.25E-06)*x.^7 ...
%         - (2.52E-09)*x.^8 + (2.2E-12)*x.^9;
% P = @(t) -14.5+0.346*t-1.6E-3*t.^2;
end