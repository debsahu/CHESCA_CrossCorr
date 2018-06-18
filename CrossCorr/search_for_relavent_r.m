function [] = search_for_relavent_r( D60Nmatrix, rmat, res1, res2)
sizem = size(D60Nmatrix,1);
figure;
if res1 < res2
    rmat_a = rmat(res2, res1, :); rmat_a = rmat_a(:);
else
    rmat_a = rmat(res1, res2, :); rmat_a = rmat_a(:);
end
plot(1:sizem, rmat_a, 'o-');
str = 'y';
while ( strcmp(str,'y') || strcmp(str,'Y') )
    str=input('Do you want to analyze a residue? Y/N [Y] : ','s');
    if isempty(str)
        str = 'y';
    end
    if strcmp(str,'Y') || strcmp(str,'y')
        residue_to_analyze = input('Residue to analyze: ');
        resresplot(D60Nmatrix,residue_to_analyze,res1,res2);
    else
        str='N';
    end
end
 close all;
end

