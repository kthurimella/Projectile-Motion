% File: ControlEvents
%
% The function file ControlEvents is used to determine when
% ode45 should stop integrating the system of differential equations.
% Generally speaking, ode45 should stop when the projectile path is 
% at its minimum distance to the target. 
%
% The minimum distance occurs when the tangent to the projectile motion
% is perpendicular to the vector from the current location to the target.
% Use the dot product as the stopping condition for finding the minimal
% distance to the target. Note that it is possible that this condition
% might be met twice, once on the way up and once on the way down, but
% we are not interested in this solution. Consequently, it is okay to stop
% on the way up.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1


function [value, stopInteg, direction] = ControlEvents( ~, x )

global xT;          % x-coordinate of target
global yT;          % y-coordinate of target

value(1) = cos(x(4)) * (xT - x(1)) + sin(x(4)) * (yT - x(2));
stopInteg(1) = 1;         % Stop integrating if value(1) has a 0
direction(1) = 0;


