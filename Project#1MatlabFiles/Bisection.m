% File: Bisection
%
% The function file Bisection is an interpolation algorithm
% that uses the envelope as well as the most recent results
% to determine the next firing angle. The algorithm uses the
% distances associated with the three angles to interpolate
% with the undershot angle and the given angle, as well as
% the overshot angle and the given angle. The average of the
% two interpolations is returned.
%
% Prior to interpolating, this function checks to determine
% whether or not it has sufficient information to ascertain 
% if the target can be reached. If so, the given angle is
% returned to notify the calling function that the target
% cannot be reached. 
%
% This function requires the envelope to be defined before
% it is called.
%
% Authors: Tyler DePriest, Scott Fiedler, Kumar Thurimella
% April 6, 2012
% APPM 3050, Project 1

function [nextAngle] = Bisection(theta, dist)

global uTheta;      % maximum undershot angle
global uDist;       % negative distance from target corresponding to uTheta
global oTheta;      % minimum overshot angle
global oDist;       % distance from target corresponding to oTheta

adist = abs(dist);
% The difference between the upper and lower bounds of the envelope
% used to determine if the target is out of range is dependent upon
% the given distance to the target.
if (adist < 1)
    angleTolerance = .000001;
elseif (adist < 10)
    angleTolerance = .00001;
elseif (adist < 100)
    angleTolerance = .005;
else
    angleTolerance = .1;
end

if ((oTheta - uTheta) < angleTolerance)
    % return the given angle if the target cannot be reached
    nextAngle = theta;
    return
end

% Interpolate from the left and the right 
if (dist < 0)
    nextTheta1 = uTheta + ...
        (uDist / (uDist - dist)) * (theta - uTheta);
    nextTheta2 = theta + ...
        (-dist / (oDist - dist)) * (oTheta - theta);
    
    % Reset the undershot angle and its corresponding distance
    uTheta = theta;
    uDist = dist;
else
    nextTheta1 = theta - ...
        (dist / (oDist - dist)) * (oTheta - theta);
    nextTheta2 = uTheta + ...
        (-uDist / (dist - uDist)) * (theta - uTheta);
    
    % Reset the overshot angle and its corresponding distance
    oTheta = theta;
    oDist = dist;
end

% Make sure the interpolation did not jump outside the envelope.
% If so, simply bisect the envelope.
if ((nextTheta1 >= oTheta) || (nextTheta1 <= uTheta))
    nextTheta1 = (oTheta + uTheta) / 2;
end
if ((nextTheta2 >= oTheta) || (nextTheta2 <= uTheta))
    nextTheta2 = (oTheta + uTheta) / 2;
end

% Return the average of the two interpolations    
nextAngle = (nextTheta1 + nextTheta2) / 2;


