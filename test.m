%{
%field=16;
%numChaffs=180;
%counter=26;
%projpoints=gf(randi((2^field-1),25,2),field);
allProjectionPoints=double(projpoints.x);
%change=fix(65536/(counter-1+numChaffs));

allIndex=zeros(1,counter-1+numChaffs);
for j=1:25
 allIndex(1,j)=allProjectionPoints(j,1);
end

tPoints=counter-1;
mindifference=fix(65536/(counter+numChaffs+80));

for i=1:numChaffs
condition=1;
while(condition)
rPoints=randi([0 65536],1,1);
check=1;
for j=1:tPoints
if( abs(allIndex(1,j)-rPoints)<mindifference)
    check=0;
end
end
if (check==1)
  condition=0;
end
end
rPoints;
i;
allIndex(1,tPoints+1)=rPoints;
tPoints=tPoints+1;
end

%{
AllDiff=zeros(205,205);
for i=1:205
    for j=1:205
        if(i==j)
            AllDiff(i,j)=9999;
        else
            AllDiff(i,j)=abs(allIndex(1,i)-allIndex(1,j));
        end
        
    end
end
minimum=min(min(AllDiff))
csvwrite('outputs/Min.csv',AllDiff);
%}
%{
plot(allIndex,'o')
xlim([0,205]);
ylim([0,65535]);
%}
%}
%{
AllPValue=readtable('outputs/IndependencyAnalysisAllPValueAfterRP.csv');
counter1=0;
counter2=0;
for i=1:41
    for j=1:625
        if(table2array(AllPValue(i,j))==0)
            counter1=counter1+1;
        elseif(table2array(AllPValue(i,j))==999)
            counter2=counter2+1;
        end
    end
end
%}
%{
%Success in valid and invalid claim
AllPValue=readtable('outputs/AllPValueValidClaimRemv.csv');
for i=1:41
    counter=0;
    for j=1:25
        if(table2array(AllPValue(i,j))>=0.05)
            counter=counter+1;
        end
    end
    vScore(i)=counter;
end
csvwrite('outputs/ValidScoreRemv.csv',vScore);

AllPValue=readtable('outputs/AllPValueInValidClaimRemv.csv');
for i=1:41
    counter=0;
    for j=1:25
        if(table2array(AllPValue(i,j))>=0.05)
            counter=counter+1;
        end
    end
    iScore(i)=counter;
end
csvwrite('outputs/InValidScoreRemv.csv',iScore);
min(vScore)
max(iScore)
%}
%All Chaff Points
%{
AllPValue1=readtable('outputs/DACTouch/TouchAllPoints.csv');
AllPValue2=readtable('outputs/DACTouch/DACAllPoints.csv');
AllPValue3=readtable('outputs/DACTouch/DACAllPointsRange.csv');

subplot(1,3,1)
xl=table2array(AllPValue1(1:25,1));
yl=table2array(AllPValue1(1:25,2));
xc=table2array(AllPValue1(26:225,1));
yc=table2array(AllPValue1(26:225,2));

h1=plot(xl,yl,'o');
set(h1,'markersize',3.5)
hold on;
h1=plot(xc,yc,'o');
set(h1,'markersize',2)

xlim([0,65535]);
ylim([0,65535]);

legend('Legitimate points','Chaff points')
%histfit(xl,10);
%xlim([0,65535]);
xlabel('x-axis');
ylabel('y-axis');

subplot(1,3,2)
xl=table2array(AllPValue2(1:45,1));
yl=table2array(AllPValue2(1:45,2));
xc=table2array(AllPValue2(46:245,1));
yc=table2array(AllPValue2(46:245,2));

h1=plot(xl,yl,'o');
set(h1,'markersize',3.5)
hold on;
h1=plot(xc,yc,'o');
set(h1,'markersize',2)

xlim([0,65535]);
ylim([0,65535]);

legend('Legitimate points','Chaff points')
%histfit(xl,10);
%xlim([0,65535]);
xlabel('x-axis');
ylabel('y-axis');

subplot(1,3,3)
xl=table2array(AllPValue3(1:45,1));
yl=table2array(AllPValue3(1:45,2));
xc=table2array(AllPValue3(46:245,1));
yc=table2array(AllPValue3(46:245,2));

h1=plot(xl,yl,'o');
set(h1,'markersize',3.5)
hold on;
h1=plot(xc,yc,'o');
set(h1,'markersize',2)

xlim([0,65535]);
ylim([0,65535]);

legend('Legitimate points','Chaff points')
%histfit(xl,10);
%xlim([0,65535]);
xlabel('x-axis');
ylabel('y-axis');
%}

%BoxPlot for diffferent P value (valid and invalid claim)

totalValidFeatures05HM20=csvread('outputs\validRecoveredPointsTouch100v1.csv');

totalValidFeatures10HM20=csvread('outputs\validRecoveredPointsTouch150v1.csv');

totalValidFeatures15HM20=csvread('outputs\validRecoveredPointsTouch200v1.csv');

totalValidFeatures20HM20=csvread('outputs\validRecoveredPointsTouch250v1.csv');

totalValidFeatures25HM20=csvread('outputs\validRecoveredPointsTouch300v1.csv');

 

 

