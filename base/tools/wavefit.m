function [A, w, phi, b1, b0, data1] = wavefit(data, ts)
% Waveform fitting for model: 'x(t)=A*sin(w*t+phi)+b'.
%
% Prototype: [A, w, phi, wdf] = wff(data)
% Input: data - data to be fitted.
% Outputs: A,w,phi - waveform amplitude, frequency(in rad/s), init phase
%          wdf - waveform distortion factor
% Example:
%   t = (0:0.01:10)';
%   x = 1*sin(6*t+0.1)+0.2*t+0.3 + randn(size(t))*0.01;
%   [A, w, phi, b1, b0] = wavefit([t,x]);
%   [A, w, phi, b1, b0]'
%
% See also:  N/A.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/09/2014
    [m,n] = size(data);
    if n==2,  
        t=data(:,1); data = data(:,2);
    else
        t=(1:m)';  
        if nargin==2, t=t*ts; end
    end
    ts = t(2)-t(1); ws = 2*pi/ts;
    b = mean(data); data = data-b;  % zero mean
    ff = fft(data, m)/m;
    [mm,I] = max(abs(ff));  
    % figure, N=fix(length(ff)/2); semilogy((0:N-1)/ts/N/2,2*abs(ff(1:N))), grid on
    A = 2*mm; w = ws*(I-1)/m; phi = angle(ff(I))+pi/2;
    data_est = A*sin(w*t+phi);  % coarse fitting
    err = data-data_est;
    [~, A, w, phi, b1, b0] = lsfit(data, data_est, t, A, w, phi);  % least squre fitting
    data = data-b0; b = b+b0;
    data_est = A*sin(w*t+phi) + b1*(t-t(1));  data1 = [A*sin(w*t+phi), data_est, t];
    err1 = data-data_est;
    wdf = sqrt(err1'*(data+data_est)/(data'*data)); % waveform distortion factor
    figure,
    ax = plotyy(t, [data, data_est], t, [b1*(t-t(1)),err1]); grid on;
    xlabel('\itt / \rms');
    set(get(ax(1),'Ylabel'), 'String', sprintf('y (bias=%e, THD=%e%%)', b,wdf*100));
    set(get(ax(2),'Ylabel'), 'String', 'error');
    title(sprintf('y = (%e)*sin[(%e)*t+(%e)] + (%e)*t + (%e)', A,w,phi,b1,b0));
    legend('test data', 'fitting waveform', 'fitting linear error', 'fitting random error');
    
function [y, A, w, phi, b1, b0] = lsfit(y0, y, t, A, w, phi)
    tt = t-t(1);
    b1 = 0; b0 = 0;
    for k=1:5
        dy = y0-y;
        s = sin(w*t+phi);  Ac = A*cos(w*t+phi); Act = Ac.*t;
        AA = [s, Act, Ac, tt, ones(size(t))];
        x = lscov(AA, dy);
        [ST, U, Q, F] = SUQ(dy, AA*x, 4);
        A = A+x(1); w = w+x(2); phi = phi+x(3); b1 = b1+x(4); b0 = b0+x(5);
        y = A*sin(w*t+phi)+b1*tt+b0;
    end
    
function [ST, U, Q, F] = SUQ(yi, yihead, p)
    ST = sum((yi-mean(yi)).^2);
    U = sum((yihead-mean(yi)).^2);
    Q = sum((yi-yihead).^2);
    N = length(yi);
    F = U/p / (Q/(N-p-1));
