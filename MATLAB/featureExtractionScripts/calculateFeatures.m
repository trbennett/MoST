function features = calculateFeatures( AccX, AccY, AccZ, GyroX, GyroY, GyroZ, newFileNameFeatures, samplingFrequency )
% This function calculates some variance, entropy and frequency feature
% from the raw Accelerometer and Gyroscope sensor data.
% This file is given as inputs the the vector of accelerometer and
% gyroscope values that have already been processed and separated into
% window vectors over which the features have to be calculated. The
% following features will be calculated 
% 1. Averaged variance over 3 axes : calculate variance individually for the three axes (x,y and z) and then take an average of these variance values
% 2. Averaged RMS of signal derivative : calculate rms individually for the three axes (x,y and z) and then take an average of these rms values
% 3. Averaged mean of signal derivative : calculate signal derivative individually for the three axes (x,y and z) and then take an average of these three values
% 4. Averaged Shannon entropy over 3 axes : calculate shannon entropy individually for the three axes (x,y and z) and then take an average of these three values
% 5. Averaged cross-correlation between each 2 axes : calculate cross-correlation between x-y, y-z and x-z and then take an average of these three values
% 6. Averaged signal range (maximum-minimum) over 3 axes : calculate max-min range value individually for the three axes (x,y and z) and then take an average of these three values
% 7. Averaged main frequency of the FFT over 3 axes : calculate main frequency individually for the three axes (x,y and z) and then take an average of these three values
% 8. Total signal energy averaged over 3 axes : calculate signal energy individually for the three axes (x,y and z) and then take an average of the three values
% 9. energy of 0.2Hz window centered around the main frequency over total FFT energy (3 axis average)
% 10. Averaged skewness over 3 axes : calculate skewness of the data individually for the three axes (x,y and z) and then take an average of the three values

dim = size(AccX) ;
numOfFeatures = 7 ; 

varianceVector = NaN(dim(1), (nargin-2)); 
AvgAccVariance = NaN(dim(1),1); 
AvgGyroVariance = NaN(dim(1), 1); 
approxSignalDerivative = NaN(dim(2)-1, (nargin-2)); 
rmsApproxSignalDerivative = NaN(dim(1), (nargin-2)); 
AvgRMSSigDerAcc = NaN(dim(1), 1); 
AvgRMSSigDerGyro = NaN(dim(1), 1); 
meanApprixSignalderivative = NaN(dim(1), (nargin-2)); 
AvgMeanSigDerAcc = NaN(dim(1), 1); 
AvgMeanSigDerGyro = NaN(dim(1), 1); 
shannonEntropy = NaN(dim(1), (nargin-2)); 
AvgShannonEntropyAcc = NaN(dim(1), 1); 
AvgShannonEntropyGyro = NaN(dim(1), 1); 
crossCorrelationAcc = NaN(dim(1), 6);
crossCorrelationGyro = NaN(dim(1), 6);
AvgCrossCorrelationAcc = NaN(dim(1), 2);
AvgCrossCorrelationGyro = NaN(dim(1), 2);
signalRangeAcc = NaN(dim(1), 3);
signalRangeGyro = NaN(dim(1), 3);
AvgSignalRangeAcc = NaN(dim(1), 1);
AvgSignalRangeGyro = NaN(dim(1), 1);
maxFreqAcc = NaN(dim(1), 3);
maxFreqGyro = NaN(dim(1), 3);
AvgMaxFreqAcc = NaN(dim(1), 1);
AvgMaxFreqGyro = NaN(dim(1), 1);
energyAcc = NaN(dim(1), 3);
energyGyro = NaN(dim(1), 3);
AvgEnergyAcc = NaN(dim(1), 1);
AvgEnergyGyro = NaN(dim(1), 1);
skewAcc = NaN(dim(1), 3);
skewGyro = NaN(dim(1), 3);
AvgSkewAcc = NaN(dim(1), 1);
AvgSkewGyro = NaN(dim(1), 1);

