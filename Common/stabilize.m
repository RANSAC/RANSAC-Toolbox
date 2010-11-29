function results_stabilized = stabilize(X, results, options)

% results_stabilized = stabilize(X, results, options)
%
% DESC:
% attempts to stabilize the results provided by RANSAC. This function is
% till in an experimental phase.
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION
% 1.0.0
%
% INPUT:
% X                     = input data set
% results               = results provided by RANSAC
% options               = RANSAC options
%
% OUTPUT:
% results_stabilized    = stabilized results
%
% HISTORY
% 1.0.0         - 24/06/08 - Initial version

warning('RANSACToolbox:experimental', 'The stablization routine is still at an experimental stage.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set to true for the progressive inclusion of the outliers
inclusion = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if all the points are inliers just return the same results
results_stabilized = results;

N = length(results.CS);
N_star = sum(results.CS);
if (N_star == length(results.CS))
    return;
end;

if (options.verbose)
    fprintf('\n\nStarting stabilization on %d inliers out of %d elements\n', N_star, N);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bias RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% call RANSAC biasing the sampling on the CS. Iterate as long as the cost
% decreases
options.mode     = 'MSAC';
% avoid recursion
options.stabilize = false;

% saturation = 0.5;

% Emax = max( results_stabilized.E(results_stabilized.CS) );
% Emin = min( results_stabilized.E(results_stabilized.CS) );
% w = (results_stabilized.E-Emin)/(Emax-Emin);
% % saturate
% w(w > saturation) = saturation;
% score = 1-w;
score = double(results_stabilized.CS);
while true

    % bias the sampling
    options.Ps = score;
    options.Ps = options.Ps/sum(options.Ps);

    results = RANSAC(X, options);

    % is the cost decreased?
    if ( results.J < results_stabilized.J )
        % save the results of the first stage
        results_stabilized = results;
    else
        break;
    end;

    %     Emax = max( results_stabilized.E(results_stabilized.CS) );
    %     Emin = min( results_stabilized.E(results_stabilized.CS) );
    %     w = (results_stabilized.E-Emin)/(Emax-Emin);
    %     % saturate
    %     w(w > saturation) = saturation;
    %     score = score + (1-w);
    score = score + double(results_stabilized.CS);

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main inclusion loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if inclusion

    iter = 1;
    Je_star = results_stabilized.J;
    CSe     = results_stabilized.CS;
    while true

        if (options.verbose)
            fprintf('\nStabilization run %d', iter);
        end;

        % scan all the outliers to include the one that produces the largest
        % cost decrease
        n = 1;
        flag = false;
        ind_CSe = find(CSe);
        while (n <= N)

            % if the point is actually labelled as an outlier
            if ~CSe(n)

                % extend the inlier data set
                se = [ind_CSe n];

                % recompute the parameters using the extended data set
                Thetae = feval(options.est_fun, X, se);

                % check if something went wrong with the estimation
                if isempty(Thetae)
                    n = n + 1;
                    continue;
                end;

                % recompute the error and consensus set using the new parameter
                % vector
                [Ee CSee] = get_consensus_set(X, Thetae, results.T_noise_squared, options.man_fun);

                % recompute the cost using the extended data set
                Je = get_consensus_set_cost(Ee, results.T_noise_squared);

                % if the cost decreased then let's update
                if (Je < Je_star)

                    % make sure we should go for another stabilizaion run
                    flag        = true;

                    Je_star     = Je;
                    Theta_star  = Thetae;
                    E_star      = Ee;
                    CSe_star    = CSee;

                    if (options.verbose)
                        fprintf('\nInliers = %d/%d, Cost is J = %8.8f', sum(CSe_star), N, Je_star);
                    end;

                end;

            end;

            % go to the next outlier
            n = n + 1;
        end;

        % make the updates
        if (flag) && (results_stabilized.J > Je_star)

            CSe = CSe_star;

            results_stabilized.Theta = Theta_star;
            results_stabilized.E     = E_star;
            results_stabilized.CS    = CSe_star;
            results_stabilized.J     = Je_star;

        else

            break;

        end;

        iter = iter + 1;

    end;

end;

return
