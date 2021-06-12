function assignment_list = k_best_assign(cost_mat,k,opt_fun)
% function to find the k-best associations from an assignment cost matrix.
% See: 
%   An Algorithm for Ranking all the Assignments in Order of Increasing Cost
%   Katta G. Murty, Operations Research, Vol. 16, No. 3 (May - Jun., 1968), pp. 682-687 
%
% inputs: 
%     -cost_mat:     matrix of assignment costs, only tested square so far
%     -k:            number of ranked assignments desired
%     -opt_fun:      function handle for an assignment algorithm (munkres or
%                   JV algorithm, etc)
% outputs:
%     -assignment_list:  a (k x 2) ranked list of optimal assignments (column 1)
%                       and costs (column 2)

% See http://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm
% for one implementation of munkres algorithm
% 
% NOTE: This function requires a standard assigment function for solving a
% single cost matrix.  Implementations of the Munkres and JV linear
% assigment algorithms can be found elsewhere on FEX:%                     
%
% author: v1 - EMT, 2/14/11
%
% ---------------------------------------------------------------------
% Example: 
% 
% cost_mat = rand(50);
% k = 5;
% optfun = @munkres;      %requires 
% assignment_list = k_best_assign(cost_mat,k,opt_fun)
%
% ---------------------------------------------------------------------

% find initial optimal assignment
[assignment,cost] = opt_fun(cost_mat);
[col,row] = find(assignment');
nodes = {[], [],[row col], cost};
optimal_nodes = {[], [],[row col], cost};

%partition the optimal node
nodes_list = partition_node(nodes,cost_mat,opt_fun);

while (size(optimal_nodes,1) < k) 
    %find the best node among those in the node list
    costs = cell2mat(nodes_list(:,4));
    [min_cost,ind] = min(costs);
    
    %copy best node from list into optimal set
    optimal_nodes(end+1,:) = nodes_list(ind,:);
    
%     nodes_list(ind,:);  %for debug
    nodes_tmp = partition_node(nodes_list(ind,:),cost_mat,opt_fun);
    nodes_list(ind,:) = []; %remove best node from list

    %add new partitioned nodes to list
    nodes_list = [nodes_list; nodes_tmp]; 
%     disp('==========================================================');  %for debug
    
end

%format output data structure
assignment_list = cell(size(optimal_nodes,1),2);
for ii = 1:size(optimal_nodes,1)
    assignment_list{ii,1} = [optimal_nodes{ii,1}; optimal_nodes{ii,3}]; 
    assignment_list{ii,2} = optimal_nodes{ii,4};
end








