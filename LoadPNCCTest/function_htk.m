addpath './LoadPNCCTrain/'
firstTrainFileData = readhtk('tmpIn');
numberOfFeatureCoefficients = size(firstTrainFileData,2);
fid=fopen('len.txt','w');
fprintf(fid,'%i',numberOfFeatureCoefficients);
fclose(fid);
