function writeFeaturesToFile( features, newFileNameFeatures, featureList )
%writeFeaturesToFile : This function writes the features stored in the
% feature array into a file
% features[in] array of features to be written into file. Each row
% represents the window of values that were considered to extract these
% features. 
% newFileNameFeatures[in] file name into which these new features have to be
% written into. 
% featureList[in] A heading string that tells us what feature is written in
% which column

% open the file into which the features have to be written into .
fid = fopen(newFileNameFeatures,'w');
% write the column headers
fprintf(fid, featureList);

nodeNumber = newFileNameFeatures(end-14:end-12);
movementNum = newFileNameFeatures(end-18:end-16);
subjectNum = newFileNameFeatures(end-22:end-20);
trialNum = newFileNameFeatures(end-28:end-24);

dim = size(features);
newString = ''; 
for windowIndex = 1:dim(1)
    newString = [newString, num2str(features(windowIndex,1)) ];
    for featIndex = 2:dim(2)
        newString = [newString '\t' num2str(features(windowIndex,featIndex))]; 
    end
    newString = [newString, '\t',trialNum ];
    newString = [newString, '\t',subjectNum ];
    newString = [newString, '\t',movementNum ];
    newString = [newString, '\t',nodeNumber ];
    newString = [newString '\n'];
    fprintf(fid, newString);
    newString = '';
end
fclose(fid);
end

