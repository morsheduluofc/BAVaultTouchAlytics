function allPvalues=MatchingMeanVar(RMean,RStd,N11,VMean,VStd,N22)
% Matching1()
%     Input: a set of points from vault, unlocking set, and size of input data
%     It will compare the points of unlocking set with the points of vault
%     Return: a matrix of P-values based on distance between unlocking set and vault points 
%


[m,n]=size(RMean);
indx=1;
PValue=zeros(m,n);
for i=1:m  
    temp=0;
%Compare every locked point with all unlocking points 
for j=1:n
    
    %seperate the mean and std (var) of unlocked points
    %unlockData(j)=unlockData(j)+15000;
    lockedMean=RMean(i,j);
    lockedStd=RStd(i,j);
    unlockMean=VMean(i,j);
    unlockStd=VStd(i,j);
    N1=N11(1,i);
    N2=N22(1,i);
    
   if( lockedStd ~=0 || unlockStd ~=0)
   %%F-test
   [h3,p3,ci3,stat3]=vartest2U(power( lockedStd,2),N1-1,power( unlockStd,2),N2-1);
   %p3
   
   %T-test
   %v = N1+N2-2;
   v1=(( lockedStd^2)/N1+( unlockStd^2)/N2)^2;
   v2=(((( lockedStd^2)/N1)^2)/(N1-1))+(((( unlockStd^2)/N2)^2)/(N2-1));
   v=v1/v2;
   tval = ( lockedMean- unlockMean) / (sqrt(( lockedStd^2)/N1+( unlockStd^2)/N2));       % Calculate T-Statistic

   tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
   tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

   tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
   p4=tprob(1);

   %Fisher's method to combine p-value
   inp1=[p3,p4];
   final_p_value2 = fisher_pvalue_meta_analysis(inp1);
   
   %{
   if(indx==150)
    fprintf('%f  %f %f \n',lockedData(i),lockedMean,lockedStd);
    fprintf('%f  %f %f \n',unlockData(j),unlockMean,unlockStd);
    fprintf('%f  %f %f \n',final_p_value2,p3,p4);
    end
    indx=indx+1;
    %}
    
   PValue(i,j)=final_p_value2;
   %fprintf('%f\n',PValue(i,j));
   end
   temp= temp+ PValue(i,j);
end
 %FPValue(i)=temp;
 FPValue(i)=fisher_pvalue_meta_analysis(PValue(i,:));
end
csvwrite('outputs/allValidClaimRemv.csv',FPValue);

for i=1:m  
    temp=0;
%Compare every locked point with all unlocking points 
for j=1:n
    
    invID = round((195-1).*rand(1,1) + 1); 
    while(i==invID)
    invID = round((195-1).*rand(1,1) + 1); 
    end  
    %seperate the mean and std (var) of unlocked points
    %unlockData(j)=unlockData(j)+15000;
    lockedMean=RMean(i,j);
    lockedStd=RStd(i,j);
    unlockMean=VMean(invID,j);
    unlockStd=VStd(invID,j);
    N1=N11(1,i);
    N2=N22(1,invID);
    
   if( lockedStd ~=0 || unlockStd ~=0)
   %%F-test
   [h3,p3,ci3,stat3]=vartest2U(power( lockedStd,2),N1-1,power( unlockStd,2),N2-1);
   %p3
   
   %T-test
   %v = N1+N2-2;
   v1=(( lockedStd^2)/N1+( unlockStd^2)/N2)^2;
   v2=(((( lockedStd^2)/N1)^2)/(N1-1))+(((( unlockStd^2)/N2)^2)/(N2-1));
   v=v1/v2;
   tval = ( lockedMean- unlockMean) / (sqrt(( lockedStd^2)/N1+( unlockStd^2)/N2));       % Calculate T-Statistic

   tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
   tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

   tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
   p4=tprob(1);

   %Fisher's method to combine p-value
   inp1=[p3,p4];
   final_p_value2 = fisher_pvalue_meta_analysis(inp1);
   
   %{
   if(indx==150)
    fprintf('%f  %f %f \n',lockedData(i),lockedMean,lockedStd);
    fprintf('%f  %f %f \n',unlockData(j),unlockMean,unlockStd);
    fprintf('%f  %f %f \n',final_p_value2,p3,p4);
    end
    indx=indx+1;
    %}
    
   PValue(i,j)=final_p_value2;
   %fprintf('%f\n',PValue(i,j));
   end
    temp= temp+ PValue(i,j);
end
 %FPValue(i)=temp;
 FPValue(i)=fisher_pvalue_meta_analysis(PValue(i,:));
end
csvwrite('outputs/allInValidClaimRemv.csv',FPValue);

end
