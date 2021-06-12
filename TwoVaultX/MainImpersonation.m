
%This program is for BA-Vault and perform the following funcanalities:
%1. RPNorDataMeanVar() read random projected data from files,normalize the data
%   and then calculate the means and variance(Std) of every features 
%2. StatisticalCloseness() measures the statistical closeness of registration 
%   and verification data. It verify that RP and data normalization does
%   not change the closeness of registration and verification data.
%3. MeanStdToFiled() concatinate the mean and variance and moved them to the
%   range [0-65500] and construct locking and unlocking set 
addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/touchalytics/');
%addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/src/');
%addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/sta/');
addpath('/Users/mdmorshedul.islam/OneDrive - University of Calgary/workspace/matlab/BAVault/touchalytics/data/');

%Normalize data and calculate mean and variance
[RMean,RStd,N1,VMean,VStd,N2]=AttackTwoVRPNorDataMeanVar();



%Measure the statistical closeness of registration and verification data
[AllPassFeatures]=ImpStatisticalCloseness(RMean,RStd,N1,RMean,RStd,N1);


%Concatinate and moved mean and variance to the range [0-65500] to
%construct locking and unlocking set 
[lockingSet,unlockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd);


%=================For all Vlid Claim======================

for uID=1:5 %user ID
secret1='MDMORSHEDULISLAMMD'; %secret to hide
%secret2='MDMORSHEDULISLAMMD'; %secret to hide
degree=length(secret1)-1; %degree of the polynomial


%Lock the Vault
NumberOfChaff=300;
%Two vault from same profile
vault1=lockVault(secret1,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
%vault2=lockVault(secret2,unlockingSet(uID,:),NumberOfChaff,N1(1,uID));
%[vault,fp]=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID),mlockingSet(uID),slockingSet(uID));
%allFp(uID,:)=fp';
%disp(lockingSet(uID,:))



%Unlock the vault (both valid and invalid claim)
[mVakye,indx]=max(AllPassFeatures(uID,:));
recoverpoints=ImpunlockVault(vault1,unlockingSet(indx,:),degree,N1(1,indx),indx);
%recoverpoints=unlockVault(vault,unlockingSet(uID,:),degree,N1(1,uID),mlockingSet(uID),slockingSet(uID));

%key2
%lockingSet(1,:)
recoverpoints=sortrows(recoverpoints,-1);
trecoverdPoints=0;
for i=1:25
    for j=1:25
      if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
      end
    end
end
%fprintf('Recovered points: %d \n ',trecoverdPoints);
allrecoveredPoints(uID,1)=mVakye;
allrecoveredPoints(uID,2)=trecoverdPoints;
end
%allrecoveredPoints
csvwrite('rImpersonation.csv',allrecoveredPoints);
%csvwrite('outputs/rPointsForVClaimInv.csv',allrecoveredPoints);
%csvwrite('outputs/featurePoints.csv',allFp);
