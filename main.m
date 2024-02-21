%% Daniel Jiang & Xiaoya Kang - Math 462 Project
clc; close all; clear;

% Generate random mountain map
[X, Y, Z] = fractal_mountain_3D();
Z = Z*250;

% Get temperature model
T = temperature(); 

% Get elevation. NOTE: should slice the mountain map iteratively
E = 800;

% Get the precipitation model
P = precipitation();

% Solve the ode
opts = odeset('NonNegative',1,'RelTol',1e-3,'AbsTol',1e-5);
time = 1:1:365;
[t,y] = ode45(@(t,y) snow_rhs(t,y,P,T,E),time,[1],opts);

%% Simple plots
% Plot mountain
f = figure();
f.Position = [100 100 500 1000];
% subplot(4,1,1);
% surf(X,Y,Z,'FaceColor','interp','FaceLighting','phong');
% % axis([1 2 1 2 1 3]);
% shading interp;
% colormap('jet');
% zlabel('Elevation (m)');
% title('Mountain Generation','FontSize',12)
% bar = colorbar; bar.Label.String = 'Elevation';
% camlight left;
% ax = gca;
% ax.FontSize = 16;

% Plot ODE solution, i.e. the snowfall accumulation
subplot(3,1,1);
plot(t,y(1:end,1));
title(sprintf('Snowfall Accumulation at Elevation=%gm', E));
xlabel('day');
ylabel('inches');
legend('Snow Accumulation');
ax = gca;
ax.FontSize = 16;
% axis([0 365 0 10]);

% Plot the precipitation
subplot(3,1,2);
plot(time, P(time));
title('Precipitation');
xlabel('day');
ylabel('inches');
legend('Snowfall');
ax = gca;
ax.FontSize = 16;
% axis([0 365 0 10]);

% Plot the temperature
subplot(3,1,3);
plot(time, T(time));
title('Temperature');
xlabel('day');
ylabel('C');
legend('Temperature')
ax = gca;
ax.FontSize = 16;
% axis([0 365 10 90]);

function dydt = snow_rhs(t,y,P,T,E)
    dydt = zeros(1,1);
    S = y(1); % Current amount of snow

    % Define M inside snow_rhs to use the current snow amount S
    T_melt = 0;
    E_ref = 3048;
    k1 = 0.39; %0.5; % controls the melting rate
    k2 = 0.5; %0.5; % controls the compaction rate
    k3 = 1000; % controls the maximum compaction

    % Check if S is zero, and adjust melting rate accordingly
    if S <= 0
        M = 0; % No melting if there's no snow
        C = 0;
    else
        M = k1 * max(T(t) - T_melt, 0) * (1 - E/E_ref); % Melting rate independent of S
        C = k2 * S/k3;
    end
    
    dydt(1) = P(t) - M - C;
end