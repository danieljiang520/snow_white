%% Daniel Jiang & Xiaoya Kang - Math 462 Project
clc; close all; clear;

% Generate random mountain map
[X, Y, Z] = fractal_mountain_3D();
Z = Z*250;%Z*250;

% Get temperature model
T = temperature(); 

% Get elevation. NOTE: should slice the mountain map iteratively
E = 600;

% Get the precipitation model
P = precipitation();

% Solve the ode
tic;
opts = odeset('NonNegative',1,'RelTol',1e-3,'AbsTol',1e-4);
time = 1:1:365;
N = 65;
y0 = ones(N^2,1);
[t,y] = ode45(@(t,y) snow_rhs(t,y,P,T,Z,N),time,y0,opts);
toc;

%% Simple plots
% Plot mountain
figure(1);
% subplot(4,1,1);
surf(X,Y,Z,'FaceColor','interp','FaceLighting','phong');
% axis([1 2 1 2 1 3]);
zlabel('Elevation (m)');
shading interp;
colormap('jet');
camlight left;

% % Plot ODE solution, i.e. the snowfall accumulation
% subplot(4,1,2);
% plot(t,y(1:end,1));
% title('Snowfall Accumulation (inches)');
% xlabel('day');
% ylabel('inches');
% % axis([0 365 0 10]);
% 
% % Plot the precipitation
% subplot(4,1,3);
% plot(time, P(time));
% title('Precipitation (inches)');
% xlabel('day');
% ylabel('inches');
% % axis([0 365 0 10]);
% 
% % Plot the temperature
% subplot(4,1,4);
% plot(time, T(time));
% title('Temperature');
% xlabel('day');
% ylabel('C');
% % axis([0 365 10 90]);

%% Loop the mountain
for i=1:length(t)
    snow_at_t = reshape(y(i,1:N^2),[N N]); snow_at_t = snow_at_t';
    f = figure(2);
    f.Position = [100 100 1000 500];
    subplot(1,2,1);
%     h = heatmap(snow_at_t,'CellLabelColor','none');
    surf(X,Y,Z,snow_at_t,'FaceColor','interp','FaceLighting','phong');
    colormap('bone'); 
    bar = colorbar; bar.Label.String = 'Snowfall accumulation (inches)';
    caxis([0 120]);
    zlabel('Elevation (m)');
    title(sprintf('Snowfall Accumulation (Low Elevation) at day=%g', i),'FontSize',13);

    subplot(1,2,2);
    temp_t = 1:1:i;
    plot(temp_t, P(temp_t));
    title(sprintf('Snowfall at day=%g', i), "FontSize", 13);
    xlabel('Day');
    ylabel('Inches');
    axis([0 365 0 15]);

    pause(0.01);
end

function dydt = snow_rhs(t,y,P,T,E,N)
    dydt = zeros(N^2,1);
    S = reshape(y(1:N^2),[N,N]); S = S'; % Current amount of snow
    M = zeros(N,N); C = M;

    % Params
    k1 = 0.39; % controls the melting rate
    T_melt = 0; % melting temp
    E_ref = 3048; % Highest elevation that stops melting
    k2 = 0.5; % controls the compaction rate
    C_max = 1000; % controls the maximum compaction

    for i=1:N
        for j=1:N

            % Check if S is zero, and adjust melting rate accordingly
            if S(i,j) <= 0
                M(i,j) = 0; % No melting if there's no snow
                C(i,j) = 0;
            else
                M(i,j) = k1 * max(T(t) - T_melt, 0) * (1 - E(i,j)/E_ref);
                C(i,j) = k2 * S(i,j)/C_max;
            end
        end
    end
    dSdt = P(t) - M - C;
    dSdt = dSdt';
    dydt(1:N^2) = reshape(dSdt,[N^2,1]);
end

