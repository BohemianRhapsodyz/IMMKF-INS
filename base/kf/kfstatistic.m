function kfs = kfstatistic(kfs, kf, flag)
% See also  kfupdate
global glv
    if nargin==1
        if isfield(kfs, 'Qk')  % kfs = kfstatistic(kf)
            kf = kfs; kfs = [];
            kfs.Ak0 = eye(kf.n);
            kfs.P0 = kf.Pxk;  kfs.Pk = kf.Pxk; kfs.kfPk = kf.Pxk;
            for k=1:kf.n, kfs.Qjk{k} = zeros(kf.n); end
            for k=1:kf.m, kfs.Rsk{k} = zeros(kf.n); end
        else  % pqr = kfstat(kfs)
            n = length(kfs.P0); m = length(kfs.Rsk);
            p = zeros(n); q = zeros(n); r = zeros(n,m);
            kfs.Pk0 = kfs.Ak0*kfs.P0*kfs.Ak0';
            for ll=1:n
                Pkll = 1;%kfs.Pk(ll,ll)+eps;
                for jj=1:n
                    p(ll,jj) = kfs.Ak0(ll,jj)*kfs.P0(jj,jj)*kfs.Ak0(ll,jj)/Pkll;
                    q(ll,jj) = kfs.Qjk{jj}(ll,ll)/Pkll;
                end
                for ss=1:m
                    r(ll,ss) = kfs.Rsk{ss}(ll,ll)/Pkll;
                end
            end
            pqr = sqrt([p, q, r]);  kfs.pqr = pqr;
            myfigure,
            subplot(321), bar(pqr(1:3,:)'/glv.min); grid on
            subplot(322), bar(pqr(4:6,:)'); grid on
            subplot(323), bar([pqr(7:8,:)'*glv.Re,pqr(9,:)']); grid on
            subplot(324), bar(pqr(10:12,:)'/glv.dph); grid on
            subplot(325), bar(pqr(13:15,:)'/glv.ug); grid on
            subplot(326), bar(pqr(16:18,:)'); grid on
        end
    elseif nargin>=2,  % kfs = kfstat(kfs, kf, 'B/T/M')
        if nargin==2, flag='B'; end
        if flag=='B',    Phikk_1=kf.Phikk_1; Qk=kf.Qk;       Kk=kf.Kk;            
        elseif flag=='T' Phikk_1=kf.Phikk_1; Qk=kf.Qk;       Kk=zeros(kf.n,kf.m); 
        elseif flag=='M' Phikk_1=eye(kf.n);  Qk=zeros(kf.n); Kk=kf.Kk;            end
        Bkk_1 = eye(kf.n)-Kk*kf.Hk; Akk_1 = Bkk_1*Phikk_1;
        kfs.Ak0 = Akk_1*kfs.Ak0;
        kfs.Pk = kfs.Ak0*kfs.P0*kfs.Ak0';
        for j=1:kf.n
            kfs.Qjk{j} = Akk_1*kfs.Qjk{j}*Akk_1' + Qk(j,j)*Bkk_1(:,j)*Bkk_1(:,j)';
            kfs.Pk = kfs.Pk + kfs.Qjk{j};
        end
        for s=1:kf.m
            kfs.Rsk{s} = Akk_1*kfs.Rsk{s}*Akk_1' + kf.Rk(s,s)*Kk(:,s)*Kk(:,s)';
            kfs.Pk = kfs.Pk + kfs.Rsk{s};
        end
        kfs.kfPk = Bkk_1*(Phikk_1*kfs.kfPk*Phikk_1'+Qk)*Bkk_1'+Kk*kf.Rk*Kk';
        kfs.kf = kf;
    end
    