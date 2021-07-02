% SINS/GPS(and/or UWB) intergrated navigation simulation using imm-kalman filter.
glvs
psinstypedef(153);
trj = trjfile('trj10ms.mat');
% initial settings
[nn, ts, nts] = nnts(4, trj.ts);
imuerr = imuerrset(25.2, 200, 2, 333);   %ADIS16405 IMU Parameter
imu = imuadderr(trj.imu, imuerr);
davp0 = avpseterr([30;-30;20], 0.05, [0.5;0.5;0.5]);
ins = insinit(avpadderr(trj.avp0,davp0), ts);  ins.nts = nts;               ins0=ins;
% KF filter
rk = posseterr([1;1;1]);
kf = kfinit(ins, davp0, imuerr, rk);
kf1 = kfinit(ins, davp0, imuerr, rk);
kf2 = kfinit(ins, davp0, imuerr, 0.3*rk);
kf.Pmin = diag(kf.Pxk)*0; kf.Pmin(15) = (10*glv.ug)^2;
kf.Pmax = diag(kf.Pxk)*10000; % kf.pconstrain = 1;
len = length(imu); [avp, xkpk] = prealloc(len, 10, 2*kf.n+1);
% timebar(nn, len, '15-state SINS/GPS Simulation.'); 
ki = 1;
tbstep = floor(len/nn/100); tbi = timebar(1, 99, 'SINS/GPS Simulation.');
profile on

%%%%%%%%%IMM Initialization%%%%%%%%
simTime=fix(len/4);      
x0=kf.xk;                  % Initial state
x1_IMM = zeros(15,1);      % State estimation of the 1st model
x2_IMM = zeros(15,1);      % State estimation of the 2nd model
x_pro_IMM = zeros(15,simTime);   % Hybrid estimation of IMM
P_IMM=zeros(15,15,simTime);      % Hybrid covariance matrix P of IMM
P1_IMM=zeros(15,15);             % Covariance matrix P of the 1st model
P2_IMM=zeros(15,15);             % Covariance matrix P of the 2nd model
r1_IMM=zeros(3,1);
r2_IMM=zeros(3,1);
S1_IMM=zeros(3,3);
S2_IMM=zeros(3,3);

x_pro_IMM(:,1)=x0;

pij=[0.95,0.05;
     0.05,0.95];    %transition probability matrix (TPM)

u_IMM=zeros(2,simTime);
u_IMM(:,1)=[0.5,0.5]';  %IMM algorithm model probability

x1_IMM=x0;x2_IMM=x0;  %Initial state for each model

P0=kf.Pxk;  %Initial covariance matrix

P1_IMM=P0;P2_IMM=P0;

P_IMM(:,:,1)=P0;

%%%%%%%%Loop%%%%%%%
for k=1:nn:len-nn+1
    k1 = k+nn-1;  
    wvm = imu(k:k1,1:6);  t = imu(k1,end);
    ins = insupdate(ins, wvm);

