% Script to quadtree downsample the unwrapped
% co-seismic interferograms (unw.geo) from ISCE 

% 3-columns input: [lon, lat, LOS] to perform quadtree downsampling

% Modified the quadtree function available in the GBIS (Bagnardi & Hooper, 2018)

% Created by: Dibyashakti Panda on 30 May 2025

% Last Modified: 30 May 2025


clear all
close all
clc

%%
% Input File: "filt_250216-250330_10rlks_56alks.unw.geo.txt"
% 3-columns should be: [lon, lat, LOS] to perform quadtree downsampling
% Use "save_gmt.py" in ISCE to convert the "unw.geo" file to "grd" file
% May use GMT to convert grd to xyz file (grd2xyz)

% Getting xyz from GMT may provide large datasets (in millions)
% May spatial downsample first before giving input

% === Load input file ===
tic
fprintf('Loading Input File....\n')
data = load('filt_250216-250330_10rlks_56alks.unw.geo.txt');   % Must be 3 columns: lon, lat, LOS
lon = data(:,1);
lat = data(:,2);
los = data(:,3);
fprintf('Loading Input File....DONE')
toc
%%
% === Clean NaNs ===
valid = ~isnan(lon) & ~isnan(lat) & ~isnan(los);
lon = lon(valid); lat = lat(valid); los = los(valid);

% === Prepare input for quadtree ===
xy = [(1:length(lon))', lon, lat];  % index, lon, lat
val = los;

% === Quadtree parameters ===
thresh = 2;         % (May try to vary between 0.1 to 5)
maxlevel = 10;
startlevel = 1;

% === Run quadtree ===
[nb, err, npoints, centers, values, polys, xlims, ylims] = quadtreeISCE(xy, val, thresh, maxlevel, startlevel);

% === Get averaged LOS per polygon ===
down_vals = quadtreeExtractISCE(xy, val, xlims, ylims);


%% Plot figures and compared the downsampled data with the original data

figure;
set(gcf,'position',[200,400,1100,500])
subplot(1,2,1)
% scatter(lon, lat, 1, los, 'filled');
% Filter out zero values in 'los'
nonzero = los ~= 0;
scatter(lon(nonzero), lat(nonzero), 1, los(nonzero), 'filled');
caxis([-20 20])
axis equal; title('Original LOS'); colorbar;
xlabel('Lon'); ylabel('Lat');

subplot(1,2,2)
scatter(centers(:,1), centers(:,2), 15, down_vals, 'filled');
hold on
% Plot quadtree squares
for i = 1:size(xlims, 1)
    % Define rectangle corners from xlims and ylims
    rectX = [xlims(i,1), xlims(i,2), xlims(i,2), xlims(i,1), xlims(i,1)];
    rectY = [ylims(i,1), ylims(i,1), ylims(i,2), ylims(i,2), ylims(i,1)];
    plot(rectX, rectY, 'k-', 'LineWidth', 0.5); % quadtree square border
end
axis equal; title('Quadtree Downsampled'); colorbar;
xlabel('Lon'); ylabel('Lat');
hold on;
axis equal;
colormap(bluewhitered);
caxis([-20 20])

%% Save the output file
out = [centers, down_vals'];
% save('quadtree_downsampled.txt', 'out', '-ascii');
