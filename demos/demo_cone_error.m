% Coning compensation error simulation.
% See also  demo_cone_motion, demo_scull_error, demo_scull_motion.
% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 30/10/2011, 28/03/2014
glvs
afa = 1.0*glv.deg;              % half-apex angle
f = 2;  w = 2*pi*f;             % frequency
[nn, ts, nts] = nnts(3, 0.01);  % subsamples & sampling interval
T = 6;                          % simulation time
[wm, qr] = conesimu(afa, f, ts, T);
len = length(wm); res = zeros(fix(len/nn), 9);
q1 = qr(1,:)'; q2 = q1; ki = 1;
for k=1:nn:len-nn+1
    k1 = k+nn-1;
	wmi = wm(k:k1, :);
	q0 = qr(k1+1,:)';
%     [phim, afam, betam] = conetwospeed(wmi);
	phim1 = cnscl(wmi, 1);  q1 = qmul(q1,rv2q(phim1)); % optimal method
    phim2 = cnscl(wmi, 0);  q2 = qmul(q2,rv2q(phim2)); % polynomial method
	res(ki,:) = [q2att(q0); qq2phi(q1,q0); qq2phi(q2,q0)]';  ki = ki+1;
end
t = (1:size(res,1))'*nts;
[ebx, dphim] = conedrift(nn, ts, afa, f); % coning drift error
myfigure;
subplot(321), plot(t,res(:,1)/glv.deg), xygo('p');
subplot(323), plot(t,res(:,2:3)/glv.deg), xygo('ry');
subplot(325), plot(t,dphim*t/glv.sec), xygo('coning noncommutativity drift / \prime\prime');
subplot(322), plot(t,res(:,[5,8])/glv.sec), xygo('\it\phi_x\rm / \prime\prime');
subplot(324), plot(t,res(:,[6,9])/glv.sec), xygo('\it\phi_y\rm / \prime\prime');
legend('Optimal attitude error', 'Ploynomial attitude error');
subplot(326), plot(t,res(:,[4,7])/glv.sec), xygo('\it\phi_z\rm / \prime\prime');
hold on, plot(t,t*ebx(1)/glv.sec, 'r--'); plot(t,ebx(2)*t/glv.sec, 'm:');
legend('Optimal compensation drift', 'Ploynomial compensation drift', ...
    'Theoretical drift 1', 'Theoretical drift 2', 'Location','best');