function coef = wm2wtcoef(ts, n, N)
% Determine the transform matrix form angular increment to angular rate.
%
% Prototype: coef = wm2wtcoef(ts, n, N)
% Inputs: ts - sample interval
%         n - current sub-sample number
%         N - total sub-sample number, then p=N-n is previous sub-sample
%             nmuber
% Output: coef - angular rate coefficient matrix, such that wt = wm'*coef
%
% See also  qpicard, dcmtaylor.

% Copyright(c) 2009-2017, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 04/02/2017
    if nargin<3, N = n; end
    G = zeros(N); p = N - n;
    for k=1:N
        k1 = N-k+1;
        for j=(-p+1):n
            G(k,j+p) = ((j*ts)^k1-((j-1)*ts)^k1) / k1;
        end
    end
    coef = G^-1;

     if N==3&&n==3
        coef = [ 
            [ 1/(2*ts^3), -2/ts^2, 11/(6*ts)]
            [    -1/ts^3,  3/ts^2, -7/(6*ts)]
            [ 1/(2*ts^3), -1/ts^2,  1/(3*ts)]
        ];
     elseif N==4&&n==4
        coef = [ 
            [ -1/(6*ts^4),   5/(4*ts^3), -35/(12*ts^2),  25/(12*ts)]
            [  1/(2*ts^4), -13/(4*ts^3),   23/(4*ts^2), -23/(12*ts)]
            [ -1/(2*ts^4),  11/(4*ts^3),  -15/(4*ts^2),  13/(12*ts)]
            [  1/(6*ts^4),  -3/(4*ts^3),  11/(12*ts^2),   -1/(4*ts)]
        ];
    elseif N==5&&n==5
        coef = [ 
            [ 1/(24*ts^5), -1/(2*ts^4),  17/(8*ts^3),  -15/(4*ts^2),  137/(60*ts)]
            [ -1/(6*ts^5), 11/(6*ts^4), -27/(4*ts^3), 109/(12*ts^2), -163/(60*ts)]
            [  1/(4*ts^5), -5/(2*ts^4),       8/ts^3,  -35/(4*ts^2),  137/(60*ts)]
            [ -1/(6*ts^5),  3/(2*ts^4), -17/(4*ts^3),   17/(4*ts^2),  -21/(20*ts)]
            [ 1/(24*ts^5), -1/(3*ts^4),   7/(8*ts^3),   -5/(6*ts^2),     1/(5*ts)]
        ];
    elseif N==6&&n==6
        coef = [ 
            [ -1/(120*ts^6),   7/(48*ts^5), -35/(36*ts^4),   49/(16*ts^3), -203/(45*ts^2),   49/(20*ts)]
            [   1/(24*ts^6), -11/(16*ts^5), 151/(36*ts^4), -183/(16*ts^3),   116/(9*ts^2),  -71/(20*ts)]
            [  -1/(12*ts^6),  31/(24*ts^5),  -65/(9*ts^4),   139/(8*ts^3), -589/(36*ts^2),   79/(20*ts)]
            [   1/(12*ts^6), -29/(24*ts^5),   56/(9*ts^4),  -109/(8*ts^3),  427/(36*ts^2), -163/(60*ts)]
            [  -1/(24*ts^6),   9/(16*ts^5), -97/(36*ts^4),   89/(16*ts^3), -167/(36*ts^2),   31/(30*ts)]
            [  1/(120*ts^6),  -5/(48*ts^5),  17/(36*ts^4),  -15/(16*ts^3), 137/(180*ts^2),    -1/(6*ts)]
        ];
    end
 