% Sculling error simulation.
% See also  demo_scull_motion, demo_cone_error, demo_cone_motion.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 03/04/2012, 28/03/2014
clear all
glvs
Ae = 10.0*glv.deg;  Ap = 1;       % angular & linear amplitude
f = 1.0;  w = 2*pi*f;             % frequency
[nn, ts, nts] = nnts(2, 0.01);    % subsamples & sampling interval
T = 6;                            % simulation time
[wvm, avp] = scullsimu(Ae, Ap, f, ts, T);  
q0 = a2qua(avp(1,1:3)'); v0 = avp(1,4:6)'; p0 = avp(1,7:9)';
len = length(wvm); res = zeros(fix(len/nn), 18); ki = 1;
for k=1:nn:len-nn+1
    k1 = k+nn-1;
	wvmi = wvm(k:k1, :);
    [phim, dvbm] = cnscl(wvmi,0);
    v1 = v0 + qmulv(q0, dvbm); % velocity updating before attitude !
    p0 = p0 + (v0+v1)*nts/2; v0 = v1;
	q0 = qmul(q0, rv2q(phim));
	res(ki,:) = [q2att(q0); v0; p0; avp(k1+1,:)']';  ki = ki+1;
end
t = (1:size(res,1))'*nts;
[dV, scullm] = sculldrift(nn, ts, Ae, Ap, f);
err = res(:,1:9) - res(:,10:18);
myfigure;
subplot(331), plot((1:size(wvm,1))*ts,wvm(:,5)/ts/9.8), xygo('fby / g');
subplot(332), plot((1:size(wvm,1))*ts,wvm(:,6)/ts/9.8), xygo('fbz / g');
subplot(334), plot(t,res(:,[5,14])), xygo('Vny / m/s');
subplot(335), plot(t,res(:,[6,15])), xygo('Vnz / m/s');
legend('Calculated velocity', 'Reference velocity');
subplot(337), plot(t,res(:,[8,17])), xygo('Pny / m');
subplot(338), plot(t,res(:,[9,18])), xygo('Pnz / m');
legend('Calculated position', 'Reference position');
subplot(333), plot(t,res(:,1)/glv.deg), xygo('p');
subplot(336), plot(t,scullm*t), xygo('sculling noncommutativity drift / m/s');
subplot(339), plot(t,[err(:,6),t*dV(1),t*dV(2)]), xygo('dVz / m/s');
legend('Sculling compensation drift', ...
    'Theoretical drift 1', 'Theoretical drift 2', 'Location','best');
