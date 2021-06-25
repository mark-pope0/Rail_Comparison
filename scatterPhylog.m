function scatterPhylog(x, y, labels, clusters, nLabelCols, doLabels)
% plot clustered points
for ic = 1:size(clusters,1)
    scatterPhylogSub(x, y, clusters{ic,1}, clusters{ic,2})
    hold on
    grid on
end

% plot orphan points
c = ~any(sort([clusters{:,1}]) == (1:length(x))',2);
scatterPhylogSub(x, y, c, [.1 .1 .1])
    clear c

% add labels
if doLabels
labelBinsX = min(x) : range(x)/nLabelCols : max(x);
labelBins = clamp(ceil((x-min(x)) ./ range(x) .* nLabelCols), 1,nLabelCols);
c.a = axis;
for iB = 1:nLabelCols
    [~,c.i] = sort(y(labelBins == iB));
    c.n = labels(labelBins == iB);
    H = text(labelBinsX(iB), c.a(4), c.n(flip(c.i))', ...
    'FontSize',5,'Color',[.5 .5 .5]);
    H.VerticalAlignment = 'top';
        clear H
end
    clear c
end


end

function scatterPhylogSub(x, y, cluster, colour)

plot(x(cluster),y(cluster), ...
        '.', 'color',colour, 'markersize',15)

end