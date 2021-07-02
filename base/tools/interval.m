function vout = interval(vin, vminmax)
% Value reset within specific interval.
% 
% Prototype: vout = interval(vin, vminmax)
% Inputs: vin - value input
%         vminmax - specific interval [vmin, vmax]
% Output: vout - value output within interval [vmin, vmax]
%
% See also  N/A.

% Copyright(c) 2009-2018, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 21/01/2018   
    if length(vminmax)==1, vminmax = [-vminmax,vminmax]; end
    vout = vin;
    for k=1:length(vin)
        if     vin(k)<vminmax(1), vout(k) = vminmax(1);
        elseif vin(k)>vminmax(2), vout(k) = vminmax(2);  end
    end