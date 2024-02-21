%% Daniel Jiang - Math 462 HW2
function [temp_model] = temperature()
% Load csv
filename = 'data/aa_temp.csv'; 

% Read the mean temperature data
data = readtable(filename);

% Extracting the timestamp and mean temperature
temp = data{11:end,4}.'; % 4th col
temp = (temp - 32) * 5/9; % convert to celsius
temp = (temp - 10)*1.5; % shift to Ann Arbor
t = 1:length(temp);

% difference between model and data
fun = @(x) x(1).*cos(x(2).*t - x(3))+x(4) - temp;
x0 = [50,750/(2*pi),0,30];


parfits = lsqnonlin(fun,x0);
temp_model = @(t) parfits(1).*cos(parfits(2).*t - parfits(3))+parfits(4);

% plot the optimal model with the lsqnonlin quadratic model
% figure();
% hold on;
% plot(t,temp,'LineStyle','none','Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k'); % keep the figure open
% plot(t,temp_model(t),'-r','LineWidth',1);
% hold off;
% legend('data','fitted model');
% xlabel('t');
% ylabel('Temperature (C)');
% title('The Highlands at Harbor Springs Temperature (2023/01/01 - 2024/01/01)');
% ax = gca;
% 
% disp('The parameters, ABCD, of my model is the following, respectively:');
% disp(parfits);

%{
Citation:
Historical Weather Data Download. meteoblue. (n.d.). https://www.meteoblue.com/en/weather/archive 
%}

%% 3B
%{
The annual average temperatures in Ann Arbor warmed by 0.7°F from
1951-2014. We can use another model to model the increase in annual average
temperature for our D parameter. Depending how far back in history we want
to model, we might use different model for this purpose. One example is to
use population as a parameter to support the assumption that as population
increases, the temperature increases.
%}
end