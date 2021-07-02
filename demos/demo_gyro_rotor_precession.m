% Gyro rotor procession simulation.
% See also  demo_scull_motion, demo_cone_motion.
% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 28/09/2015
function demo_gyro_rotor_precession
    Jx = 0.1*0.01^2;  % kg*m^2
    Jy = 1*Jx; Jz = Jy; J = [Jx; Jy; Jz];
    f = 1; Omega = 2*pi*f;
    My = 1e-6*9.8*1; % N*m       Please try to modify My and see result...
    Mx = 0; Mz = 0; M = [Mx;My;Mz];
    ts = 1/f/100;  T = 10;
    afa = (0:pi/20:2*pi)'; cir = 0.5*[0*afa, sin(afa), cos(afa)]; lin = [1,0,0; -1,0,0];
    w = zeros(3,1); len = fix(T/ts); wk = zeros(len,3); vec = wk;  Cnb = eye(3);
    hfig = figure;
    for k=1:len
        w1 = rk4(w, J, Omega, M, ts);
        Cnb = mupdt(Cnb, (w+w1)*ts/2);
        cir1 = cir*Cnb'; lin1 = lin*Cnb'; vec(k,:) = lin1(1,:);
        if ~ishandle(hfig),  break;  end
        clf(hfig);  hold off;
        plot3(cir1(:,1),cir1(:,2),cir1(:,3), 'linewidth',5); hold on, 
        plot3(lin1(:,1),lin1(:,2),lin1(:,3), vec(1:k,1),vec(1:k,2),vec(1:k,3), 'linewidth',2);
        plot3(lin1(1,1),lin1(1,2),lin1(1,3),'ms','linewidth',2);
        xlim([-1,1]); ylim([-1,1]); zlim([-1,1]); view([1 1 0.3]); grid on;
        pause(0.001);
        wk(k,:) = w1';
        w = w1;
    end
%     figure, plot((1:len)*ts, wk); grid on

function w1 = rk4(w, J, Omega, M, ts)
	k1 = rk(w, J, Omega, M);
	k2 = rk(w+ts/2*k1, J, Omega, M);
	k3 = rk(w+ts/2*k2, J, Omega, M);
	k4 = rk(w+ts*k3, J, Omega, M);
	w1 = w+ts/6.*(k1+2*(k2+k3)+k4);

function ki = rk(w, J, Omega, M)
    Jww = [ (J(3)-J(2))*w(2)*w(3);
            (J(1)-J(3))*w(1)*w(3)+J(1)*Omega*w(3);
            (J(2)-J(1))*w(2)*w(1)-J(1)*Omega*w(2) ];
    ki = (M-Jww)./J;
