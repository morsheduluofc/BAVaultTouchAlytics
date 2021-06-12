function allPvalues=Matching1(vpoints,unlockpoints,n1)
% Matching1()
%     Input: a set of points from vault, unlocking set, and size of input data
%     It will compare the points of unlocking set with the points of vault
%     Return: a matrix of P-values based on distance between unlocking set and vault points 
%

%convert gf data to real data
lockedData=double(vpoints.x);
unlockData1=double(unlockpoints.x);
unlockData=unlockData1';
PValue=zeros(length(lockedData),length(unlockData));
N1=n1;N2=n1;
%disp(lockedData)
%disp(unlockData)
%fprintf('%f %f\n',lockedData(1),unlockData(1));

%-----------------Uniformity test-------------
%xAxisData = vpoints.x;
%pd = makedist('uniform');
%[h,p] = kstest(xAxisData,'cdf',pd);
%fprintf('%f %f\n ',h,p);
%-----------------End Uniformity test---------

indx=1;


for i=1:length(lockedData)
    %seperate the mean and std (var) of locked points
    %lockedData(i)=lockedData(i)+15000;
    lockedMean=round(double(idivide(lockedData(i)+15000,int32(100)))/1000.0,3);
    lockedStd=mod(lockedData(i),100)/1000.0;
    
    %AlllockedMean(i)=lockedMean;
    AlllockedStd(i)=lockedStd;
    
%Compare every locked point with all unlocking points 
for j=1:length(unlockData)
    
    %seperate the mean and std (var) of unlocked points
    %unlockData(j)=unlockData(j)+15000;
    unlockMean=round(double(idivide(unlockData(j)+15000,int32(100)))/1000.0,3);
    unlockStd=mod(unlockData(j),100)/1000.0;
    
    %AllunlockedMean(j)=unlockMean;
    %AllunlockedStd(j)=unlockStd;
   
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
   %AllMPValue(i,j)=p4;
   %AllVPValue(i,j)=p3;
   inp1=[p3,p4];
   final_p_value2 = fisher_pvalue_meta_analysis(inp1);
   %final_p_value2 = p3+p4;
   %{
   if(indx==150)
    fprintf('%f  %f %f \n',lockedData(i),lockedMean,lockedStd);
    fprintf('%f  %f %f \n',unlockData(j),unlockMean,unlockStd);
    fprintf('%f  %f %f \n',final_p_value2,p3,p4);
    end
    indx=indx+1;
    %}
    
   PValue(i,j)=round(final_p_value2,5);
   
   %fprintf('%f\n',PValue(i,j));
   end
 end
end

%AlllockedMean
%AlllockedStd

%AllunlockedMean
%AllunlockedStd

%AllMPValue
%AllVPValue
%PValue

rows=length(PValue(:,1));
cols=length(PValue(1,:));
allPvalues = zeros(rows,rows);
for i=1:rows
    for j=1:rows
        if(j<=cols && PValue(i,j)>0.05)
        allPvalues(i,j)= PValue(i,j);
        else
        allPvalues(i,j)=0;
        end
    end
end

end