%     kf.Pxk(10:12,13:15) = 0; kf.Pxk(13:15,10:12) = 0;

   if t<80   %First stage. Measurement noise covariance = Rk1
       
    %1-->Interacting
    c_j=pij'*u_IMM(:,ki);
    
    ui1=(1/c_j(1))*pij(:,1).*u_IMM(:,ki);
    ui2=(1/c_j(2))*pij(:,2).*u_IMM(:,ki);    %Calculate model hybrid probability
    
    x01=x1_IMM*ui1(1)+x2_IMM*ui1(2);
    x02=x1_IMM*ui2(1)+x2_IMM*ui2(2);  
    
    P01=(P1_IMM+[x1_IMM-x01]*[x1_IMM-x01]')*ui1(1)+...
        (P2_IMM+[x2_IMM-x01]*[x2_IMM-x01]')*ui1(2);
    P02=(P1_IMM+[x1_IMM-x02]*[x1_IMM-x02]')*ui2(1)+...
        (P2_IMM+[x2_IMM-x02]*[x2_IMM-x02]')*ui2(2);
    %2-->Kalman filter
    kf.Phikk_1 = kffk(ins);    
    kf1.Phikk_1 = kffk(ins);
    kf2.Phikk_1 = kffk(ins);
    kf = kfupdate(kf);
    kf1 = kfupdate(kf1);
    kf2 = kfupdate(kf2);
        posGPS = trj.avp(k1,7:9)' + 0.8*posseterr([1;1;1]).*randn(3,1);  % GPS pos simulation with some white noise
        posUWB = trj.avp(k1,7:9)' + 10*posseterr([0.3;0.3;0.3]).*randn(3,1);  %uwb pos simulation with some white noise. Just same as GPS
        kf1 = kfupdate(kf1, ins.pos-posGPS, 'M');
        kf2 = kfupdate(kf2, ins.pos-posUWB, 'M');
    x1_IMM=kf1.xk;
    P1_IMM=kf1.Pxk;
    r1_IMM=kf1.rk;
    S1_IMM=kf1.Pykk_1;
    x2_IMM=kf2.xk;
    P2_IMM=kf2.Pxk;
    r2_IMM=kf2.rk;
    S2_IMM=kf2.Pykk_1;
    %3-->Model probability update
    [u_IMM(:,ki+1)]=Model_P_up(r1_IMM,r2_IMM,S1_IMM,S2_IMM,c_j);
    %4-->Model integrated
    [x_pro_IMM(:,ki+1),P_IMM(:,:,ki+1)]=Model_mix(x1_IMM,x2_IMM,P1_IMM,P2_IMM,u_IMM(:,ki));
     %%%%%%%%%%%%%%%%%
%         kf1.xk=x_pro_IMM(:,ki+1);  
%         kf2.xk=x_pro_IMM(:,ki+1);  
         kf.xk=x_pro_IMM(:,ki+1);
         kf.Pxk=P_IMM(:,:,ki+1);
         ins0=ins;
        [kf, ins0] = kffeedback(kf, ins0, 0.01, 'vp');
        avp(ki,:) = [ins0.avp', t];
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';  ki = ki+1;             
   end
   
   if (t>=80)&&(t<160)   %Second stage. Measurement noise covariance = Rk2
       
    %1-->Interacting
    c_j=pij'*u_IMM(:,ki);
    
    ui1=(1/c_j(1))*pij(:,1).*u_IMM(:,ki);
    ui2=(1/c_j(2))*pij(:,2).*u_IMM(:,ki);    %Calculate model hybrid probability
    
    x01=x1_IMM*ui1(1)+x2_IMM*ui1(2);
    x02=x1_IMM*ui2(1)+x2_IMM*ui2(2);  
    
    P01=(P1_IMM+[x1_IMM-x01]*[x1_IMM-x01]')*ui1(1)+...
        (P2_IMM+[x2_IMM-x01]*[x2_IMM-x01]')*ui1(2);
    P02=(P1_IMM+[x1_IMM-x02]*[x1_IMM-x02]')*ui2(1)+...
        (P2_IMM+[x2_IMM-x02]*[x2_IMM-x02]')*ui2(2);
    %2-->Kalman filter
    kf.Phikk_1 = kffk(ins);    
    kf1.Phikk_1 = kffk(ins);
    kf2.Phikk_1 = kffk(ins);
    kf = kfupdate(kf);
    kf1 = kfupdate(kf1);
    kf2 = kfupdate(kf2);  
        posGPS = trj.avp(k1,7:9)' + 0.8*posseterr([1;1;1]).*randn(3,1);  % GPS pos simulation with some white noise
        posUWB = trj.avp(k1,7:9)' + 1.2*posseterr([0.3;0.3;0.3]).*randn(3,1);  % uwb pos simulation with some white noise. Just same as GPS
        kf1 = kfupdate(kf1, ins.pos-posGPS, 'M');
        kf2 = kfupdate(kf2, ins.pos-posUWB, 'M');
    x1_IMM=kf1.xk;
    P1_IMM=kf1.Pxk;
    r1_IMM=kf1.rk;
    S1_IMM=kf1.Pykk_1;
    x2_IMM=kf2.xk;
    P2_IMM=kf2.Pxk;
    r2_IMM=kf2.rk;
    S2_IMM=kf2.Pykk_1;
    %3-->Model probability update
    [u_IMM(:,ki+1)]=Model_P_up(r1_IMM,r2_IMM,S1_IMM,S2_IMM,c_j);
    %4-->Model integrated
    [x_pro_IMM(:,ki+1),P_IMM(:,:,ki+1)]=Model_mix(x1_IMM,x2_IMM,P1_IMM,P2_IMM,u_IMM(:,ki));
%         kf1.xk=x_pro_IMM(:,ki+1);  
%         kf2.xk=x_pro_IMM(:,ki+1);  
         kf.xk=x_pro_IMM(:,ki+1);
         kf.Pxk=P_IMM(:,:,ki+1);
         ins0=ins;
        [kf, ins0] = kffeedback(kf, ins0, 0.01, 'vp');
        avp(ki,:) = [ins0.avp', t];
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';  ki = ki+1;
   end 
   
   if t>=160   %Third stage. Measurement noise covariance = Rk3
       
    %1-->Interacting
    c_j=pij'*u_IMM(:,ki);
    
    ui1=(1/c_j(1))*pij(:,1).*u_IMM(:,ki);
    ui2=(1/c_j(2))*pij(:,2).*u_IMM(:,ki);    %Calculate model hybrid probability
    
    x01=x1_IMM*ui1(1)+x2_IMM*ui1(2);
    x02=x1_IMM*ui2(1)+x2_IMM*ui2(2);  
    
    P01=(P1_IMM+[x1_IMM-x01]*[x1_IMM-x01]')*ui1(1)+...
        (P2_IMM+[x2_IMM-x01]*[x2_IMM-x01]')*ui1(2);
    P02=(P1_IMM+[x1_IMM-x02]*[x1_IMM-x02]')*ui2(1)+...
        (P2_IMM+[x2_IMM-x02]*[x2_IMM-x02]')*ui2(2);
    %2-->Kalman filter
    kf.Phikk_1 = kffk(ins);    
    kf1.Phikk_1 = kffk(ins);
    kf2.Phikk_1 = kffk(ins);
    kf = kfupdate(kf);
    kf1 = kfupdate(kf1);
    kf2 = kfupdate(kf2);  
        posGPS = trj.avp(k1,7:9)' + 10*posseterr([1;1;1]).*randn(3,1);  % GPS pos simulation with some white noise
        posUWB = trj.avp(k1,7:9)' + 1.2*posseterr([0.3;0.3;0.3]).*randn(3,1);  % uwb pos simulation with some white noise. Just same as GPS
        kf1 = kfupdate(kf1, ins.pos-posGPS, 'M');
        kf2 = kfupdate(kf2, ins.pos-posUWB, 'M');
    x1_IMM=kf1.xk;
    P1_IMM=kf1.Pxk;
    r1_IMM=kf1.rk;
    S1_IMM=kf1.Pykk_1;
    x2_IMM=kf2.xk;
    P2_IMM=kf2.Pxk;
    r2_IMM=kf2.rk;
    S2_IMM=kf2.Pykk_1;
    %3-->Model probability update
    [u_IMM(:,ki+1)]=Model_P_up(r1_IMM,r2_IMM,S1_IMM,S2_IMM,c_j);
    %4-->Model integrated
    [x_pro_IMM(:,ki+1),P_IMM(:,:,ki+1)]=Model_mix(x1_IMM,x2_IMM,P1_IMM,P2_IMM,u_IMM(:,ki));
%         kf1.xk=x_pro_IMM(:,ki+1);  
%         kf2.xk=x_pro_IMM(:,ki+1);  
         kf.xk=x_pro_IMM(:,ki+1);
         kf.Pxk=P_IMM(:,:,ki+1);
         ins0=ins;
        [kf, ins0] = kffeedback(kf, ins0, 0.01, 'vp');
        avp(ki,:) = [ins0.avp', t];
        xkpk(ki,:) = [kf.xk; diag(kf.Pxk); t]';  ki = ki+1;
    end      
%     timebar;
    if mod(tbi,tbstep)==0, timebar; end;  tbi = tbi+1;
end
profile viewer
% show results
avperr = avpcmp(avp, trj.avp);
inserrplot(avperr);

m=1:ki;
figure(5);
plot(m,u_IMM(1,m),'k:',m,u_IMM(2,m),'r-.','LineWidth',2);grid on
title('IMM algorithm model probability curves');
xlabel('t/s'); ylabel('Model probability');
legend('Model-1','Model-2');