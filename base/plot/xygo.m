function xygo(xtext, ytext)
% Xlable 'xtext', Ylabel 'ytext' & Grid On
%
% Prototype: xygo(xtext, ytext)
% Inputs: xtext, ytext - text labels to show in figure x-axis & y-axis, 
%             but if nargin==1, then the xtext will show in y-axis  
%             with time label shown defaultly in x-axis.
%
% See also  labeldef.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/02/2014
    if nargin==1 % xygo(ytext)
        ytext = xtext;
        xtext = '\itt \rm / s';
    end
	xlabel(labeldef(xtext));
    ylabel(labeldef(ytext));
    grid on;  hold on;
