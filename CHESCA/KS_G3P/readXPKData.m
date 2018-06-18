function [resn,hcs,ncs]= readXPKData(filename)
delimiter = ' ';
startRow = 7;
endRow = inf;
formatSpec = '%*s%s%f%*s%*s%*s%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
fclose(fileID);

tres = dataArray{:, 1};
hcs = dataArray{:, 2};
ncs = dataArray{:, 3};

resn=[];trim=[];
numi=regexp(tres,['\d']);
for i=1:length(tres)
    tempres=tres{i};
    if (tempres(min(numi{i})-1) ~= 'U')
        resn=vertcat(resn,str2num(tempres(numi{i})));
    else
        trim=vertcat(trim,i);
    end
end

hcs(trim)=[];
ncs(trim)=[];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end