features =  [];
if ((1 < dim(1) )&& (1 < dim(2)))
    for windowIndex = 1:dim(1)
        nanIndex = 0 ; 
        nanFalg = [] ; 
        % calculate what the end index for te last row
        if(windowIndex == dim(1))
            nanFalg = isnan(AccX(windowIndex,:));
            nanIndexArr = find(nanFalg == 1) ;
            if (1 < length(nanIndexArr))
                nanIndex = nanIndexArr(1) - 1; 
            else
                nanIndex = nanIndexArr - 1;
            end
        else
            nanIndex = dim(2);
        end
        windowArray = [AccX(windowIndex,1:nanIndex)' , AccY(windowIndex,1:nanIndex)' , AccZ(windowIndex,1:nanIndex)' , GyroX(windowIndex,1:nanIndex)' , GyroY(windowIndex,1:nanIndex)' , GyroZ(windowIndex,1:nanIndex)' ];


        % calculate variance here
        varianceVector(windowIndex,:) = var(windowArray);

        % calculate the average variance here
        temp = varianceVector(windowIndex,1:3) ;
        AvgAccVariance(windowIndex) = mean(temp,2) ;
        temp = varianceVector(windowIndex,4:6) ;
        AvgGyroVariance(windowIndex) = mean(temp,2) ;
        %8


        % calculate approximate signal derivative here
        approxSignalDerivative = diff(windowArray) * samplingFrequency ;

        % calculate rms of the approx signal derivative here
        rmsApproxSignalDerivative(windowIndex,:) = rms(approxSignalDerivative);

        % calculate the average of RMS of approximate signal derivatives here
        temp = rmsApproxSignalDerivative(windowIndex,1:3) ;
        AvgRMSSigDerAcc(windowIndex) = mean(temp,2) ;
        temp = rmsApproxSignalDerivative(windowIndex,4:6) ;   
        AvgRMSSigDerGyro(windowIndex) = mean(temp,2) ;
        %16
        % calculate the mean of the approximate signal derivatives here for
        % each sensor modality
        meanApprixSignalderivative(windowIndex,:) = mean(approxSignalDerivative);
        % calculate the average of the mean of the approx signal derivatives.
        % These approx signal derivatives are inturn calculated for each sensor
        % modality.
        temp = meanApprixSignalderivative(windowIndex,1:3) ;
        AvgMeanSigDerAcc(windowIndex) = mean(temp,2) ;
        temp = meanApprixSignalderivative(windowIndex,4:6) ;
        AvgMeanSigDerGyro(windowIndex) = mean(temp,2) ;
        %24
        % calculate the shannon entropy on each sensor modality / sensor axis
        for modalityIndex = 1:(nargin-2)
            shannonEntropy(windowIndex,modalityIndex) = entropy(windowArray(:,modalityIndex));
        end

        % calculate the average shannon entropy 
        temp = shannonEntropy(windowIndex,1:3) ;
        AvgShannonEntropyAcc(windowIndex) = mean(temp,2) ;
        temp = shannonEntropy(windowIndex,4:6) ;
        AvgShannonEntropyGyro(windowIndex) = mean(temp,2) ;
        %32
        % calculate cross correlation between AccX-AccY, AccX-AccZ, AccY-AccZ,
        % GyroX-GyroY, GyroX-GyroZ, GyroY-GyroZ
        ArNCCAccXY = newCrossCorr(windowArray(:,1), windowArray(:,2)) ;
        ArNCCAccXZ = newCrossCorr(windowArray(:,1), windowArray(:,3)) ;
        ArNCCAccYZ = newCrossCorr(windowArray(:,2), windowArray(:,3)) ;
        ArNCCGyroXY = newCrossCorr(windowArray(:,4), windowArray(:,5)) ;
        ArNCCGyroXZ = newCrossCorr(windowArray(:,4), windowArray(:,6)) ;
        ArNCCGyroYZ = newCrossCorr(windowArray(:,5), windowArray(:,6)) ;
        % extract the maximum cross correlation value obtained and its index
        % for every sensor modality
        tmp = find( ArNCCAccXY == max(ArNCCAccXY));
        if (1 < length(tmp) )
          NCCAccXY = [max(ArNCCAccXY), tmp(1)] ; 
        else
           NCCAccXY = [max(ArNCCAccXY), tmp] ; 
        end
        tmp = find( ArNCCAccXZ == max(ArNCCAccXZ));
        if (1 < length(tmp) )
            NCCAccXZ = [max(ArNCCAccXZ), tmp(1)] ; 
        else
            NCCAccXZ = [max(ArNCCAccXZ), tmp] ; 
        end
        tmp = find( ArNCCAccYZ == max(ArNCCAccYZ));
        if (1 < length(tmp) )
            NCCAccYZ = [max(ArNCCAccYZ), tmp(1)] ; 
        else
            NCCAccYZ = [max(ArNCCAccYZ), tmp] ; 
        end
        tmp = find( ArNCCGyroXY == max(ArNCCGyroXY));
        if (1 < length(tmp) )
            NCCGyroXY = [max(ArNCCGyroXY), tmp(1)] ; 
        else
            NCCGyroXY = [max(ArNCCGyroXY), tmp] ; 
        end
        tmp = find( ArNCCGyroXZ == max(ArNCCGyroXZ));
        if (1 < length(tmp) )
            NCCGyroXZ = [max(ArNCCGyroXZ),tmp(1) ] ; 
        else
            NCCGyroXZ = [max(ArNCCGyroXZ),tmp ] ; 
        end
        tmp = find( ArNCCGyroYZ == max(ArNCCGyroYZ));
        if (1 < length(tmp) )
            NCCGyroYZ = [max(ArNCCGyroYZ), tmp(1) ] ; 
        else
            NCCGyroYZ = [max(ArNCCGyroYZ), tmp ] ; 
        end

        % store the mean of the cross correlation value for each type of sensor 
        % and the mean of the indexes too
        crossCorrelationAcc(windowIndex,:) = [NCCAccXY, NCCAccXZ, NCCAccYZ];
        crossCorrelationGyro(windowIndex,:) = [NCCGyroXY, NCCGyroXZ, NCCGyroYZ];
        AvgCrossCorrelationAcc(windowIndex,:) = [mean(crossCorrelationAcc(windowIndex,[1,3,5])) , mean(crossCorrelationAcc(windowIndex,[2,4,6]))]; 
        AvgCrossCorrelationGyro(windowIndex,:) = [mean(crossCorrelationGyro(windowIndex,[1,3,5])) , mean(crossCorrelationGyro(windowIndex,[2,4,6]))];
        %48
        % calculate the signal range ( maximum-minimum ) for each sensor
        % modality
        rangeAccX = max(windowArray(:,1)) - min(windowArray(:,1));
        rangeAccY = max(windowArray(:,2)) - min(windowArray(:,2));
        rangeAccZ = max(windowArray(:,3)) - min(windowArray(:,3));
        rangeGyroX = max(windowArray(:,4)) - min(windowArray(:,4));
        rangeGyroY = max(windowArray(:,5)) - min(windowArray(:,5));
        rangeGyroZ = max(windowArray(:,6)) - min(windowArray(:,6));
        signalRangeAcc(windowIndex,:) = [rangeAccX, rangeAccY, rangeAccZ];
        signalRangeGyro(windowIndex,:) = [rangeAccX, rangeAccY, rangeAccZ];
        % calculate the average of the signal range for each type of sensor
        AvgSignalRangeAcc(windowIndex) = mean(signalRangeAcc(windowIndex,:));
        AvgSignalRangeGyro(windowIndex) = mean(signalRangeGyro(windowIndex,:));
        %56
        % NOTE!! FOR THE WINDOW SIZE CHOSEN (0.5 SEC AND SAMPLNG FREQUENCY OF 
        % 200HZ ), FREQUENCY DOMAIN FEATURES CANNOT BE EXTRACTED SINCE THEY 
        % WILL NOT BE CORRECT. 
        % calculate the max frequency of fft over each sensor modality
    %     MFAccX = fftMaxFreq(windowArray(:,1), samplingFrequency);
    %     MFAccY = fftMaxFreq(windowArray(:,2), samplingFrequency);
    %     MFAccZ = fftMaxFreq(windowArray(:,3), samplingFrequency);
    %     MFGyroX = fftMaxFreq(windowArray(:,4), samplingFrequency);
    %     MFGyroY = fftMaxFreq(windowArray(:,5), samplingFrequency);
    %     MFGyroZ = fftMaxFreq(windowArray(:,6), samplingFrequency);
    %     maxFreqAcc(windowIndex,:) = [MFAccX, MFAccY, MFAccZ];
    %     maxFreqGyro(windowIndex,:) = [MFGyroX, MFGyroY, MFGyroZ];
        % calculate the average of the max freq of fft over the three axes of
        % each sensor type
    %     AvgMaxFreqAcc(windowIndex) = mean(maxFreqAcc(windowIndex,:));
    %     AvgMaxFreqGyro(windowIndex) = mean(maxFreqGyro(windowIndex,:));

        % calculate the energy for each sensor modality
        energyAccX = energyFeature(windowArray(:,1));
        energyAccY = energyFeature(windowArray(:,2));
        energyAccZ = energyFeature(windowArray(:,3));
        energyGyroX = energyFeature(windowArray(:,4));
        energyGyroY = energyFeature(windowArray(:,5));
        energyGyroZ = energyFeature(windowArray(:,6));
        energyAcc(windowIndex,:) = [energyAccX, energyAccY, energyAccZ];
        energyGyro(windowIndex,:) = [energyGyroX, energyGyroY, energyGyroZ];
        % calculate average of energy for each type of sensor
        AvgEnergyAcc(windowIndex) = mean(energyAcc(windowIndex,:));
        AvgEnergyGyro(windowIndex) = mean(energyGyro(windowIndex,:));
        %64
        % calculate skewness for each sensor modality 
        skewAccX = skewness(windowArray(:,1));
        skewAccY = skewness(windowArray(:,2));
        skewAccZ = skewness(windowArray(:,3));
        skewGyroX = skewness(windowArray(:,4));
        skewGyroY = skewness(windowArray(:,5));
        skewGyroZ = skewness(windowArray(:,6));
        skewAcc(windowIndex,:) = [skewAccX, skewAccY, skewAccZ];
        skewGyro(windowIndex,:) = [skewGyroX, skewGyroY, skewGyroZ];
        % calculate average of skewness for each sensor type
        AvgSkewAcc(windowIndex) = mean(skewAcc(windowIndex,:));
        AvgSkewGyro(windowIndex) = mean(skewGyro(windowIndex,:));
        % 72
    end
    features = [varianceVector, AvgAccVariance, AvgGyroVariance, rmsApproxSignalDerivative, AvgRMSSigDerAcc, AvgRMSSigDerGyro, meanApprixSignalderivative, AvgMeanSigDerAcc, AvgMeanSigDerGyro, shannonEntropy, AvgShannonEntropyAcc, AvgShannonEntropyGyro,crossCorrelationAcc, crossCorrelationGyro, AvgCrossCorrelationAcc, AvgCrossCorrelationGyro, signalRangeAcc, signalRangeGyro, AvgSignalRangeAcc, AvgSignalRangeGyro];
    % features = [features, maxFreqAcc, maxFreqGyro, AvgMaxFreqAcc, AvgMaxFreqGyro];
    features = [features, energyAcc, energyGyro, AvgEnergyAcc, AvgEnergyGyro];
    features = [features, skewAcc, skewGyro, AvgSkewAcc, AvgSkewGyro];
    % save(newFileNameFeatures, 'features','-mat')
end

end

