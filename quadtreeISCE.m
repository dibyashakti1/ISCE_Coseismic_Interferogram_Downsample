function [nb, err, npoints, centers, values, polys, xlims, ylims] = quadtreeISCE(xy,val,thresh,maxlevel,startlevel)
% Quadtree subsampling of scattered data
% Based on Decriem (2009), Gonzalez (2015), and GBIS (Bagnardi, 2018)

%% ---- Initialize Outputs ----
nb = 0; err = 0;
npoints = []; centers = []; values = []; polys = {};
xlims = []; ylims = [];

% Default start level
if nargin < 5
    startlevel = 1;
end

% If less than 3 points, return immediately
if size(xy,1) < 3
    return;
end

% ---- Initial Plot (only for root call) ----
if startlevel == 1
    figure('Position', [1, 1, 700, 700]);
end

% ---- Stop if past max depth ----
if startlevel > maxlevel
    K = convhull(xy(:,2), xy(:,3));
    plot(xy(K,2), xy(K,3), 'color', [0.8 0.8 0.8]); hold on;
    return;
end

% ---- Determine cell geometry ----
dx = (max(xy(:,2)) - min(xy(:,2)));
dy = (max(xy(:,3)) - min(xy(:,3)));
cx = min(xy(:,2)) + dx/2;
cy = min(xy(:,3)) + dy/2;

% For plotting
lims = [min(xy(:,2)), max(xy(:,2)), min(xy(:,3)), max(xy(:,3))];
xlims = [lims(1) lims(1) lims(2) lims(2) lims(1)];
ylims = [lims(3) lims(4) lims(4) lims(3) lims(3)];

% ---- Compute statistics ----
mpoly = mean(val);
spoly = var(val);

% ---- Stop condition: variance below threshold ----
if spoly < thresh
    if startlevel == 1
        error(['Quadtree threshold (', num2str(thresh), ') is larger than data variance (', num2str(spoly), '). Lower the threshold.']);
    end
    K = convhull(xy(:,2), xy(:,3));
    patch(xy(K,2), xy(K,3), mpoly); hold on;
    
    nb = 1;
    err = sum(abs(val - mpoly));
    npoints = length(val);
    centers = [cx, cy];
    values  = mpoly;
    polys   = {xy(K,:)};
    xlims   = [min(xy(:,2)), max(xy(:,2))];
    ylims   = [min(xy(:,3)), max(xy(:,3))];
    return;
end

% ---- Subdivide into 4 quads ----
first = true;
for i = 1:4
    switch i
        case 1  % Bottom-left
            xyv = [cx-dx, cx-dx, cx,   cx; ...
                   cy-dy, cy,    cy,   cy-dy]';
        case 2  % Bottom-right
            xyv = [cx,    cx,    cx+dx, cx+dx; ...
                   cy-dy, cy,    cy,    cy-dy]';
        case 3  % Top-left
            xyv = [cx-dx, cx-dx, cx,    cx; ...
                   cy,    cy+dy, cy+dy, cy]';
        case 4  % Top-right
            xyv = [cx,    cx,    cx+dx, cx+dx; ...
                   cy,    cy+dy, cy+dy, cy]';
    end

    in = find(xy(:,2) <= xyv(3,1) & xy(:,2) >= xyv(1,1) & ...
              xy(:,3) <= xyv(2,2) & xy(:,3) >= xyv(1,2));

    if ~isempty(in)
        [pnb, perr, pnpoints, pcenter, pvalue, ppoly, pxlims, pylims] = ...
            quadtreeISCE(xy(in,:), val(in), thresh, maxlevel, startlevel + 1);
        
        if pnb > 0
            nb = nb + pnb;
            err = err + perr;
            if first
                centers = pcenter;
                values  = pvalue;
                polys   = ppoly;
                npoints = pnpoints;
                xlims   = pxlims;
                ylims   = pylims;
                first   = false;
            else
                centers = [centers; pcenter];
                values  = [values, pvalue];
                polys   = [polys; ppoly];
                npoints = [npoints; pnpoints];
                xlims   = [xlims; pxlims];
                ylims   = [ylims; pylims];
            end
        end
    end
end
return