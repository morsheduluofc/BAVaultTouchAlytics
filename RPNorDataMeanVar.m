function [RMean,RStd,N1,VMean,VStd,N2]=RPNorDataMeanVar()
%DataRPSP(): 
%    Read random projected registation and verification data  
%    Normalize the data and move them in between 0-1
%    Calculate the means and variance(Std) of every features 
%    Return: both mean and variance of registation and verification data


%read random projected registration and verification data
rRPData=readtable('data/randomRegDataRP.csv');
%rRPData=readtable('data/randomRegDataRP.csv');

vRPData= readtable('data/randomVerDataRP.csv');
%vRPData= readtable('data/randomVerDataRP.csv');

dataIndx=csvread('data/allUserIndxRP.csv');

totalUsers=41;
totalFeatures=25;
%for i=2:42
%fprintf('%d %d \n',i-1,(dataIndx(1,i)-dataIndx(1,i-1))/2);
%end

%calculate min and max valur of every features
minValue=zeros(totalFeatures);
maxValue=zeros(totalFeatures);
for j=3:totalFeatures+2
    minValue(j-2)=min(table2array(rRPData(:,j)));
    maxValue(j-2)=max(table2array(rRPData(:,j)));
end

%normalized the data
%rRPNormData=zeros(length(rRPData),totalFeatures+1);
%vRPNormData=zeros(length(vRPData),totalFeatures+1);
for j=3:totalFeatures+2
    rRPNormData(:,j)=(table2array(rRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
    vRPNormData(:,j)=(table2array(vRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
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
trDatat= rRPNormData(stIndx:endIndx,3:totalFeatures+2);
tvDatat= vRPNormData(stIndx:endIndx,3:totalFeatures+2);

for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

RMean(uID,fi) =round(mean(data1),3); 
RStd(uID,fi)=round(std(data1),3);
%RMeanRP(uID,fi) =round(mean(data1),3); 
%RStdRP(uID,fi)=round(std(data1),3);

VMean(uID,fi)=round(mean(data2),3);
VStd(uID,fi)=round(std(data2),3);
end
end

%{
AllData1=[RMean;RStd];

%read random projected registration and verification data
%rRPData=readtable('data/randomRegDataRemv.csv');
rRPData=readtable('data/randomRegDataRemv.csv');

%vRPData= readtable('data/randomVerDataRemv.csv');
vRPData= readtable('data/randomVerDataRemv.csv');

dataIndx=csvread('data/allUserIndxRP.csv');

totalUsers=41;
totalFeatures=30;
%for i=2:42
%fprintf('%d %d \n',i-1,(dataIndx(1,i)-dataIndx(1,i-1))/2);
%end

%calculate min and max valur of every features
minValue=zeros(totalFeatures);
maxValue=zeros(totalFeatures);
for j=3:totalFeatures+2
    minValue(j-2)=min(table2array(rRPData(:,j)));
    maxValue(j-2)=max(table2array(rRPData(:,j)));
end

%normalized the data
%rRPNormData=zeros(length(rRPData),totalFeatures+1);
%vRPNormData=zeros(length(vRPData),totalFeatures+1);
for j=3:totalFeatures+2
    rRPNormData(:,j)=(table2array(rRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
    vRPNormData(:,j)=(table2array(vRPData(:,j))-minValue(j-2))/(maxValue(j-2)-minValue(j-2));
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
trDatat= rRPNormData(stIndx:endIndx,3:totalFeatures+2);
tvDatat= vRPNormData(stIndx:endIndx,3:totalFeatures+2);

for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

%RMean(uID,fi) =round(mean(data1),3); 
%RStd(uID,fi)=round(std(data1),3);
RMeanNR(uID,fi) =round(mean(data1),3); 
RStdNR(uID,fi)=round(std(data1),3);

VMean(uID,fi)=round(mean(data2),3);
VStd(uID,fi)=round(std(data2),3);
end
end
AllData2=[RMeanNR;RStdNR];
%csvwrite('outputs/SrPointsForInvClaimv.csv',AllData)
%}
%fprintf('RMean Max:%f, RMean Min:%f, RStd Max:%f, RStd Min:%f.\n',max(max(RMean)),min(min(RMean)),max(max(RStd)),min(min(RStd)));
%fprintf('VMean Max:%f, VMean Min:%f, VStd Max:%f, VStd Min:%f.\n',max(max(VMean)),min(min(VMean)),max(max(VStd)),min(min(VStd)));
%for u=1:12
%}
%{
%AllData=readtable('outputs/allMStdDataBeforeRPAfterRP.csv');
%Choose 10
u=10;
m=AllData2(u,:);
v=AllData2(u+41,:);
mRP=AllData1(u,:);
vRP=AllData1(u+41,:);
subplot(1,2,1)
plot(m,v,'o');
xlabel('Mean');
ylabel('Std');
subplot(1,2,2)
plot(mRP,vRP,'o');
%xlim([0,1]);
%ylim([0,1]);
xlabel('Mean');
ylabel('Std');
hold on;
%end
%}
%}
%{
%Normality test
%read random projected registration and verification data
rRPData=readtable('data/SrandomRegDataRP.csv');
%rRPData=readtable('data/randomRegDataRP.csv');

vRPData= readtable('data/SrandomVerDataRP.csv');
%vRPData= readtable('data/randomVerDataRP.csv');

dataIndx=csvread('data/allUserIndxRP.csv');

totalUsers=1;
totalFeatures=25;

for uID=1:totalUsers
stIndx= dataIndx(1,uID)/2+1; 
endIndx=dataIndx(1,uID+1)/2;
    
%seperate a user's data
trDatat= rRPData(stIndx:endIndx,3:totalFeatures+2);
tvDatat= vRPData(stIndx:endIndx,3:totalFeatures+2);
for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[h,p]=chi2gof(table2array(data1))
end
end
%}
end

