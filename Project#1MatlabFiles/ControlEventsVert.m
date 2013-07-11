% File: ControlEventsVert
%
% The funciton file ControlEventsVert is used to determine when
% ode45 should stop integrating the system of differential equations
% for a target at (0, yT) when there is no horizontal component to
% the wind.  Generally speaking, ode45 should stop when the projectile
% path is at its minimum distance to the target.  However, if a vertical
% target is out of range and there is no horizontal component to the wind,
% the dot product will never be zero.  Consequently, this control
% includes an additional stopping condition to guard against this
% boundary condition.
%
% WARNING: This function should only be used when xT is 0 and the
% horizontal component of the wind is 0.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1


function [value, stopInteg, direction] = ControlEventsVert( ~, x )

global xT;          % x-coordinate of target
global yT;          % y-coordinate of target

value(1) = cos(x(4)) * (xT - x(1)) + sin(x(4)) * (yT - x(2));
stopInteg(1) = 1;        % Stop integrating if value(1) has a 0
direction(1) = 0;

value(2) = x(2);        % Stop when the y value is 0 on the way down
stopInteg(2) = 1;       % Stop integrating if value(2) has a 0
direction(2) = -1;      % Only stop on the way back down


