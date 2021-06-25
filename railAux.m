clear
load dataFile.mat

figure(101)
    clf
[capVel,capVelOrder] = sort(dataFull.cap./dataFull.v);
sysName = categorical(dataFull.sysName(capVelOrder),dataFull.sysName(capVelOrder));

bar(sysName,capVel)
ylabel('capacity / velocity (riders/m)')

% figure(102)
%     clf
% scatter(dataFull.cap,dataFull.v,[],dataFull.f,'filled')
% xlabel('capacity (riders/s)')
% ylabel('mean speed (km/h)')
% H = colorbar;
% title(H,'f (trains/min)')
% clear H

% figure(103)
%     clf
% scatter(dataFull.f,dataFull.v,dataFull.capTrain,dataFull.capTrain,'filled')
% xlabel('frequency (trains/min)')
% ylabel('mean speed (km/h)')