%% head
clear
close all
load dataFile.mat

doPlots = 1;

nS = length(data);
tDwell = 30;
% acceleration & deceleration are assumed to be 1 m/s^2, which is typical

K = kinematicsCalc(data, tDwell);

%% plot velocity functions
if doPlots
    figure(1)
    clf
    doNames = ["Van","Sea","Port"];
    iDo = contains([data.city],doNames) | contains([data.sysName],doNames);
    plot(K.jerkt(iDo,:)',K.jerkv(iDo,:)')
    legend([data(iDo).sysName],'location','eastoutside')
    xlabel('t (s)')
    ylabel('v (m/s)')
end

%% plot time spent accelerating as % of total moving time
if doPlots
    figure(2)
    clf
    sysNameLabel = categorical([data.sysName]);
    sysNameLabel = reordercats(sysNameLabel,flip([data.sysName]));
    H = barh(sysNameLabel, [2*K.tA ./ K.tTot, (K.tMov - 2*K.tA) ./ K.tTot, ...
        repmat(tDwell,nS,1) ./ K.tTot], 'stacked');
    c = pink(5);
    H(1).FaceColor = c(1,:); H(2).FaceColor = c(2,:); H(3).FaceColor = c(4,:);
    set(gca, 'XGrid','on')
    title(["time breakdown of systems"; ...
        strcat("assuming acc = 1 m/s^2 & dwell time = ",string(tDwell)," s")])
    legend(["accelerating";"cruising";"dwelling"], ...
        'location','southoutside', 'orientation','h')
end
