function [AllPValue]=StatisticalClosenessAllPossible(RMean,RStd,n1,VMean,VStd,n2)
%StatisticalCloseness(): 
%    Input: Mean and Std of users for registration and verification data  
%    T-test- will measure the similarity of mean and returns P1
%    F-test-will measure the similarity of variance and returns P2
%    Fisher's method combine both P-vaules
%    Return: Final P-vaule measure by T-test, F-test and Finsher's methods


totalUsers=41;
totalFeatures=25;
AllPValue=zeros(totalUsers,totalFeatures);

for uID=1:totalUsers
    indx=1;
 for fi1=1:totalFeatures
     
 RIndMean=RMean(uID,fi1);
 RIndStd=RStd(uID,fi1);
 N1=n1(uID);
 
 for fi2=1:totalFeatures
 
 VIndMean=RMean(uID,fi2);
 VIndStd=RStd(uID,fi2);
 N2=n1(uID);
 
 %VIndMean=VMean(uID,fi2);
 %VIndStd=VStd(uID,fi2);
 %N2=n2(uID);
 %fprintf('%d %d %d\n', fi1,fi2,indx);
 if(fi1~=fi2 &&(RIndStd ~=0 ||VIndStd ~=0))
 
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
 %disp(X);
 %AllPValue(uID,45*(fi1-1)+fi2)=round(final_p_value2,3);
 AllPValue(uID,indx)=round(final_p_value2,3);
 indx=indx+1;
else
 AllPValue(uID,indx)=999;
 indx=indx+1;
end
 end
 end
end
end