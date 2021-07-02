function [inst, kod] = drcalibrate(pos0, pos1Real, pos1DR, distance)
% Dead Reckoning(DR) parameter calibration for 'inst'&'kod'.
%
% Prototype: dr = drcalibrate(pos0, pos1Real, pos1DR)
% Inputs: pos0 - start position
%         pos1Real - real end position
%         pos1Real - DR end position
%         distance - driving distance from pos0 to pos1
% Output: inst - ints=[dpitch;0;dyaw] for OD installation error angles(in rad)
%         kod - odometer scale factor in meter/pulse.
%
% See also  drinit, drupdate.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 12/05/2017
    eth = earth(pos0);
    dpos = pos1Real - pos0;  xyzReal = [dpos(2)*eth.clRNh; dpos(1)*eth.RMh; dpos(3)];
    dpos = pos1DR - pos0;    xyzDR   = [dpos(2)*eth.clRNh; dpos(1)*eth.RMh; dpos(3)];
    if nargin<4,  distance = norm(xyzReal);  end
    kod = norm(xyzReal) / norm(xyzDR);
    dpitch = (xyzDR(3) - xyzReal(3)) / distance;
    dyaw = cross([xyzReal(1:2);0]/norm(xyzReal(1:2)), [xyzDR(1:2);0]/norm(xyzDR(1:2))); dyaw = dyaw(3);
    inst = [dpitch; 0; dyaw];
