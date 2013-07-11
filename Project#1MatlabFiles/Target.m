% File: Target
%
% Target is a function file that finds the correct firing angle to
% hit the target. The arguments for Target are the location
% of the target and the horizontal and vertical components of the
% wind. Target finds the firing angle by making an initial guess
% and then calling a method to interpolate until the target is hit
% or it is determined that the target cannot be reached. If the target
% cannot be reached, a message is displayed and 0 is returned.
% 
% This implementation is designed to return the most direct firing
% angle to the target. That is, if two firing angles can hit the 
% target, this method returns the angle that hits the target in the 
% least amount of time.
%
% This implementation is only designed to return targets in the first
% quadrant. A message is displayed and 0 is returned if the target is not
% in the first quadrant.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1

function [ theta_target ] = Target(coord, wind)

% Define global variables accessed by other functions
global xT;          % x-coordinate of target
global yT;          % y-coordinate of target
global uTheta;      % maximum undershot angle
global uDist;       % negative distance from target corresponding to uTheta
global oTheta;      % minimum overshot angle
global oDist;       % distance from target corresponding to oTheta
global alpha;       % x-component of wind
global beta;        % y-component of wind
global verbose;     % set to 1 to display messages during processing
                    % set to 2 to display messages and additional plots

verbose = 0;
theta_target = 0;   % Init return value to 0 in case target is not hit

% Set the distance tolerance used to indicate if the target was hit
% The tolerance was chosen to provide four digits of precision to the
% right of the decimal point in the firing angle.
tolerance = 0.01;

% Initialize the global variables to allow the system to access the
% target location and the wind speed
xT = coord(1);
yT = coord(2);
alpha = wind(1);
beta = wind(2);

% Return if the target is not in the first quadrant
if ((xT < 0) || (yT < 0))
    disp('This program only finds targets in the first quadrant.')
    return
end

% Fire directly at the target to initialize the envelope.
% Typically, this angle will undershoot the target. However,
% a horizontal component of the wind can result in this angle
% overshooting the target.
uTheta = atan2(yT, xT);
uDist = FireProjectile(xT, yT, uTheta);

% Check to see if we hit the target
if (abs(uDist) < tolerance)
    fprintf('Fire the projectile at %6.4f radians to hit the target.\n',...
        uTheta)
    theta_target = uTheta;          
    return
end

% Check for boundary condition that can occur if the target is at
% (0, yT), there is no horizontal component to the wind, and the
% target is out of range.
if ((xT == 0) && (alpha == 0))
    disp('The target is out of range.')
    return
end

% Initialize the remainder of the envelope. 
if (uDist > 0)
    % The horizontal component of the wind caused an overshot
    oTheta = uTheta;
    oDist = uDist;
    
    % Avoid calling the ode solver to set the lower bound of the envelope.
    % Instead, 'fire' perpendicular to the target so that the distance
    % can be accurately set
    uTheta = oTheta - pi/2;
    uDist = -sqrt(xT^2 + yT^2);
else
    % Avoid calling the ode solver to set the upper bound of the envelope.
    % Instead, 'fire' perpendicular to the target so that the distance
    % can be accurately set
    oTheta = uTheta + pi/2;
    oDist = sqrt(xT^2 + yT^2);
end

if (verbose > 0)        
    disp(horzcat('The distance for the lower angle ', num2str(uTheta),...
        ' is ', num2str(uDist)))    
    disp(horzcat('The distance for the upper angle ', num2str(oTheta),...
        ' is ', num2str(oDist)))
end

% Interpolate between the upper and lower bounds to determine
% the initial guess for the firing angle.
theta = uTheta - (uDist / (oDist - uDist)) * (oTheta - uTheta);
dist = FireProjectile(xT, yT, theta);

if (verbose > 0)
    disp(horzcat('The minimum distance for angle ', num2str(theta),...
        ' is ', num2str(dist)))   
end

% Enter loop to refine theta until the target is hit or it is
% determined that the target is out of range. Return 0 if the 
% target cannot be reached.
while (abs(dist) > tolerance)
    nextTheta = Bisection(theta, dist);
    
    % Bisection will return the same angle if it determines
    % that the target cannot be reached.
    if (nextTheta == theta)
        disp('The target is out of range.')
        return
    end
    
    theta = nextTheta;
    dist = FireProjectile( xT, yT, theta);
    
    if (verbose > 0)
        disp(horzcat('The minimum distance for angle ', num2str(theta),...
            ' is ', num2str(dist)))  
    end
end

% Return the angle required to hit the target
fprintf('Fire the projectile at %6.4f radians to hit the target.\n',...
    theta)
theta_target = theta;


