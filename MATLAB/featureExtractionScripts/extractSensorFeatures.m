% File Name : extractSensorFeatures.m
% NOTE: TO USE THIS SCRIPT ON YOUR SYSTE, YOU HAVE TO PROVIDE THE PATH
% WHERE MoST DATAFILES ARE STORED. EDIT THIS LINE IN THE BELOW CODE. fileList =
% ReadFileNames('<MoST data files location>'); 
% Description : This file reads all the .txt files in the MoST folder
% structure and then extracts sensor features form eah of the .txt files.
% The .txt files contain the movement data for many types of movements. The
% movement list if given below: 
% 3. Kneeling 
% 4. Step_forward_backward 
% 5. Walking 
% 6. Looking_back_right 
% 7. Grasping_floor 
% 8. Turning_90 
% 9. Grasping_shelf 
% 10. Jumping 
% 11. Step_left_right 
% 12. Eating 
% 13. Drinking 
% 14. Using_phone 
% 15. Sitting(1) 
% 16. Sitting(2) 
% 17. Standing(1) 
% 18. Standing(2) 
% 19. Sit_to_stand 
% 20. Stand_to_sit 
% 21. Sit_to_lie 
% 22. Lie_to_sit 
% 23. Basic_sitting 
% 24. Basic_standing 
% 25. Basic_lying 
% The feature list is given below:
% 1. Averaged variance over 3 axes : calculate variance individually for the three axes (x,y and z) and then take an average of these variance values
% 2. Averaged RMS of signal derivative : calculate rms individually for the three axes (x,y and z) and then take an average of these rms values
% 3. Averaged mean of signal derivative : calculate signal derivative individually for the three axes (x,y and z) and then take an average of these three values
% 4. Averaged Shannon entropy over 3 axes : calculate shannon entropy individually for the three axes (x,y and z) and then take an average of these three values
% 5. Averaged cross-correlation between each 2 axes : calculate cross-correlation between x-y, y-z and x-z and then take an average of these three values
% 6. Averaged signal range (maximum-minimum) over 3 axes : calculate max-min range value individually for the three axes (x,y and z) and then take an average of these three values
% 7. Total signal energy averaged over 3 axes : calculate signal energy individually for the three axes (x,y and z) and then take an average of the three values
% 8. Averaged skewness over 3 axes : calculate skewness of the data individually for the three axes (x,y and z) and then take an average of the three values
% Sensor sampling frequency is 200Hz.
% Features are extracted over a moving time window of 0.5sec with 50%
% overlap.
% Author - Yashaswini
% Date - 26 Aug 2014
% Modified - 
%
clear all;
close all;
% some constants or script tuning parameters
sampling_frequency = 200; % units = Hz
window_size =  0.5 ; % units = sec
% window_overlapping_factor given as a fraction of time window
window_overlapping_factor = 0.5 ; 

featureList = 'AccXVar\tAccYVar\tAccZVar\tGyroXVar\tGyroYVar\tGyroZVar\tAvgAccVar\tAvgGyroVar\trmsSDAccX\trmsSDAccY\trmsSDAccZ\trmsSDGyroX\trmsSDGyroY\trmsSDGyroZ\trmsSDAvgAcc\trmsSDAvgGyro\tmeanSDAccX\tmeanSDAccY\tmeanSDAccZ\tmeanSDGyroX\tmeanSDGyroY\tmeanSDGyroZ\tmeanSDAvgAcc\tmeanSDAvgGyro\t';
featureList = [featureList, 'seAccX\tseAccY\tseAccZ\tseGyroX\tseGyroY\tseGyroZ\tseAvgAcc\tseAvgGyro\t'];
featureList = [featureList, 'ccAccXY\tccAccXYInd\tccAccXZ\tccAccXZInd\tccAccYZ\tccAccYZInd\tccGyroXY\tccGyroXYInd\tccGyroXZ\tccGyroXZInd\tccGyroYZ\tccGyroYZInd\tccAvgAcc\tccAvgAccInd\tccAvgGyro\tccAvgGyroInd\tsigRanAccX\tsigRanAccY\tsigRanAccZ\tsigRanGyroX\tsigRanGyroY\tsigRanGyroZ\tsigRanAvgAcc\tsigRanAvgGyro\t'];
featureList = [featureList, 'energyAccX\tenergyAccY\tenergyAccZ\tenergyGyroX\tenergyGyroY\tenergyGyroZ\tenergyAvgAcc\tenergyAvgGyro\t'];
featureList = [featureList, 'skewAccX\tskewAccY\tskewAccZ\tskewGyroX\tskewGyroY\tskewGyroZ\tskewAvgAcc\tskewAvgGyro\t' ] ;
featureList = [featureList, 'trialNum\tsubjectNum\tmovementNum\tnodeNumber\t'];
% add anymore new feature names before this comment line
featureList = [featureList, '\n']; 

