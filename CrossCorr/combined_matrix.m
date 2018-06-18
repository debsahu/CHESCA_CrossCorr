function [scaled_mat,lagmat,catm] = combined_matrix(KineticReactionMatrix, P, patternlogic)
% x-correlation analysis
sizem=size(KineticReactionMatrix,1);

startres=[];
for i=1:sizem
    if KineticReactionMatrix(i,i)~=0
        startres=i;
        break;
    end
end

ranger=startres:sizem;
offset=0;
catm=zeros(sizem,sizem,min(ranger)-1);

fprintf('XCorr Analysis\nResidue: ');
scaled_mat=zeros(sizem,sizem);pct=0;
%residue_to_analyze=236;
for residue_to_analyze=ranger
    fprintf('%d ', residue_to_analyze);
    xcorrmat=zeros(sizem,sizem);
    lagmat=zeros(sizem,sizem);
    for i=startres+1:sizem
        res1=KineticReactionMatrix(i-offset,residue_to_analyze-offset,:);res1=res1(:);
        res1po=okpattern(res1);
        res1=[res1;res1;res1];
        res1p=P(i-offset,residue_to_analyze-offset,:);res1p=res1p(:);
        res1p=[res1p;res1p;res1p];
                
        for j=startres:sizem
            if(j<i)
                res1=KineticReactionMatrix(i-offset,residue_to_analyze-offset,:);res1=res1(:);
                res1po=patternlogic(i-offset,residue_to_analyze-offset);
                res1=[res1;res1;res1];
                res1p=P(i-offset,residue_to_analyze-offset,:);res1p=res1p(:);
                res1p=[res1p;res1p;res1p];
                res2=KineticReactionMatrix(j-offset,residue_to_analyze-offset,:);res2=res2(:);
                res2po=patternlogic(j-offset,residue_to_analyze-offset);
                res2=[res2;res2;res2];
                res2p=P(j-offset,residue_to_analyze-offset,:);res2p=res2p(:);
                res2p=[res2p;res2p;res2p];
                %if( ~isempty(find(res1p<=0.01)) && ~isempty(find(res2p<=0.01)) && isempty(find(res1==0)) && isempty(find(res2==0)) )
                if( (res1po) && (res2po) && ~isempty(find(res1p<=0.05)) && ~isempty(find(res2p<=0.05)) && isempty(find(res1==0)) && isempty(find(res2==0)) )
                %if( (res1po) && (res2po) && ~isempty(find(abs(res1)>=0.85)) && ~isempty(find(abs(res2)>=0.85)) && isempty(find(res1==0)) && isempty(find(res2==0)) )
                    [XCF,lags,bounds] = crosscorr(res1,res2,3,3);
                    [M,I] = max(abs(XCF));
                    if ~isnan(M) && M > abs(bounds(1))
                        xcorrmat(i,j)=M;
                        lagmat(i,j)=lags(I);
                    else
                        xcorrmat(i,j)=0;
                        lagmat(i,j)=0;
                    end
                else
                    xcorrmat(i,j)=0;
                    lagmat(i,j)=0;
                end
            end
        end
    end
    
    %xcorrmat(find(xcorrmat<cutoff))=0;
    
    if(max(max(xcorrmat))>0)
        scaled_mat=scaled_mat+xcorrmat;
        catm=cat(3,catm,xcorrmat);
        pct=pct+1;
    else
        catm=cat(3,catm,zeros(sizem,sizem));
    end
end
if pct==0
    pct=1;
end
scaled_mat=scaled_mat/pct;
%end function
end