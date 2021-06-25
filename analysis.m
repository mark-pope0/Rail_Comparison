%% head
clear
close all
load dataFile.mat

pref.nCluster = 5;
pref.linkMode = 'average'; % can use: 
        % single, complete, average, weighted, centroid, ward
pref.fCutoff  = 20; % excludes systems with headway longer than this
pref.scatterNLabelCols = 10;
pref.scatterLabels = false;

pref.doFig = [
                1; % dendrogram
                1; % scatter plot
                0; % kinetic energy bar graph
                0; % f / KE scatter plot
             ];
pref.export   = true; % do export of figures?

data([data.headway] > pref.fCutoff*60) = [];
nSys = length([data.city]);
pref.x = [data.f]'.*60;  % set parameters to assess here
pref.y = [data.PDens]'./3.6;         % ' ' '
pref.xLabel = "frequency (trains/hr)";
pref.yLabel = "linear power density (W/m)";
pref.xZ = zscore(pref.x);
pref.yZ = zscore(pref.y);

colours = struct('black', [0.1  0.1  0.1], ...
                   'red', [0.6  0.0  0.0], ...
                  'blue', [0.5  0.8  0.9], ...
                 'green', [0.3  0.7  0.4], ...
                 'spare', [0.8  0.8  0.3 ;      % yellow
                           0.8  0.4  0.0 ;      % orange
                           0.5  0.5  0.6]); ... % grey
                           
%% prep
distances = pdist([pref.xZ, pref.yZ]);
distSquare = squareform(distances);

tree = linkage(distances,pref.linkMode);
threshold = ...
    mean([tree(end-pref.nCluster+2,3), tree(end-pref.nCluster+1,3)]);

% [colours.arr, clusters] = assignColours(pref.xZ, pref.yZ, colours, pref);

%% dendrogram
if pref.doFig(1)
    figure(1)
        clf
    [H,~,nodes] = dendrogram(tree,0,'labels',[data.sysName],'colorThreshold',threshold);
    xtickangle(-60)
    set(gca,'FontSize',7)
    ylabel('difference factor')
    
    clusters = colourizeDendrogram(H, nodes, colours, pref);
    
    if pref.export
        exportgraphics(figure(1),'tree2d.png','Resolution',300)
    end
%     clear H1
end

%% scatter
if pref.doFig(2)
    figure(2)
        clf
    scatterPhylog(pref.x, pref.y, [data.sysName], ...
        clusters, pref.scatterNLabelCols, pref.scatterLabels)
    xlabel(pref.xLabel)
    ylabel(pref.yLabel)
    
    if pref.export
        exportgraphics(figure(2),'scatter2d.png','Resolution',300)
    end
end

%% kinetic energy
if pref.doFig(3)
    figure(3)
        clf
    [~,c.a] = sort([data.KEDens]);
    c.b = categorical([data(c.a).sysName]);
    c.b = reordercats(c.b,string(c.b));
    barh(c.b,[data(c.a).KEDens],'facecolor',colours.blue)
    xlabel('linear kinetic energy density (kJ/m)')
    clear c
end

if pref.doFig(4)
    figure(4)
        clf
    scatterPhylog([data.KE], [data.trainskm], ...
        colours.arr, [data.sysName], clusters)
    xlabel('mean kinetic energy (MJ/train)')
    ylabel('train density (trains/km)')
end
    










