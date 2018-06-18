function [cval] = gettoppercentage(matrix,cper)

matrix=matrix(:);
matrix(find(isnan(matrix)))=0;
matrix=sort(matrix,'descend');
matrix(length(matrix)/2:length(matrix))=[];
matrix(find(matrix==0))=[];
if nargin < 2
    figure;
    pd=histfit(matrix,20,'HalfNormal');
    pd=fitdist(matrix,'HalfNormal');
    cval=pd.sigma*3;
    line([cval cval],ylim,'Color','red','LineStyle','--');
    title(['\sigma = ' num2str(pd.sigma)]);
else
    if cper == 0
        figure;
        pd=histfit(matrix,20,'Normal');
        pd=fitdist(matrix,'Normal');
        cval=pd.mu+3*pd.sigma;
        line([cval cval],ylim,'Color','red','LineStyle','--');
        title(['\mu = ' num2str(pd.mu) ' \sigma = ' num2str(pd.sigma)]);
    else
        hist(matrix,20);
        cutoff=ceil(cper*length(matrix)/100);
        cval=matrix(cutoff);
    end
end
end