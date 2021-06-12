function [AllPassFeatures]=ImpStatisticalCloseness(RMean,RStd,n1,VMean,VStd,n2)
%StatisticalCloseness(): 
%    Input: Mean and Std of users for registration and verification data  
%    T-test- will measure the similarity of mean and returns P1
%    F-test-will measure the similarity of variance and returns P2
%    Fisher's method combine both P-vaules
%    Return: Final P-vaule measure by T-test, F-test and Finsher's methods

totalUsers=41;
totalFeatures=25;

AllPassFeatures=zeros(totalUsers,totalUsers);
for uID1=1:totalUsers
for uID2=1:totalUsers    
count=0;
for fi=1:totalFeatures

 RIndMean=RMean(uID1,fi);
 RIndStd=RStd(uID1,fi);
 N1=n1(uID1);
 
 %VIndMean=VMean(uID,fi);
 %VIndStd=VStd(uID,fi);
 %N2=n2(uID);
  
 VIndMean=VMean(uID2,fi);
 VIndStd=VStd(uID2,fi);
 N2=n2(uID2);

 if(RIndStd ~=0 ||VIndStd ~=0)
 
 %F-test (call the funcation vartest2U())
 [h3,p3,ci3,stat3]=vartest2U(power(RIndStd,2),N1-1,power(VIndStd,2),N2-1);
 %p3
 
 
 %t-test (all code here)
 %v = N1+N2-2;
 v1=((RIndStd^2)/N1+(VIndStd^2)/N2)^2;
 v2=((((RIndStd^2)/N1)^2)/(N1-1))+((((VIndStd^2)/N2)^2)/(N2-1));
 v=v1/v2;
 tval = (RIndMean-VIndMean) / (sqrt((RIndStd^2)/N1+(VIndStd^2)/N2));       % Calculate T-Statistic

 tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
 tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

 tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
 p4=tprob(1);

 %combine both p-values
 inp1=[p3,p4];
 
 %Fisher's method to combine p-value
 final_p_value2 = fisher_pvalue_meta_analysis(inp1);
 %X=['Pvalue',num2str(fi),':  ',num2str(final_p_value2)];
 %X=[num2str(fi),':  ',num2str(p3),' ',num2str(p4),' ',num2str(final_p_value2)];
 %disp(X);
 %AllPValue(uID,fi)=round(final_p_value2,3);
 if(round(final_p_value2,3)>=0.05)
     count=count+1;
 end
end
end
if(uID1~=uID2)
AllPassFeatures(uID1,uID2)=count;
else
AllPassFeatures(uID1,uID2)=0;
end
end
end
end