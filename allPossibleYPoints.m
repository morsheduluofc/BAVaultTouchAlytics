function [allIndex]=allPossibleYPoints(projpoints,field,numChaffs,counter,extraPoint)
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
mindifference=fix((2^field-1)/(counter+numChaffs+extraPoint));

for i=1:numChaffs
condition=1;
while(condition)
rPoints=randi([0 2^field-1],1,1);
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
end