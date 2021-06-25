function out = kinematicsCalc(data, tDwell)

nS = length(data);
d    = [data.stopSpacing]';
vTot = [data.v]' ./ 3.6;
tTot = d./vTot;
tMov = tTot - tDwell;
vMov = d./tMov;
    tA = nan(nS,2);
for iS = 1:nS
    % tA = vCruise
    % 0 = -tA.^2 + tMov.*tA - d;
    tA(iS,:) = roots([-1,tMov(iS),-d(iS)]);
    if ~isreal(tA(iS,:))
        tA(iS,:) = nan(1,2);
    end
end

tA = min(tA,[],2);
vCruise = tA; % assuming acceleration always = 1 m/s^2 (very handy)

jerkt = [zeros(nS,1), tA, tMov-tA, tMov]; % points of t where acc changes
jerkv = [zeros(nS,1), vCruise, vCruise, zeros(nS,1)]; %  '''  v  '''

%% calculating peak kinetic energy (= energy needed to accelerate)
m = [data.trainMass]';
tCruise = tMov - tA .* 2;
KECruise = .5 .* m .* vCruise.^2 ./ 1000; % m = kg, v = m/s, KE = MJ

%% preparing output structure
out = struct( ...
    'd',d, ...
    'jerkt',jerkt, ...
    'jerkv',jerkv, ...
    'KECruise',KECruise, ...
    'tA',tA, ...
    'tCruise',tCruise, ...
    'tDwell',tDwell, ...
    'tMov',tMov, ...
    'tTot',tTot, ...
    'vCruise',vCruise, ...
    'vMov',vMov, ...
    'vTot',vTot);
