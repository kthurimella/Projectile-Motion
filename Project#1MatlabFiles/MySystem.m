% File: MySystem
%
% The function file MySystem defines a system of differential 
% equations for projectile motion. The system assumes constant
% wind (defined by alpha and beta) and a drag force opposing
% the direction of motion relative to the air. 
%
% For performance reasons, a simplified set of equations is used
% for the case when there is no wind.
%
% Two systems of differential equations exist for the wind. The 
% "norris" system was provided by the instructor. The other system
% was derived by the authors of this program. The global variable
% norris should be set to 1 to use the "norris" system.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1

function xdot = MySystem( ~, x)

global alpha;       % x-component of wind
global beta;        % y-component of wind
global norris;      % flag determining the system to use

%--------------------------------------------------------------------------
% Define constants
%--------------------------------------------------------------------------
g = 9.81;               % gravity in m/s
Cdrag_m = 0.002;        % coefficient of drag divided by mass of projectile

%--------------------------------------------------------------------------
% Define the system
% x(1) is the x-position (m)
% x(2) is the y-position (m)
% x(3) is the velocity (m/s)
% x(4) is the tangential direction of the projectile (radians)
%--------------------------------------------------------------------------

% Save the trigonometric values for performance reasons
cos_theta = cos(x(4));
sin_theta = sin(x(4));

% Define dx/dt and dy/dt (they are the same for all systems)
xdot(1) = x(3) * cos_theta;
xdot(2) = x(3) * sin_theta;

% Define dv/dt and dtheta/dt for the systems
% Use a simplified system if there is no wind
if ((alpha == 0) && (beta == 0))
    xdot(3) = -Cdrag_m * (x(3))^2 - g * sin_theta;
    xdot(4) = -g * cos_theta / x(3);

elseif (norris == 1)        % Use the "norris" system
    % The magnitude of the velocity of the projectile with respect to air
    vpa = sqrt((x(3) * cos_theta - alpha)^2 + (x(3) * sin_theta - beta)^2);
    
    xdot(3) = -Cdrag_m * vpa * ...
        (x(3) - alpha * cos_theta - beta * sin_theta) - ...
        g * sin_theta;
    xdot(4) = -(Cdrag_m / x(3)) * vpa * ...
        (alpha * sin_theta - beta * cos_theta) - ...
        g * cos_theta / x(3);

else                        % Use the system derived by the authors
    % The square of the magnitude of the velocity of the projectile with 
    % respect to the air
    vpa_2 = (x(3) * cos_theta - alpha)^2 + (x(3) * sin_theta - beta)^2;
    % Gamma is the angle between the velocity of the projectile with 
    % respect to the origin and the velocity of the projectile with 
    % respect to the air.
    gamma = atan2((x(3) * sin_theta - beta), ...
        (x(3) * cos_theta - alpha)) - x(4);
    
    xdot(3) = -Cdrag_m * vpa_2 * cos(gamma) - g * sin_theta;
    xdot(4) = -(Cdrag_m * vpa_2 / x(3)) * sin(gamma) - ...
        g * cos_theta / x(3);
end

%--------------------------------------------------------------------------
% Return results as a column vector
%--------------------------------------------------------------------------
xdot = xdot';

