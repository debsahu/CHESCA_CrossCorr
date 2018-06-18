function [cleancs] = cleanmatix(matcs)
% Discard data that have more than 3 NaN values for every pertubation
% (mutation)
matlim=length(matcs);
cleancs=ones(matlim,matlim);
for i=1:matlim
    for j=1:matlim
        tmpsum=matcs(i,:)+matcs(j,:);
        nanct=sum(isnan(tmpsum));
        if nanct > 3
            cleancs(i,j)=NaN;
            cleancs(j,i)=NaN;
        end
    end
end