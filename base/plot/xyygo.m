function xyygo(ax, xtext, ytext1, ytext2)
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
    if nargin==3 % xygo(ytext)
        ytext2 = ytext1;
        ytext1 = xtext;
        xtext = '\itt \rm / s';
    end
	xlabel(labeldef(xtext));
    set(get(ax(1),'Ylabel'), 'String', labeldef(ytext1));
    set(get(ax(2),'Ylabel'), 'String', labeldef(ytext2));
    grid on;  hold on;
