function [lockingSet,unlockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd)
%MeanStdToFiled(): 
%    Input: Mean and Std of users for registration and verification data  
%    Concatinate the mean and variance and moved them to [0-65500]  
%    Return: Locking and unlocking sets for the vaults 

totalUsers=41;
totalFeatures=25;

RMean=round(RMean,3);
VMean=round(VMean,3);
RStd=RStd*1000;
VStd=VStd*1000;
RStd=mod(RStd,100)/1000.0;
VStd=mod(VStd,100)/1000.0;

%move all data three decimal place left (example: 0.876 -> 876.0)
RMean=RMean*1000;
RStd=RStd*1000;
VMean=VMean*1000;
VStd=VStd*1000;

%concatinate mean and std (example: (876.0. 75.0) -> 87600+75 -> 876175)
%lockingSet=100*RMean+RStd;
%unlockingSet=100*VMean+VStd;
for i=1:totalUsers
for j=1:totalFeatures
%if(RStd(i,j)<100)
 %lockingSet(i,j)=100*RMean(i,j)+RStd(i,j);
%else
 lockingSet(i,j)=100*RMean(i,j)+mod(RStd(i,j),100);
%end
%if (VStd(i,j)<100)
%unlockingSet(i,j)=100*VMean(i,j)+VStd(i,j);
%else
unlockingSet(i,j)=100*VMean(i,j)+mod(VStd(i,j),100);
%end
 end
end


%Special Note:
%To fit all data in the range (85500 -15000=65500), we alter some outliner data
%data lower than 15000 moved to 15000
%data higher than 80500 moved to 85500
%For locking set the percentage of moved data is (25/8775)*100=0.28%
%For unlocking set the percentage of moved data is (29/8775)*100=
%count = sum(lockingSet(:)>=15000 & lockingSet(:)<=80500)=0.33\%
%count = sum(unlockingSet(:)>=15000 & unlockingSet(:)<=80500)
count=0;
for uID=1:totalUsers
 for j=1:totalFeatures
     if(lockingSet(uID,j)<15000)
         lockingSet(uID,j)=15000;
         count=count+1;
     end
     if(unlockingSet(uID,j)<15000)
         unlockingSet(uID,j)=15000;
         count=count+1;
     end
     
     if(lockingSet(uID,j)>80500)
         lockingSet(uID,j)=80500;
         count=count+1;
     end
     if(unlockingSet(uID,j)>80500)
         unlockingSet(uID,j)=80500;
         count=count+1;
     end
end
end
%percentage=count/(2*195*42)
%moved the range from [15000,85500] to [0-65500]
for uID=1:totalUsers
 for j=1:totalFeatures
     lockingSet(uID,j)=lockingSet(uID,j)-15000;
     unlockingSet(uID,j)=unlockingSet(uID,j)-15000;
end
end
%{
   %l1=lockingSet(3,:);
% Inverse transformation sampling
for uID=1:totalUsers
    %=========Begin Inverse Transformation====
     %was range 0-65535 then become 0-1 then convert 0-65535 
     MlockingSet(uID)=mean(lockingSet(uID,:));
     StdlockingSet(uID)=std(lockingSet(uID,:));
     
     lockingSet(uID,:)=cdf('Normal',lockingSet(uID,:),MlockingSet(uID),StdlockingSet(uID));
     lockingSet(uID,:)=uint16(((lockingSet(uID,:)-0)*65535)/1)+0;
     %unlockingSet(uID,:)=cdf('Normal',unlockingSet(uID,:),mean(unlockingSet(uID,:)),std(unlockingSet(uID,:)));
     %unlockingSet(uID,:)=uint16(((unlockingSet(uID,:)-0)*65534)/1)+1;
     %lockingSet(uID,:);
    
     %=========End Inverse Transformation====
     
end
%}   
    %Test the legitimate points and its inverse sampling
    %l2=lockingSet(3,:);
    %l3=(((lockingSet(3,:)-1)*1)/65535)+0;
    %l4=norminv(l3,MlockingSet(3),StdlockingSet(3));
    %[l1;l2;l3;l4]
end
