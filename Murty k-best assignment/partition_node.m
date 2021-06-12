function nodes_out = partition_node(node_in,cost_mat,opt_fun)
% takes an input node of the following form and outputs a list of nodes
% partitioned around the input node.  See Murty 1968 for a clear
% description of node partitioning.
%
% inputs:
%     -node_in:    1x4 cell array  with fields 1) fixed assignments 2)
%                excluded assignments, 3) remaining unspecified assignments 4) solution
%                cost
%     -cost_mat:   cost matrix for assignments
% 
% outputs:
%     -nodes_out: n x 4 list of nodes partitioned around input node
%
% author: v1 - EMT, 2/14/11

u = size(node_in{1,3},1);  %unspecified assignments

% nodes_out = [];
% if (u == 1)
%     nodes_out = node_in;
% else
    %iterate u times to permute held out assignments
    for ii = 1:(u-1)
        %keep fixed assignments
        node_out_tmp{1} = node_in{1,1};

        %keep excluded assignements
        node_out_tmp{2} = node_in{1,2};

        %if there are unspecified assignments, permute and add to list of exclusions:
        if ii > 1
            node_out_tmp{1} = [node_out_tmp{1}; node_in{1,3}(1:(ii-1),:)];
        end

        %if there are unspecified assignments, permute and add to list of exclusions:
        node_out_tmp{2} = [node_out_tmp{2}; node_in{1,3}(ii,:)];

        %add the rest of unspecified:
        tmp = node_in{1,3}((ii+1):end,:);
        node_out_tmp{3} = tmp;
     
        node_out_tmp2 = calc_node_cost(node_out_tmp,cost_mat,opt_fun);
        if ~isempty(node_out_tmp2)
            nodes_out(ii,1:4) = node_out_tmp2;  
        end
    end
    
    if ~exist('nodes_out')
        nodes_out = cell(1,4);
        nodes_out{1,4} = 1e5;   %something arbitrarily large %todo: remove this
    end
end

function node_out = calc_node_cost(node_in,cost_mat,opt_fun)

fixed_assignments = node_in{1,1};
excluded_assignments = node_in{1,2};
mask = zeros(size(cost_mat));
cost_sum = 0;
mask_num = inf;

if size(fixed_assignments > 0)
    for ii = 1:size(fixed_assignments,1)
        cost_sum = cost_sum + cost_mat(fixed_assignments(ii,1),fixed_assignments(ii,2));
        %mask out all entries in same rows/cols as fixed assigments
        mask(fixed_assignments(ii,1),:) = mask_num;
        mask(:,fixed_assignments(ii,2)) = mask_num;
    end
end

%add excluded assignments to mask
if size(excluded_assignments > 0)
    for kk = 1:size(excluded_assignments,1)
        mask(excluded_assignments(kk,1),excluded_assignments(kk,2))= mask_num;
    end
end

[row,col] = find(mask == 0);
if (size(unique(row),1) == size(unique(col),1))%detect degenerate conditions in else
    % calc optimal assignment using masked cost matrix.  
    % todo: add support for JVC or better algorithm emt,1/28/11
    % todo: pass in algorithm as a function handle
    [assignment,cost] = opt_fun(cost_mat + mask);

    %NOTE: row/col transposition below so assignment is sorted by rows
    [col,row] = find(assignment');

    node_out = node_in;
    %add the sum of the costs from fixed assignments and the rest

    cost_out = cost_sum + cost;
    node_out{3} = [row col];
    node_out{4} = cost_out;
else
    node_out{4} = 1e5;
end

end










        