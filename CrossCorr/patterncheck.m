function [patternlogic, percentaccepeted] = patterncheck(RMatrix)
% Function to check for patterns of R such that there is only one
% inflection point
%% Check if number of arguments is not 1 and read data manually here
if nargin ~= 1
    list_temp=ls('../CHESCA/KS*');
    for i=1:size(list_temp,1)
        list{i} = strtrim(list_temp(i,:));
    end

    KineticReactionMatrix=[]; KineticReactionMatrixP=[]; KineticReactionMatrixCS=[];
    for i=1:size(list_temp,1)
        matfile=ls(['../CHESCA/' list{i} '/KS*.mat']);
        load(['../CHESCA/' list{i} '/' matfile]);
        R(isnan(R))=0;
        KineticReactionMatrix = cat(3, KineticReactionMatrix, round(R,3));
        clearvars R P Pio matcs;
    end
    RMatrix = KineticReactionMatrix;
end

%% Analysis
fprintf('Checking for pattern of R\nResidue: ');
sizem=size(RMatrix,1);
logic=false(sizem,sizem);
logicall=false(sizem,sizem);
for i=1:sizem
    fprintf('%d ', i);
    %disp(status);
    for j=1:sizem
        res=RMatrix(i,j,:);res=res(:);
        logic(i,j)=okpattern(res);
        if sum(isnan(res))==0 && isempty(find(res==0, 1))
            logicall(i,j)=true;
        end
    end
end
fprintf('\n');

allaccepted=sum(sum(tril(logic,-1)));
allsum=sum(sum(tril(logicall,-1)));
percentaccepeted=allaccepted/allsum;

patternlogic=logic;
% Save pattern for further use
save 'patternlogic.mat' patternlogic