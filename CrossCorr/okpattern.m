function [ output ] = okpattern( res )
% Looks for only one peak (ie pattern)
    posp=findpeaks(res);
    negp=findpeaks(-res);
    
    if(isempty(find(res == 0)))
        output = length([posp negp]) <= 1;
    else
        output = false;
    end
end