totalInvalidFeatures05HM20=csvread('outputs\InvalidRecoveredPointsTouch100.csv');

totalInvalidFeatures10HM20=csvread('outputs\InvalidRecoveredPointsTouch150.csv');

totalInvalidFeatures15HM20=csvread('outputs\InvalidRecoveredPointsTouch200.csv');

totalInvalidFeatures20HM20=csvread('outputs\InvalidRecoveredPointsTouch250.csv');

totalInvalidFeatures25HM20=csvread('outputs\InvalidRecoveredPointsTouch300.csv');

%totalInvalidFeatures05HM2=[totalInvalidFeatures05HM20(:,1);totalInvalidFeatures05HM20(:,2);totalInvalidFeatures05HM20(:,3);totalInvalidFeatures05HM20(:,4);totalInvalidFeatures05HM20(:,5)]';
%totalInvalidFeatures10HM2=[totalInvalidFeatures10HM20(:,1);totalInvalidFeatures10HM20(:,2);totalInvalidFeatures10HM20(:,3);totalInvalidFeatures10HM20(:,4);totalInvalidFeatures10HM20(:,5)]';
%totalInvalidFeatures15HM2=[totalInvalidFeatures15HM20(:,1);totalInvalidFeatures15HM20(:,2);totalInvalidFeatures15HM20(:,3);totalInvalidFeatures15HM20(:,4);totalInvalidFeatures15HM20(:,5)]';
%totalInvalidFeatures20HM2=[totalInvalidFeatures20HM20(:,1);totalInvalidFeatures20HM20(:,2);totalInvalidFeatures20HM20(:,3);totalInvalidFeatures20HM20(:,4);totalInvalidFeatures20HM20(:,5)]';
%totalInvalidFeatures25HM2=[totalInvalidFeatures25HM20(:,1);totalInvalidFeatures25HM20(:,2);totalInvalidFeatures25HM20(:,3);totalInvalidFeatures25HM20(:,4);totalInvalidFeatures25HM20(:,5)]';

totalInvalidFeatures05HM2=totalInvalidFeatures05HM20(:,1)';
totalInvalidFeatures10HM2=totalInvalidFeatures10HM20(:,1)';
totalInvalidFeatures15HM2=totalInvalidFeatures15HM20(:,1)';
totalInvalidFeatures20HM2=totalInvalidFeatures20HM20(:,1)';
totalInvalidFeatures25HM2=totalInvalidFeatures25HM20(:,1)';


allAcceptFP=[totalValidFeatures05HM20;totalValidFeatures10HM20;totalValidFeatures15HM20;totalValidFeatures20HM20;totalValidFeatures25HM20];

allInvAcceptFP=[totalInvalidFeatures05HM2;totalInvalidFeatures10HM2;totalInvalidFeatures15HM2;totalInvalidFeatures20HM2;totalInvalidFeatures25HM2];


allInv=[totalValidFeatures05HM20;totalInvalidFeatures05HM2;totalValidFeatures10HM20;totalInvalidFeatures10HM2;totalValidFeatures15HM20;totalInvalidFeatures15HM2; totalValidFeatures20HM20;totalInvalidFeatures20HM2;totalValidFeatures25HM20;totalInvalidFeatures25HM2];
X=[100 150 200 250 300];

%aX=['0.05'; '0.05'; '0.10'; '0.10'; '0.15'; '0.15'; '0.20'; '0.20'; '0.25'; '0.25'];
%boxplot(allInv');

%set(gca,'xticklabel',aX);

boxplot(allAcceptFP',X);
hold on;
boxplot(allInvAcceptFP',X);

%xticks([-3*pi -2*pi -pi 0 pi 2*pi 3*pi])

%xticklabels({'-3\pi','-2\pi','-\pi','0','\pi','2\pi','3\pi'})

%xticks([0.1 0.2 0.3 0.4 0.5]);

ylim([0,25]);

xlabel('Total chaff points');

ylabel('Total recovered legitimate points');


%FAR and FRR calculation
%allAcceptFP=csvread('outputs\ValidScoreRemv.csv');
%allInvAcceptFP=csvread('outputs\InValidScoreRemv.csv');

%{
threshold=13;
FR=0;
[m1,n1]=size(allAcceptFP);
for i=1:m1
    for j=1:n1
    if (allAcceptFP(i,j)<threshold+1)
        FR=FR+1;
    end
    end
end
FRR=(FR/(n1*m1))*100

FA=0;
[m2,n2]=size(allInvAcceptFP);
for i=1:m2
    for j=1:n2
    if (allInvAcceptFP(i,j)>=threshold+1)
        FA=FA+1;
    end
    end
end
FAR=(FA/n2*m2)*100
%}
%{
%cPValue=csvread('outputs\DACTouch\UniformityTuch.csv');
cPValue=csvread('outputs\DACTouch\UniformityDAC.csv');

count=0;
for i=1:41
    if(cPValue(i,5)<0.05)
        count=count+1;
    end
end
mean(cPValue(:,5))
%}
%{
a=3150234554696452080;
b=3268760;
c=a/b;
d=de2bi(c)
%}
%}