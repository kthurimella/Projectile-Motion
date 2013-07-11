% File: TestTarget
%
% TestTarget is a script file to test the Target function
% It displays where the target is located, and the compnonents
% of the wind. It also displays the firing angle, in radians, 
% that hits the target. Finally, it displays the elapsed time 
% to find the firing angle.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1

clear
close all

% Boolean used to set which system of equations is used
global norris;
norris = 0;

coord = [500, 930];            % coordinates of the target
wind = [-100, 0];              % components for the wind

% display results
disp(horzcat('Target is at (', num2str(coord(1)), ', ',...
    num2str(coord(2)), ')', ...
    ' and wind is (', num2str(wind(1)), ', ', num2str(wind(2)), ')'))

tic                             % start timing
for I = 1:1
    angle = Target(coord, wind);    % find the firing angle
end

fprintf('The returned angle is %6.4f radians.\n', angle)
toc                             % stop timing
