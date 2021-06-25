clear
load dataLoadFile.mat

%% clear ans and save after adding data
clear ans
save dataLoadFile.mat

%% calculate derived parameters
data = dataLoad;

for il = 1:length([data.city])
    c = [dataLoad(il).city] + ': ' + [dataLoad(il).lines];
    data(il).sysName = c;
end

clear c

[data.capCar] = disperse(([data.carLength] - 0.5) .* ([data.carWidth] - 0.5) * 4);
    dataUnits.capCar   = '(riders/car)';
    
[data.capTrain] = disperse([data.capCar] .* [data.carsTrain]);
    dataUnits.capTrain = '(riders/train)';
    
[data.trainMass] = disperse([data.carMass] .* [data.carsTrain]);
    dataUnits.trainMass    = '(Mg/train)';
    
[data.f] = disperse(60 ./ [data.headway]);
    dataUnits.f        = '(trains/min)';
    
[data.cap] = disperse([data.capTrain] ./ [data.headway]);
    dataUnits.cap      = '(riders/s)';
    
[data.trainskm] = disperse([data.f] .* 60 ./ [data.v]);
    dataUnits.trainskm = '(trains/km)';
    
K = kinematicsCalc(data, 0); % 0s dwell time here, to keep LA from goofing

[data.KETrainMax] = disperse(K.KECruise);
    dataUnits.KETrainMax = '(MJ/train)';
    % energy of one train at cruising velocity

[data.PTrainAcc] = disperse(K.KECruise ./ K.tA .* 1000);
    dataUnits.PTrainAcc = '(kW/train)';  
    % power to accelerate 1 train at a given moment
    
[data.PTrain] = disperse(K.KECruise ./ K.tTot .* 1000);
    dataUnits.PTrain = '(kW/train)';  
    % mean power to operate 1 train, assuming braking is energy-neutral
    
[data.PDens] = disperse([data.trainskm] .* [data.PTrain]);
    dataUnits.PDens   = '(W/m)';
    % power to operate all trains on a given length of track, assuming '''
    
clear il c dataLoad K
save dataFile.mat




