clear all;
clc;

%% User Defined Parameters
maxres=268; % maximum residue number of protein of interest
pcuttoff=0.01; % cut off for p value to pick statistically significat R
OutMatrixFileName = 'KS_Both.mat'; % MUST START WITH "KS_"
if (~strcmp(OutMatrixFileName(1:2),'KS'))
  error('OutMatrixFileName must start with KS');
end

%% Read the file names of XPK files in current folder
list_temp=ls('*.xpk');
for i=1:size(list_temp,1)
    list{i} = strtrim(list_temp(i,:));
end

%% Read Chemical Shift of each of the XPK file
matres=nan(maxres,length(list)); % Initialize the residue number matrix for debugging
matcsh=nan(maxres,length(list));matcsn=nan(maxres,length(list)); % Initilize the CS_H and Cs_N matrix
for i=1:size(list_temp,1)
    disp(['Processing ' num2str(i) ': ' list{i}]);
    [tres, tcsh, tcsn] = readXPKData(list{i});
    for j=1:length(tres)
        matres(j,i)=tres(j); % Used only for debugging, no useful information in this matrix
        matcsh(tres(j),i)=tcsh(j);
        matcsn(tres(j),i)=tcsn(j);
    end
end

% Compute Chemical Shift Matrix with relative weights to CS_H and CS_N
matcs=0.2*matcsn+matcsh;

% remove NaN values
matrixctnan=sum(~isnan(matcs'));
nsidex=find(matrixctnan<3);
matcs(nsidex,:)=NaN;

%% Calculate Corr Coff (R) and Save the matrix
sigR=eye(maxres,maxres);
[R,P]=corrcoef(matcs','rows','pairwise');
R=R.*cleanmatix(matcs);
[row,col]=find(P<pcuttoff);
sigR(find(P<pcuttoff))=R(find(P<pcuttoff));
sigR=abs(sigR);

Pio=zeros(maxres,maxres);
Pio(row,col)=1;

save(OutMatrixFileName,'P','R','Pio','matcs'); % Save the Matrix

%% Plot Significat R 
figure;
colormap hot;
imagesc(sigR);

%% Plot all R
figure;
load('crainbow.mat'); % ColorMap file
colormap(crainbow);
imagesc(tril(abs(R),-1));
h=gca;
h.XAxis.MinorTickValues = [0:10:268];
h.YAxis.MinorTickValues = [0:10:268];
h.XAxis.MinorTick = 'on';
h.YAxis.MinorTick = 'on';
h.LineWidth= 0.75;
h.FontSize = 20;
h.TickLength = [0.02 0.035];
grid on;
grid minor;
colorbar;

%% Calculate Linkage and Plot
figure;
linkR=linkage(sigR,'ward','euclidean');
dendrogram(linkR,0,'ColorThreshold','default');

xlabelo=findobj(gca,'type','axe');
xval=str2num(get(xlabelo,'XTickLabel'));