% get the links for all the data files that has raw sensor data from which 
% the features have to be extracted. 
fileList = ReadFileNames('C:\Users\yashaswini\Documents\books\Spring13\NanometerLab\Data_Collection\MoST\yashFork\MoST\Data');

%read data in each file and separate them into 6 files each. Each of these
%new files contain only the AccX, AccY, AccZ, gyroZ, GyroY, GyroZ Values. 
%Each row in the new files contains the sensor modality values for the time
%window considered for extracting the features

for filePointer = 1:length(fileList)
    % create new file pointers for each file in the fileList
    
    % Create the fileNames first
    newFileName = char(fileList(filePointer));
    if ((~strcmp('Features' , newFileName(end-11:end-4))) && ('n' == newFileName(end-6)) && strcmp('txt', newFileName(end-2:end)))
        newFileNameAccX = [newFileName(1:end-4) 'AccX.mat'];
        newFileNameAccY = [newFileName(1:end-4) 'AccY.mat'];
        newFileNameAccZ = [newFileName(1:end-4) 'AccZ.mat'];
        newFileNameGyroX = [newFileName(1:end-4) 'GyroX.mat'];
        newFileNameGyroY = [newFileName(1:end-4) 'GyroY.mat'];
        newFileNameGyroZ = [newFileName(1:end-4) 'GyroZ.mat'];
        newFileNameFeatures = [newFileName(1:end-4) 'Features.txt']; 

        % read the data file from which the deatures have to be generated
        Data = load(char(fileList(filePointer)));
        numRows = length(Data);

        %isnan, find
        % Create the arrays that will store in each row the values for each 
        % time window being considered to extract the features.
        index = 1;
        AccX = [];
        AccY = [];
        AccZ = [];
        GyroX = [];
        GyroY = [];
        GyroZ = [];

        % check if there are enough sample rows equal to the size of the time
        % window. Time window is given by (window_size*sampling_frequency). If
        % there are enough new sample rows, write them into the respective
        % sensor modality array
        timeWindow = window_size*sampling_frequency ; 
        while( (index + timeWindow-1) <= numRows)
            AccX = [AccX ; Data(index:(index+timeWindow - 1),1)']; 
            AccY = [AccY ; Data(index:(index+timeWindow - 1),2)']; 
            AccZ = [AccZ ; Data(index:(index+timeWindow - 1),3)']; 
            GyroX = [GyroX ; Data(index:(index+timeWindow - 1),4)']; 
            GyroY = [GyroY ; Data(index:(index+timeWindow - 1),5)']; 
            GyroZ = [GyroZ ; Data(index:(index+timeWindow - 1),6)']; 
            index = (index + timeWindow) - (window_overlapping_factor * timeWindow) ; 
        end
        % the number of rows in the data may not be an integral multiple of the
        % window size. Hence for the last entry append with NaNs until the
        % windw size is reached.
        endIndex = index +  timeWindow - 1 ; 
        AccX = [AccX ; [Data(index:end,1)' , NaN(1, endIndex-numRows)]] ; 
        AccY = [AccY ; [Data(index:end,2)' , NaN(1, endIndex-numRows)]] ; 
        AccZ = [AccZ ; [Data(index:end,3)' , NaN(1, endIndex-numRows)]] ; 
        GyroX = [GyroX ; [Data(index:end,4)' , NaN(1, endIndex-numRows)]] ; 
        GyroY = [GyroY ; [Data(index:end,5)' , NaN(1, endIndex-numRows)]] ; 
        GyroZ = [GyroZ ; [Data(index:end,6)' , NaN(1, endIndex-numRows)]] ; 
       


        % at this stage all the window arrays are filled. Store these arrays in
        % the files whose names were created earlier. 
%         save (newFileNameAccX,'AccX', '-mat');
%         save (newFileNameAccY,'AccY', '-mat');
%         save (newFileNameAccZ,'AccZ', '-mat');
%         save (newFileNameGyroX,'GyroX', '-mat');
%         save (newFileNameGyroY,'GyroY', '-mat');
%         save (newFileNameGyroZ,'GyroZ', '-mat');

        % now pass these arrays to a function that generates the features and
        % returns a feature vector 
        features = calculateFeatures(AccX, AccY, AccZ, GyroX, GyroY, GyroZ, newFileNameFeatures, sampling_frequency ); 
        writeFeaturesToFile(features, newFileNameFeatures, featureList);


    %     testFeatures = load(newFileNameFeatures,'-mat');
    %     size(testFeatures)
    end
end


% a = 1:100 ;
% Accx = dataset({AccX 'w1','w2','w3'},'obsname',a);
% save (newFileNameAccX,'Accx', '-mat');