function clusters = colourizeDendrogram(H, nodes, colours, pref)

% find default colours
lineColourCache = nan(length(H),3);
xCoordsExtract = nan(length(H),2);
for ip = 1:length(H)
    lineColourCache(ip,:) = H(ip).Color; % extract colour to array
    xCoordsExtract(ip,:) = H(ip).XData([1,3]); % extract nodes (x coords) to array
end
coloursDefault = unique(lineColourCache,'rows','stable');
coloursDefault(sum(coloursDefault,2) == 0,:) = [];

% isolate clusters, calculate summary stats, and link up original colours
clusters = cell(size(coloursDefault,1),1);
clustersOrigC = clusters;
offSum = nan(size(coloursDefault,1),1);
offDif = offSum;
for ic = 1:size(coloursDefault,1)
    c.a = xCoordsExtract(all(coloursDefault(ic,:) == lineColourCache,2),:);
    c.b = c.a(floor(c.a) == c.a); % find nodes at integer x values
    clusters(ic) = {nodes(c.b)};
    offSum(ic) = mean(pref.yZ(nodes(c.b)) + pref.xZ(nodes(c.b)), 'omitnan');
    offDif(ic) = mean(pref.yZ(nodes(c.b)) - pref.xZ(nodes(c.b)), 'omitnan');
    % double-check that the colours of the nodes match the colours of their
    % clusters
    c.c = lineColourCache(any(reshape(c.b,1,1,numel(c.b)) == xCoordsExtract,[2,3]),:);
% note: single-leaf clusters seem to break this error catch; should fix.
%     if any(range(c.c,1) ~= 0)
%         error("cluster isn't aligning with itself, somehow")
%     end
    clustersOrigC(ic) = {c.c(1,:)};
        clear c
end

% assign new colours
clusters(offDif == max(offDif),2) = {colours.blue};
clusters(offSum == min(offSum),2) = {colours.green};
clusters(offSum == max(offSum),2) = {colours.red};
c.a = 0;
for ic = 1:size(clusters,1)
    if isempty(clusters{ic,2})
        c.a = c.a + 1;
        clusters(ic,2) = {colours.spare(c.a,:)};
    end
    c.b = all(lineColourCache == clustersOrigC{ic},2);
    lineColourCache(c.b,:) = repmat(clusters{ic,2},sum(c.b),1);
end
    clear c

% colourize dendrogram with new colours
for ip = 1:length(H)
    H(ip).Color = lineColourCache(ip,:);
end




end