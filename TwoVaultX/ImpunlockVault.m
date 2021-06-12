function recoveredValidData = ImpunlockVault(vault,unlockingSet,DEGREE,n1,id)
% unlockVault()
%      Input: a vault, unlocking set, degree of the polynomial and size of input data
%      It compare all points of unlocking set with the points of vault and
%      gets a matrix of p-value. Transform the matrix to square matrix.
%      Apply the Hungarian method to get the optimal solution
%      Return:a pair of recovered points and their evaluation 
%

% add path to src folder:

addpath('./Murty k-best assignment/');
%initialized row and columns
rows=length(vault);
cols=length(unlockingSet);

% work over GF(2^16):
FIELD = 16;
%unlocking set to GF(2^16)
unlockingSetF=gf(unlockingSet,FIELD);

% size of vault and unlocking set
vaultLength = length(vault);
numPts = length(unlockingSetF);

% initialize the coefficient in GF
coeffs = gf(zeros(1,(DEGREE+1)),FIELD);
%{
 %===Begin Inverse transformation======
 %was range 0-65535 then become 0-1 then convert 0-65535
 vp=double(vault.x);
 vpoint=(((vp(:,1)-1)*1)/65535)+0;
 vpoint=uint16(norminv(vpoint,mlockingSet,slockingSet));
 %vpoint=uint16((((vpoint-0)*65534)/1)+1);
 Fvpoint=gf(vpoint,16);
 allPValues=Matching1(Fvpoint,unlockingSetF,n1);

 
%===End Inverse transformation======
%}
%-----------------Uniformity test-------------
%xAxisData =double(vault.x);
%pd = makedist('uniform');
%test=[rescale(xAxisData(:,1)),rescale(xAxisData(:,2))];
%[h1,p1] = kstest(test,'cdf',pd);
%test=rescale(xAxisData(:,1));
%[h2,p2] = kstest(test,'cdf',pd);
%fprintf('%f %f %f %f\n',h1,p1,h2,p2);
%AllUniformDist(id,1)=id;
%AllUniformDist(id,2)=h1;
%AllUniformDist(id,3)=p1;
%AllUniformDist(id,4)=h2;
%AllUniformDist(id,5)=p2;
%-----------------End Uniformity test---------


allPValues=Matching1(vault(:,1),unlockingSetF,n1);
%allPValues=0 + (1-0) * rand(vaultLength,vaultLength);

%Matching2: it used the HUNGARIAN method to get optimal solution
[costMatrix,totalCost]=Matching2(-allPValues);
%costMatrix
%opt_fun = @munkres;
%assignment_list=k_best_assign(-allPValues,15,opt_fun);

%fprintf('Total cost: %f.\n',-totalCost);
%t=strcat('outputs/AllCValue',num2str(id),'.csv');
%size(allPValues)
%csvwrite(t,-allPValues);

% based on cost matrix seperate the recovered pair and their p-value


for i=1:rows
optimalP(i)=  allPValues(costMatrix(i),i);
optimalXValueF=vault(costMatrix(i),1);
optimalYValueF=vault(costMatrix(i),2);
optimalXValue(i)=double(optimalXValueF.x);
optimalYValue(i)=double(optimalYValueF.x);
%recoveredData=[FinalPvalues(costMatrix(i),i) vault(costMatrix(i),1) vault(costMatrix(i),2)]
end
recoveredData=[optimalP' optimalXValue' optimalYValue' ];
recoveredValidData=recoveredData(1:cols,:);

%{
count=1;
for i=1:rows
if(costMatrix(i)<=45)
%optimalP(i)=  allPValues(costMatrix(i),i);
%optimalXValueF=vault(costMatrix(i),1);
%optimalYValueF=vault(costMatrix(i),2);
%optimalXValue(i)=double(optimalXValueF.x);
%optimalYValue(i)=double(optimalYValueF.x);

optimalP(count)=allPValues(i,i);
optimalXValueF=vault(i,1);
optimalYValueF=vault(i,2);
optimalXValue(count)=double(optimalXValueF.x);
optimalYValue(count)=double(optimalYValueF.x);
%recoveredData=[FinalPvalues(costMatrix(i),i) vault(costMatrix(i),1) vault(costMatrix(i),2)]
count=count+1;
end
end
%}
%costMatrix
%combine p-vaule and recovered vault pair togather
%recoveredValidData=[optimalP' optimalXValue' optimalYValue' ];



%assignment_list{1}(:,2)

%list=assignList{1,1};
%{
for solution=1:15
%assignment_list(solution,2);
for i=1:rows
optimalP(i)=  allPValues(assignment_list{solution}(i,2),i);
optimalXValueF=vault(assignment_list{solution}(i,2),1);
optimalYValueF=vault(assignment_list{solution}(i,2),2);
optimalXValue(i)=double(optimalXValueF.x);
optimalYValue(i)=double(optimalYValueF.x);
%recoveredData=[FinalPvalues(costMatrix(i),i) vault(costMatrix(i),1) vault(costMatrix(i),2)]
end

%combine p-vaule and recovered vault pair togather
recoveredData=[optimalP' optimalXValue' optimalYValue' ];

%return the triple based on the size of unlocking set  
recoveredValidData(45*(solution-1)+1:45*solution,:)=recoveredData(1:cols,:);
%recoveredData(1:cols,:)
end
%}

%{
%-------------RS-decoding part----------------
DEGREE=35;
testSet = recoveredValidData(1:cols,2:3);
% try running on points of vaultSorted:
polyCoeffs = decodePolynomial(testSet,FIELD,DEGREE);

if (checkPoly(testSet,polyCoeffs,field))
  coeffs = polyCoeffs;
end
%-------------End RS-decoding part--------------
%}

end