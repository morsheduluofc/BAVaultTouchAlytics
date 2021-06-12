%id=1;
%cost_mat=csvread('AllCValue12.csv');
%cost_mat=-cost_mat;
%cost_mat=strcat('outputs/AllCValue',num2str(id),'.csv');

cost_mat =[7 51 52 87 38 60 74 66 0 20;
           50 12 0 64 8 53 0 46 76 42;
           27 77 0 18 22 48 44 13 0 57;
           62 0 3 8 5 6 14 0 26 39;
           0 97 0 5 13 0 41 31 62 48;
           79 68 0 0 15 12 17 47 35 43;
           76 99 48 27 34 0 0 0 28 0;
           0 20 9 27 46 15 84 19 3 24
           56 10 45 39 0 93 67 79 19 38
           27 0 39 53 46 24 69 46 23 1];
%cost_mat = rand(50);
k = 10;
opt_fun = @munkres;      %requires 
assignment_list = k_best_assign(cost_mat,k,opt_fun);

for i=1:10
 recoverpoints(10*(i-1)+1:10*i,:)= assignment_list{i};  
end
a=recoverpoints(:,:)';
a=a(1,:)+","+a(2,:);
xx = unique(a);       % temp vector of vals
x = sort(a);          % sorted input aligns with temp (lowest to highest)
t = zeros(size(xx)); % vector for freqs
[m,n]=size(xx);
xxx = zeros(2,n);
%st = zeros(size(xx));
% frequency for each value
for i = 1:length(xx)
    t(i) = sum(x == xx(i));
    xxx(:,i)=split(xx(i),',');
    %st(i)=recoverpoints(find(recoverpoints(:,2)==xx(i),1),4);
end

answer=[xxx(1,:);xxx(2,:);t]';
sortrows(answer,-3)

%{
[costMatrix,totalCost]=Matching2(cost_mat);
[~,idx] = sort(assignment_list{1}(:,2)); % sort just the first column
sortedmat = assignment_list{1}(idx,:); % sort the whole matrix using the sort indices
[costMatrix',sortedmat(:,1)]
%points=[assignment_list{1},assignment_list{2},assignment_list{3},assignment_list{4},assignment_list{5}];
%csvwrite('Murty/Murty k-best assignment/AllCPoints.csv',points);
%}