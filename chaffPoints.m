function [vault,xl]=chaffPoints(projpoints,poly,DEGREE,numChaffs,field,n1)
%chaffPoints(): 
%    Input: locking set and their evaluation, polynomial, degree of the polynomial
%           number of chaff points, field size and size of input data
%    Randomly generate a chaff points in GF(2^16) and validate it     
%    Validation is based on statistical closenss and the constrain (y !=f(x))
%    Return: A vault with chaff points. A pairs are shuffled


%initialize set of chaff points to zeros
chaffs=gf(zeros(numChaffs,2),field);
XYPoints=gf(zeros(1,2),field);
%generate chaff points
counter=26;
dataa=double(projpoints.x);

maxx=max(dataa(:,1));
minn=min(dataa(:,1));

%rndPoint=gf(randi((2^field-1),10000,2),field);
%allrndPoints=double(rndPoint.x);
%-----------------Uniformity test-------------
%xAxisData = vault.x;
%pd = makedist('uniform');
%test=rescale(allrndPoints);
%[h,p] = kstest(test,'cdf',pd);
%fprintf('%f %f\n ',h,p);
%-----------------End Uniformity test---------

indx=1;
 extraPoint=80;
 allYPoints=allPossibleYPoints(projpoints,field,numChaffs,counter,extraPoint);
 
while true
    %disp(projpoints);
    rnddPoint=gf(randi((2^field-1),1,2),field);
    %verify the constrains for chaff points
    chafff=double(rnddPoint.x);
    
    %chafff=allrndPoints(indx,1);
    %rnddPoint=rndPoint(indx,:);
    %indx=indx+1;
    
    %if(chafff(1,1)>=minn && chafff(1,1)<=maxx)
    
    decision=verifyConstrain(projpoints,poly,DEGREE,field,rnddPoint,n1);
    
    if(decision) 
     %chaffs(counter,:) = rndPoint;
     xPoints=double(rnddPoint.x);
     XYPoints=[gf(xPoints(1,1),field),gf(allYPoints(1,counter),field)];
     %XYPoints(counter-25,:)=[counter,(xPoints(1,1)),(allYPoints(1,counter))];
     %projpoints(counter,:)=rnddPoint;
     projpoints(counter,:)=XYPoints;
     counter=counter+1;
    %end
    
    end
    
    %if (counter==numChaffs+1)
    if (counter==25+numChaffs+1)
        break;
    end
    
    %csvwrite('outputs/XYPoints.csv',XYPoints);
end

  %===Begin Inverse transformation======
  %was range 0-65535 then become 0-1 then convert 0-65535
  %{
  rndPoint1=double(chaffs.x);
  rndPoint3=cdf('Normal',rndPoint1(:,1),mlockingSet,slockingSet);
  rndPoint4=uint16((((rndPoint3-0)*65535)/1)+0);
  chaffs=gf([rndPoint4,rndPoint1(:,2)],field);
  %}
  %===End Inverse transformation======
%show the locking set and chaff points in a graph
counter=26;
lockingSet= projpoints.x;
chaffSet=projpoints.x;
xl=lockingSet(1:counter-1,1);
yl=lockingSet(1:counter-1,2);
xc=chaffSet(counter:counter+numChaffs-1,1);
yc=chaffSet(counter:counter+numChaffs-1,2);

%{
x=[xl,yl];
y=[xc,yc];
tPoints=[x;y]; 
csvwrite('outputs/TouchAllPoints.csv',tPoints);

h1=plot(xl,yl,'o');
set(h1,'markersize',3.5)
hold on;
h1=plot(xc,yc,'o');
set(h1,'markersize',2)
xlim([0,65535]);
ylim([0,65535]);
 %legend('legitimate points')
legend('Legitimate points','Chaff points')
%histfit(xl,10);
%xlim([0,65535]);
xlabel('x-axis');
ylabel('y-axis');
%xlabel('feature points x_i');
%ylabel('Frequency of x_i');
%[fi,xi]=ksdensity(xl);
%figure
%plot(xi,fi);
%plot(h);
%}
%sort points and merge chaffs with points
mtrx=projpoints;
%mtrx=[projpoints; chaffs ];
%vault = gf(mtrx.x,field);
vault = gf(sortrows(mtrx.x),field);
%vault = gf(mtrx.x,field);

end