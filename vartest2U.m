function [h,p,ci,stats] = vartest2U(varx,df1,vary,df2)

% Compute statistics for each sample
%[df1,varx] = getstats(x,dim);
%[df2,vary] = getstats(y,dim);
alpha = 0.05;
tail = 0;    % code for two-sided;
dim = 1;
% Compute F statistic
F = NaN(size(varx),superiorfloat(varx,vary));
t1 = (vary>0);
F(t1) = varx(t1) ./ vary(t1);
t2 = (varx>0) & ~t1;
F(t2) = Inf;
%X=[' ',num2str(F),'  ',num2str(df1),'  ',num2str(df2)];
%disp(X);
% Compute the correct p-value for the test, and confidence intervals
% if requested.
if tail == 0 % two-tailed test
    p = 2*min(fcdf(F,df1,df2),fpval(F,df1,df2));
    if nargout > 2
        % Avoid precision loss from subtracting alpha from one
        ci = cat(dim, F.*finv(alpha/2,df2,df1), ... % == F./finv(1-alpha/2,df1,df2)
                      F./finv(alpha/2,df1,df2));
                  
    end
elseif tail == 1 % right one-tailed test
    p = fpval(F,df1,df2);
    if nargout > 2
        ci = cat(dim, F.*finv(alpha,df2,df1), ... % == F./finv(1-alpha,df1,df2)
                      Inf(size(F)));
    end
elseif tail == -1 % left one-tailed test
    p = fcdf(F,df1,df2);
    if nargout > 2
        ci = cat(dim, zeros(size(F)), ...
                      F./finv(alpha,df1,df2));
    end
end

% Determine if the actual significance exceeds the desired significance
h = cast(p <= alpha, class(p));
h(isnan(p)) = NaN; % p==NaN => neither <= alpha nor > alpha

if nargout > 3
    stats = struct('fstat', F, 'df1', cast(df1,class(F)), ...
                               'df2', cast(df2,class(F)));
    if isscalar(df1) && ~isscalar(F)
        stats.df1 = repmat(stats.df1,size(F));
    end
    if isscalar(df2) && ~isscalar(F)
        stats.df2 = repmat(stats.df2,size(F));
    end
end