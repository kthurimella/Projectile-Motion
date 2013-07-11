% File: FireProjectile
%
% The function file FireProjectile utilizes ode45 to integrate
% the system of differential equations. It uses the function
% ControlEvents to stop integrating when the flight of the 
% projectile is perpendicular to the target. The function returns
% the distance to the target at the stopping point. If the target
% was undershot, the return distance is negative.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1

function [ dmin ] = FireProjectile( xT, yT, theta )

global alpha;       % x-component of wind
global verbose;     % set to 1 to display messages during processing

%------------------------------------------------------------------------
%     Set initial conditions and parameters
%------------------------------------------------------------------------
v_init = 1500;          % initial speed (m/s)

tInit = 0;              % integration interval
tFin  = Inf;            % infinite (ControlEvents stops the integration)

xInit(1) = 0;           % initial conditions
xInit(2) = 0;
xInit(3) = v_init;
xInit(4) = theta;

%------------------------------------------------------------------------
%     Integrate the system with a stopping condition
%------------------------------------------------------------------------
if ((xT == 0) && (alpha == 0))
    % An additional stopping condition is used for a vertical target
    % if there is not a horizontal component to the wind
    options = odeset('Events', @ControlEventsVert,...
                     'Refine', 12, 'RelTol',0.001, 'AbsTol',0.001);
else
    options = odeset('Events', @ControlEvents,...
                     'Refine', 12, 'RelTol',0.001, 'AbsTol',0.001);
end

[t, x] = ode45( @MySystem, [tInit, tFin], xInit, options );

%------------------------------------------------------------------------
%     Plot the results
%------------------------------------------------------------------------
if (verbose > 0)
    disp(horzcat('The stopping point is (', num2str(x(end,1)), ', ',...
        num2str(x(end, 2)), ') at time ', num2str(t(end))))
end

if (verbose > 1)
    figure;
    plot(t,x(:,1),t,x(:,2))     % plot of x and y vs. t
    xlabel('time')
    ylabel('x and y')
    title('Plot of x and y vs. time')

    figure;
    plot(t,x(:,3))              % basic plot of velocity
    xlabel('time')
    ylabel('velocity')
    title('Plot of velocity vs. time')

    figure;
    plot(t,x(:,4))              % basic plot of theta
    xlabel('time')
    ylabel('theta')
    title('Plot of theta vs. time')
end

if (verbose > 0)
    figure;
    plot(x(:,1), x(:,2))        % plot of projectile path to stopping pt
    xlabel('x')
    ylabel('y')
    title(horzcat('Plot of projectile path for theta ', num2str(theta)))
end

% Return the distance to the target at the stopping point.
dmin = sqrt((x(end, 1) - xT)^2 + (x(end, 2) - yT)^2);

% Return a negative distance if the result undershot the target.
% The following conditions apply to a target in the first quadrant.
if (x(end, 4) <= pi/2)
    if (x(end, 2) < yT)
        dmin = -dmin;
    end
elseif (x(end, 2) > yT)
    % Tangential velocity is greater than 90 degrees and the target
    % is beneath the current location. This condition can only occur
    % with a negative horizontal component of the wind.
    dmin = -dmin; 
end

