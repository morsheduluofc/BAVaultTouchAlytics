function [RMean,RStd,N1,VMean,VStd,N2]=AttackTwoVRPNorDataMeanVar()
%DataRPSP(): 
%    Read random projected registation and verification data  
%    Normalize the data and move them in between 0-1
%    Calculate the means and variance(Std) of every features 
%    Return: both mean and variance of registation and verification data

addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/touchalytics/');
%addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/src/');
%addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/sta/');
addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/touchalytics/data/');


%read random projected registration and verification data
rRPData=readtable('SrandomRegDataRPv1.csv');
vRPData= readtable('SrandomRegDataRPv1.csv');
%vRPData= readtable('data/randomVerDataRP2.csv');
dataIndx=csvread('allUserIndxRP.csv');

totalUsers=41;
totalFeatures=25;

%calculate min and max valur of every features
minValue=zeros(totalFeatures);
maxValue=zeros(totalFeatures);
for j=2:totalFeatures+1
    minValue(j-1)=min(table2array(rRPData(:,j)));
    maxValue(j-1)=max(table2array(rRPData(:,j)));
end

%normalized the data
%rRPNormData=zeros(length(rRPData),totalFeatures+1);
%vRPNormData=zeros(length(vRPData),totalFeatures+1);
for j=2:totalFeatures+1
    rRPNormData(:,j)=(table2array(rRPData(:,j))-minValue(j-1))/(maxValue(j-1)-minValue(j-1));
    vRPNormData(:,j)=(table2array(vRPData(:,j))-minValue(j-1))/(maxValue(j-1)-minValue(j-1));
end

%round the normalized data till three decimal place
rRPNormData(:,j)=round(rRPNormData(:,j),3);
vRPNormData(:,j)=round(vRPNormData(:,j),3);


%calculate the mean and std of every feature
N1=zeros(1,totalUsers);
N2=zeros(1,totalUsers);
RMean=zeros(totalUsers,totalFeatures);
VMean=zeros(totalUsers,totalFeatures);
RStd=zeros(totalUsers,totalFeatures);
VStd=zeros(totalUsers,totalFeatures);

for uID=1:totalUsers
stIndx= dataIndx(1,uID)/2+1; 
endIndx=dataIndx(1,uID+1)/2;

%seperate a user's data
trDatat= rRPNormData(stIndx:endIndx,2:totalFeatures+1);
tvDatat= vRPNormData(stIndx:endIndx,2:totalFeatures+1);

for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

RMean(uID,fi) =round(mean(data1),3); 
RStd(uID,fi)=round(std(data1),3);

VMean(uID,fi)=round(mean(data2),3);
VStd(uID,fi)=round(std(data2),3);
end
end

%fprintf('RMean Max:%f, RMean Min:%f, RStd Max:%f, RStd Min:%f.\n',max(max(RMean)),min(min(RMean)),max(max(RStd)),min(min(RStd)));
%fprintf('VMean Max:%f, VMean Min:%f, VStd Max:%f, VStd Min:%f.\n',max(max(VMean)),min(min(VMean)),max(max(VStd)),min(min(VStd)));
%for u=1:12
%{
u=27;
v=RStd(u,:);
m=RMean(u,:);
plot(m,v,'o');
%xlim([0,1]);
%ylim([0,1]);
xlabel('Mean');
ylabel('Std');
hold on;
%end
%}
end

