clear;
clc;

%% Read CHESCA data
% List all directories containing input in CHESCA folder
list_temp=ls('../CHESCA/KS*');
for i=1:size(list_temp,1)
    list{i} = strtrim(list_temp(i,:));
end
% Read 'KS_xxxxxx.mat' from each of these directory
% Store data as a 3D matrix: R, p and combined chemical shifts
KineticReactionMatrix=[]; KineticReactionMatrixP=[]; KineticReactionMatrixCS=[];
for i=1:size(list_temp,1)
    matfile=ls(['../CHESCA/' list{i} '/KS*.mat']);
    load(['../CHESCA/' list{i} '/' matfile]);
    R(isnan(R))=0;
    KineticReactionMatrix = cat(3, KineticReactionMatrix, round(R,3));
    KineticReactionMatrixP = cat(3, KineticReactionMatrixP, P);
    KineticReactionMatrixCS = cat(3, KineticReactionMatrixCS, KineticReactionMatrixCS);
    clearvars R P Pio matcs;
end

%% Check for patterns of R such that there is only one inflection point
if exist('patternlogic.mat', 'file') == 2
    % Step below takes time, so 'patternlogic.mat' is created during first
    % run and loaded automatically for subsequently
    load('patternlogic.mat');
else
    patternlogic = patterncheck(KineticReactionMatrix);
end

%% Analysis
[scaled_mat, lag_mat, rmat] = combined_matrix(KineticReactionMatrix, KineticReactionMatrixP, patternlogic);

%%
%cutoff=0.2; %0.25
cutoff=gettoppercentage(scaled_mat);
xcorrmatcpy=scaled_mat;
xcorrmatcpy(find(scaled_mat<=cutoff))=0;
figure;
load colormapry.mat;
colormap(c);
imagesc(xcorrmatcpy); colorbar;
h=gca;
h.XAxis.MinorTickValues = [0:10:size(KineticReactionMatrix,1)];
h.YAxis.MinorTickValues = [0:10:size(KineticReactionMatrix,1)];
h.XAxis.MinorTick = 'on';
h.YAxis.MinorTick = 'on';
grid on;
grid minor;

%%
figure;
xcorrmatcpy1=tril(xcorrmatcpy,-1)'+tril(xcorrmatcpy,-1)+eye(length(xcorrmatcpy));
xcorrmatcpy1(isnan(xcorrmatcpy1)) = 0;
linkR=linkage(xcorrmatcpy1,'ward','euclidean');
dendrogram(linkR,0,'ColorThreshold','default');

xlabelo=findobj(gca,'type','axe');
xval=str2num(get(xlabelo,'XTickLabel'));
