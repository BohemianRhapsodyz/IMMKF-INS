function y = cumint(x, h, order)
% Cumulative integral of elements using trapezoidal integral method.

% Prototype: y = cumint(x, h, order)
% Inputs: x - element sequence
%         h - integral step
%         order - integral method
% Output: y - integral output
%
% Example:
%     ts = pi/10;  t = (0:ts:2*pi)';
%     x = sin(t);
%     figure, plot([cumint(x,ts,0), cumint(x,ts,1), cumint(x,ts,2), cumint(x,ts,3), 1-cos(t)]); grid on

% See also  sumn, cumsum.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 20/10/2013, 01/12/2014 
    if nargin<3, order = 1; end
    if nargin<2, h = 1;  end
    if order==0
        y = cumsum(x);
    elseif order==1
        y = cumtrapz(x);
%         b = [1; 1]/2;
%         y = filter(b,1, [x]);
%         y = cumsum(y(1:end));
    elseif order==2  % Simpson integral
        b = [1; 4; 1]/6;
        y = filter(b,1, [x(1,:); x]);
        y = cumsum(y(2:end,:));
    elseif order==3
        b = [1; 3; 3; 1]/8;
        y = filter(b,1, [x(1,:); x(1,:); x]);
        y = cumsum(y(3:end,:));
    end
    y = y*h;

