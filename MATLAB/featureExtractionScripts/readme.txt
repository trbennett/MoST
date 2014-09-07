Author : Yashaswini Prathivadi
Date: 5 septembet 2014

In order to extract featuresm run the matlab script extractSensorFeatures.m.
In this script, change only the location to the folder containing all the files from where the features have to be extracted.
The line to change is:
fileList = ReadFileNames('C:\Users\yashaswini\Documents\books\Spring13\NanometerLab\Data_Collection\MoST\yashFork\MoST\Data');

this line should be changed to 
fileList = ReadFileNames('<path to file where MoST is cloned>\MoST\Data');

