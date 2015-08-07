
%This script remove all duplicate packets for all data files in the same
%folder

% Create set of all data files in folder
allFiles = dir('*.txt' );
allNames = { allFiles.name };

mkdir('processDuplicateAndResample');
% Loop over every data files in folder
for i=1:numel(allNames)
    filename=allNames{i}
    %Import data delimited by tab with 1 header line
    Data=importdata(filename, '\t', 1);
    %Remove the last line in the data
    Data = Data.data(1:length(Data.data)-1,:);
    %Check for and remove lines with empty data points
    test = isnan(Data);
    for k=1:length(Data)
        for j = 1:13
            if(test(i,j) == 1)
                Data = [Data(1:k-1,:); Data(1:k+1,:)];
            end
        end
    end
    % Get list of unique row for Data matrix
    [~,li]=unique(Data(:,11),'first');
    tmp_unique = Data(li,:);
    
    %process resample
    %get upper time for resample
    upper_time=tmp_unique(end,11);
    %number of possible packet
    packets =floor(upper_time/5);
    %create Time Series object upon tmp_unique and Time Stamp
    ts = timeseries(tmp_unique,tmp_unique(:,11));
    time=[0:5:packets*5];
    %resample process
    res_ts=resample(ts,time);
    %data set return from sample
    tem=res_ts.data;
    % cast into integer value since it returns double
    temp=int32(tem); 
    %Create new packet  number to copy over
    packetNum=[0:1:packets];
    %Update new time for column 11
    temp(:,11)=time;
    %Update packet number for every column
    temp(:,10)= packetNum;
    temp(:,12)= packetNum;
    %Write to File
    myfile =fopen(strcat('processDuplicateAndResample/',filename) ,'w');
    for i=1:size(temp,1)
        fprintf(myfile,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\r\n',temp(i,:));
    end
    fclose(myfile);

end

