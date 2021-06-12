function [vault,xl]=lockVault(secret,lockingset,NChaffs,n1)
%secure(): 
%    Input: A secret and locking set
%      
%    
%    
%    Return: a vault which is a pair of points

%set the path for all other files

%work over GF(2^16)
FIELD=16;

%------------No RSCode----------------------
%degree of polynomial
DEGREE=length(secret)-1;
%===Generate a polynomial from the secret =====
poly=gf(double(secret),FIELD);
%------------End No RSCode----------------------

%{
%------------RSCode----------------------
%Note: An important change for RS-Code
 DEGREE=35;

%===Or, Generate a polynomial by RS Code =====
poly = RSCode(secret,FIELD,DEGREE);
%------------End RSCode----------------------
%}


%locking data to GF(2^16)
lockingsetF=gf(lockingset,FIELD);
%size(pointsgf')

%number of points in locking set
M=length(lockingsetF);

%number of cofficient in secret
N=length(secret);

%initialize a M*1 matrix by zeros of GF(2^field):
values = gf(zeros(M,1),FIELD);

%initialize a M*N matrix by zeros of GF(2^field):
initialvaule=gf(ones(M,N),FIELD);


%For locking set calculate a M*N matrix
%[1,X_1,X_1^2,....,X_1^k; 1,X_2,X_2^2,....,X_2^k;...;1,X_M,X_M^2,....,X_M^k]
for i=1:M
for j=2:N
  initialvaule(i,j)=initialvaule(i,j-1)*lockingsetF(i); 
end
end

%For locking set calculat f(x)
%f(x)=m_0+m_1*X+m_2*X^2+...+m_k*X^k
for i=1:M
for j=1:N
  values(i)=values(i)+poly(j)*initialvaule(i,j); 
end
end

% combine both locking set and its evaluation
projection=[lockingsetF',values];

%=========Chaff Point Generation and Mix Up========
[vault,xl]=chaffPoints(projection,poly,DEGREE,NChaffs,FIELD,n1);
end
