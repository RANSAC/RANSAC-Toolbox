function flag = validateMSS_homography(X, s)

% flag = validateMSS_homography(X, s)
%
% DESC:
% Validates the MSS obtained sampling the data using the sideness
% constraintbefore computing the parameter vector Theta
%
% INPUT:
% X                 = samples on the manifold
% s                 = indices of the MSS
%
% OUTPUT:
% flag              = true if the MSS is valid

% HISTORY:
%
% 1.1.0             - 10/12/08 - Initial version


% set this to true to display invalid MSS (just for debug/didactic
% purposes)
graphic = false;

% Check if the points are in pathological configurations. Compute the
% covariance matrix and see if the determinant is too small (which implies
% the point are collinear)
ind = [1 2];
for h = 1:2
    mu = mean(X(ind, s), 2);
    Xzm = X(ind, s) - repmat(mu, 1, length(s));
    C1 = Xzm(1, :)*transpose(Xzm(1, :));
    C2 = Xzm(1, :)*transpose(Xzm(2, :));
    C3 = Xzm(2, :)*transpose(Xzm(2, :));
    % compute the condition number
    alpha = C1+C3;
    temp  = C1-C3;
    beta  = temp*temp;
    gamma = 4*C2*C2;
    delta = sqrt(beta+gamma);
    kappa = (alpha+delta)/(alpha-delta);
    if ( kappa > 1e9 )
        flag = false;
        return;
    end;
    ind = ind + 2;
end;

% Generate all the possible pairings for the line that determines the
% semi-planes. The anchor point is the first one, i.e. the one with index
% 1. Thus the line that defines the semiplanes can be the line passing
% through the points:
%
% (1,2) or
% (1,3) or
% (1,4)
%
% The remaining rows define the points that should lie in different
% semiplanes
ind = s([...
    2 3 4; ...
    3 2 2; ...
    4 4 3]);

% Setting the flag to false should guard against collinearity
flag = false;
for l = 1:3

    % compute the normal vector $\vct{n}_{1,l}$
    % 2 summations
    n(1) = X(2, ind(1,l))-X(2, s(1));
    n(2) = X(1, s(1))-X(1, ind(1,l));

    % get the projection of the other two points
    % 6 summations, 4 multiplications
    p1 = n(1)*( X(1,ind(2,l)) - X(1, s(1)) ) +...
        n(2)*( X(2,ind(2,l)) - X(2, s(1)) );
    p2 = n(1)*( X(1,ind(3,l)) - X(1, s(1)) ) +...
        n(2)*( X(2,ind(3,l)) - X(2, s(1)) );

    % if they lie on the same side then select next arrangement
    if sign(p1) == sign(p2)
        continue;
    end;

    % compute the normal vector $\vct{n}_{1,l}'$ for the corresponding
    % points
    % 2 summations
    np(1) = X(4, ind(1,l))-X(4, s(1));
    np(2) = X(3, s(1))-X(3, ind(1,l));

    % get the projection of the other two corresponding points
    % 6 summations, 4 multiplications
    pp1 = np(1)*( X(3,ind(2,l)) - X(3, s(1)) ) +...
        np(2)*( X(4,ind(2,l)) - X(4, s(1)) );
    pp2 = np(1)*( X(3,ind(3,l)) - X(3, s(1)) ) +...
        np(2)*( X(4,ind(3,l)) - X(4, s(1)) );

    % verify the sideness
    flag = (sign(p1) == sign(pp1)) && (sign(p2)==sign(pp2));

    if (graphic) && (flag == false)

        color = 'gr';
        d = 16;

        figure;

        offset = 0;
        for kk = 1:2
            subplot(1,2,kk)
            hold on
            plot(X(1+offset, s), X(2+offset, s), ...
                'o','MarkerSize', 8, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', color(kk))
            % draw the line that separates the planes
            plot([X(1+offset, s(1)) X(1+offset, ind(1, l))], ...
                [X(2+offset, s(1)) X(2+offset, ind(1, l))], '--k');

            for hh = 1:4
                text(X(1+offset, s(hh))+d, ...
                    X(2+offset, s(hh))+d, num2str(hh))
            end;
            xlabel('x');
            ylabel('y');
            axis equal
            offset = offset + 2;
        end;

        pause
    end;

    break;

end;


return;
