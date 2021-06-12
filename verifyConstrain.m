function decision=verifyConstrain(projpoints,poly,DEGREE,FIELD,rndPoint,n1)
%verifyConstrain(): 
%    Input: locking set and their evaluation point, polynomial
%     degree of the polynomial, random chaff points and size of input data
%      
%    
%    Return: A true/false decision

%initial decision true for chaff points
decision=true;

%convert gf data to real data (both locking set and chaff points)
ldata=double(projpoints.x);
chaff=double(rndPoint.x); %a pair of points

%disp(chaff);
%seperate the chaff point Field data to mean and std (variance)
N1=n1;N2=n1;


%chaff(1,1)=chaff(1,1)+15000;
ChaffMean=round(double(idivide(chaff(1,1),int32(100)))/1000.0,3);
ChaffStd=mod(chaff(1,1),100)/1000.0;


 %compare the chaff point with the points of locking set
for i=1:length(ldata) 
    
   %seperate the locking point Field data to mean and std (variance)
   %ldata(i,1)=ldata(i,1)+15000;
   LockMean=round(double(idivide(ldata(i,1),int32(100)))/1000.0,3);
   LockStd=mod(ldata(i,1),100)/1000.0;
    
   
   %statistically closeness measurement
   if(LockStd ~=0 ||ChaffStd ~=0)
   %%F-test
   [h3,p3,ci3,stat3]=vartest2U(power(LockStd,2),N1-1,power(ChaffStd,2),N2-1);
   %p3
   
   %T-test
   %v = N1+N2-2;
   v1=((LockStd^2)/N1+(ChaffStd^2)/N2)^2;
   v2=((((LockStd^2)/N1)^2)/(N1-1))+((((ChaffStd^2)/N2)^2)/(N2-1));
   v=v1/v2;
   tval = (LockMean-ChaffMean) / (sqrt((LockStd^2)/N1+(ChaffStd^2)/N2));       % Calculate T-Statistic

   tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
   tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

   tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
   p4=tprob(1);

   
   %Fisher's method to combine p-value
   inp1=[p3,p4];
   final_p_value2 = fisher_pvalue_meta_analysis(inp1);
   
   PValue=round(final_p_value2,3);
   
   %if P-value grater than 0.05 then decision is false
   if(PValue>0.05)
    decision=false;
    break;
   end 
   end
end
   
   % if not close check whether the evaluation point of chaff point 
   % is on the polynomial or not
   if (decision==true)
   N=DEGREE+1;
   ChaffEvaValue = gf(zeros(1,1),FIELD);
   ChaffIniEvaValue=gf(ones(1,N),FIELD);
   
   %For chaff points calculate [1,X_1,X_1^2,....,X_1^k]
   for j=2:N
   ChaffIniEvaValue(1,j)=ChaffIniEvaValue(1,j-1)*rndPoint(1); 
   end 
   
   %For chaff point calculat f(x)=m_0+m_1*X+m_2*X^2+...+m_k*X^k
   for j=1:N
     ChaffEvaValue(1)=ChaffEvaValue(1)+poly(j)*ChaffIniEvaValue(1,j); 
   end
   
   %Check whether chaff evaluation is equal to second value of chaff pair 
   if(ChaffEvaValue(1)==rndPoint(1,2))
    decision=false;   
   end
   end
   

end