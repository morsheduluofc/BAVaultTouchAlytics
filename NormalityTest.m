%function [AllPalueR,AllPalueV]=NormalityTest()

%DataRPSP(): 
%    Read random projected registation and verification data  
%    Normalize the data and move them in between 0-1
%    Calculate the means and variance(Std) of every features 
%    Return: both mean and variance of registation and verification data

addpath('../src/');
addpath('../sta/');
addpath('../data/');

%read registration and verification data
rRPData=readtable('data/SrandomRegDataRP.csv');
vRPData= readtable('data/SrandomVerDataRP.csv');

%read random projected registration and verification data
%rRPData=readtable('data/randomRegDataRP.csv');
%vRPData= readtable('data/randomVerDataRP.csv');

dataIndx=csvread('data/allUserIndxRP.csv');

totalUsers=41;
totalFeatures=25;
%calculate min and max valur of every features
minValue=zeros(totalFeatures);
maxValue=zeros(totalFeatures);

for j=3:totalFeatures+2
    minValue(j-2)=min(table2array(rRPData(:,j)));
    maxValue(j-2)=max(table2array(rRPData(:,j)));
end

%normalized the data
[Nr Mr]=size(rRPData);
[Nv Mv]=size(rRPData);

rRPNormData=zeros(Nr,totalFeatures);
vRPNormData=zeros(Nv,totalFeatures);
for j=3:totalFeatures+2
    rRPNormData(:,j-2)=(table2array(rRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
    vRPNormData(:,j-2)=(table2array(vRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
end


    
for uID=1:totalUsers
stIndx= dataIndx(1,uID)/2+1; 
endIndx=dataIndx(1,uID+1)/2;

%seperate a user's data
trDatat= rRPNormData(stIndx:endIndx,1:totalFeatures);
tvDatat= vRPNormData(stIndx:endIndx,1:totalFeatures);

%trDatat= table2array(rRPData(stIndx:endIndx,2:totalFeatures+1));
%tvDatat= table2array(vRPData(stIndx:endIndx,2:totalFeatures+1));

for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

%[hR,pR]=kstest(data1);
%[hV,pV]=kstest(data2);

[hR,pR]=chi2gof(data1);
[hV,pV]=chi2gof(data2);

AllPalueR(uID,fi)=hR;
AllPalueV(uID,fi)=hV;

end
end
count=0;
for i=1:totalUsers
    for fi=1:totalFeatures
     if(AllPalueR(i,fi)==0)
     count=count+1;
    end 
    end
end
count/(totalUsers*totalFeatures)
%fprintf('RMean Max:%f, RMean Min:%f, RStd Max:%f, RStd Min:%f.\n',max(max(RMean)),min(min(RMean)),max(max(RStd)),min(min(RStd)));
%fprintf('VMean Max:%f, VMean Min:%f, VStd Max:%f, VStd Min:%f.\n',max(max(VMean)),min(min(VMean)),max(max(VStd)),min(min(VStd)));
%end