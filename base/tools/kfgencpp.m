function kfgencpp(classname, Ft, Hk)
% 快速滤波计算法：根据矩阵Ft和Hk的非零元素直接展开，生成C++语言程序，参见我的文章:
%   "A rapid computation method for Kalman filtering in vehicular SINS/GPS integrated system"
% 滤波模型：dXt/dt = Ft*Xt+Qt, Zk = Hk*Xk+Rk
%   Ft--连续时间系统的一步转移矩阵, Hk--量测矩阵, Qt--系统噪声（要求对角阵）, Rk--量测噪声（要求对角阵）
% 注意：Pk可始终保持为三角阵，不需对称化
% 例子：
%     [Ft,Hk] = nzFtHk(15);
%     kfgencpp('KFRapid', Ft, Hk);
%
% See also  nzFtHk.
% 26/4/2015, 30/7/2017

    [M,N] = size(Hk);
    Pk = randn(N);  Pk = Pk*Pk';
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%% C++头文件 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sh = sprintf('%s.h', classname);
    fid = fopen(sh, 'wt');
    fprintf(fid, '#ifndef _%s_h\n',classname);
    fprintf(fid, '#define _%s_h\n\n',classname);
    fprintf(fid, 'class C%s\n{\npublic:\n\tint n, m;\n', classname);
    fprintf(fid, '\tdouble Ft[%d*%d], Hk[%d*%d], Qt[%d], FBTau[%d], FBXk[%d], Rk[%d], Xk[%d], Pk[%d*%d], Pmin[%d], Zk[%d], chi2;\n', N,N, M,N, N, N, N, M, N, N,N, N, M);
    fprintf(fid, '\tdouble Rmax[%d], Rmin[%d], fRmax, fRmin, b, beta, fading;\n\n', M,M);
    % constructor
    fprintf(fid, '\tC%s(void);\n', classname);
    % Ft, Hk
    fprintf(fid, '\tvoid SetFt(CSINS& sins);\n');
    fprintf(fid, '\tvoid SetHk(CSINS& sins);\n');
    % Qt
    fprintf(fid, '\tvoid SetQt(');
    for k=0:N-2, fprintf(fid, 'double q%d, ', k); end
    fprintf(fid, 'double q%d);\n', N-1);
    % Pk
    fprintf(fid, '\tvoid SetPk(');
    for k=0:N-2, fprintf(fid, 'double p%d, ', k); end
    fprintf(fid, 'double p%d);\n', N-1);
    % Pmin
    fprintf(fid, '\tvoid SetPmin(');
    for k=0:N-2, fprintf(fid, 'double p%d, ', k); end
    fprintf(fid, 'double p%d);\n', N-1);
    % FBTau
    fprintf(fid, '\tvoid SetFBTau(');
    for k=0:N-2, fprintf(fid, 'double f%d, ', k); end
    fprintf(fid, 'double f%d);\n', N-1);
    % Rk, Zk
    fprintf(fid, '\tvoid SetRk(');
    for k=0:M-2, fprintf(fid, 'double r%d, ', k); end
    fprintf(fid, 'double r%d);\n', M-1);
    fprintf(fid, '\tvoid SetZk(');
    for k=0:M-2, fprintf(fid, 'double z%d, ', k); end
    fprintf(fid, 'double z%d);\n', M-1);
    % TimeUpdate
    fprintf(fid, '\tvoid TimeUpdate(double Ts);\n');
    % MeasUpdate
    fprintf(fid, '\tdouble MeasUpdate(double zweight=1.0);\n');
    % Feedback
    fprintf(fid, '\tvoid Feedback(double ts);\n');
    fprintf(fid, '};\n\n#endif\n');
    fclose(fid);
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%% C++源程序 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    scpp = sprintf('%s.cpp', classname);
    fid = fopen(scpp,'wt');
    fprintf(fid, '#include "PSINS.h"\n');
    fprintf(fid, '#include "%s.h"\n\n', classname);
    fprintf(fid, '#define  N        %d\n', N);
    fprintf(fid, '#define  M        %d\n', M);
    fprintf(fid, '#define  Ft(i,j)  Ft[(i)*N+(j)]\n');
    fprintf(fid, '#define  Fk(i,j)  Fk[(i)*N+(j)]\n');
    fprintf(fid, '#define  Hk(i,j)  Hk[(i)*N+(j)]\n');
    fprintf(fid, '#define  Pk(i,j)  Pk[(i)*N+(j)]\n');
    fprintf(fid, '#define  Bk(i,j)  Bk[(i)*N+(j)]\n');
    fprintf(fid, '\n');
    %% constructor
    fprintf(fid, 'C%s::C%s(void)\n{\n', classname, classname);
    fprintf(fid, '\tn = N, m = M;\n');
    fprintf(fid, '\tmemset(Ft, 0, N*N*sizeof(double));\n');
    fprintf(fid, '\tmemset(Hk, 0, M*N*sizeof(double));\n');
    fprintf(fid, '\tmemset(Xk, 0, N*sizeof(double));\n');
    fprintf(fid, '\tmemset(Pmin, 0, N*sizeof(double));\n');
    fprintf(fid, '\tmemset(FBTau, 0, N*sizeof(double));\n');
    fprintf(fid, '\tfRmax =100.0, fRmin = 0.01, b = 0.9, beta = 1.0, fading = 1.0;\n');
    fprintf(fid, '}\n\n');
    %% Ft
    fprintf(fid, '/*void C%s::SetFt(CSINS& sins)\n{\n\t//TODO: add your program requires here\n}\n\n', classname);
    %% Hk
    fprintf(fid, 'void C%s::SetHk(CSINS& sins)\n{\n\t//TODO: add your program requires here\n}*/\n\n', classname);
    %% Pk
    fprintf(fid, 'void C%s::SetPk(', classname);
    for k=0:N-2, fprintf(fid, 'double p%d, ', k); end
    fprintf(fid, 'double p%d)\n{\n', N-1);
    fprintf(fid, '\tmemset(Pk, 0, N*N*sizeof(double));\n\t');
    for k=0:N-1, fprintf(fid, 'Pk(%d,%d)=p%d*p%d; ', k, k, k, k); end
    fprintf(fid, '\n}\n\n');
    %% Pmin
    fprintf(fid, 'void C%s::SetPmin(', classname);
    for k=0:N-2, fprintf(fid, 'double p%d, ', k); end
    fprintf(fid, 'double p%d)\n{\n\t', N-1);
    for k=0:N-1, fprintf(fid, 'Pmin[%d]=p%d*p%d; ', k, k, k); end
    fprintf(fid, '\n}\n\n');
    %% FBTau
    fprintf(fid, 'void C%s::SetFBTau(', classname);
    for k=0:N-2, fprintf(fid, 'double f%d, ', k); end
    fprintf(fid, 'double f%d)\n{\n\t', N-1);
    for k=0:N-1, fprintf(fid, 'FBTau[%d]=f%d; ', k, k); end
    fprintf(fid, '\n}\n\n');
    %% Qt
    fprintf(fid, 'void C%s::SetQt(', classname);
    for k=0:N-2, fprintf(fid, 'double q%d, ', k); end
    fprintf(fid, 'double q%d)\n{\n\t', N-1);
    for k=0:N-1, fprintf(fid, 'Qt[%d]=q%d*q%d; ', k, k, k); end
    fprintf(fid, '\n}\n\n');
    %% Rk
    fprintf(fid, 'void C%s::SetRk(', classname);
    for k=0:M-2, fprintf(fid, 'double r%d, ', k); end
    fprintf(fid, 'double r%d)\n{\n\t', M-1);
    for k=0:M-1, fprintf(fid, 'Rk[%d]=r%d*r%d; ', k, k, k); end
    fprintf(fid, '\n\tfor(int i=0; i<m; i++) { Rmax[i]=fRmax*Rk[i]; Rmin[i]=fRmin*Rk[i]; }');
    fprintf(fid, '\n}\n\n');
    %% Zk
    fprintf(fid, 'void C%s::SetZk(', classname);
    for k=0:M-2, fprintf(fid, 'double z%d, ', k); end
    fprintf(fid, 'double z%d)\n{\n\t', M-1);
    for k=0:M-1, fprintf(fid, 'Zk[%d]=z%d; ', k, k); end
    fprintf(fid, '\n}\n\n');
    %% %%%%%%%%%%%%%%% time update
    op_mul = 0; op_add = 0; 
    fprintf(fid, 'void C%s::TimeUpdate(double Ts)\n{\n', classname);
    fprintf(fid, '\tdouble Fk[N*N], Bk[N*N], X1[N];\n');
    % Fk = Ft*Ts
    Fk = Ft*0.1;
    fprintf(fid, '\t//Fk = Ft*Ts\n'); 
    for m=1:N
        for n=1:N
            if Ft(m,n)~=0, fprintf(fid, '\tFk(%2d,%2d)=Ft(%2d,%2d)*Ts;', m-1,n-1,m-1,n-1); op_mul = op_mul+1; end
        end
        if sum(abs(Ft(m,:)))>0,  fprintf(fid, '\n'); end
    end
    nz = op_mul;
    % Bk = Fk*Pk
    Bk = Fk*Pk;
    fprintf(fid, '\t//Bk = Fk*Pk\n'); 
    for m=1:N          
        for n=1:N
            if sum(abs(Fk(m,:)))==0, continue; end
            fprintf(fid, '\tBk(%2d,%2d)=', m-1,n-1); % Bk(m,n)=
            addfirst = 1;
            for k=1:N
                if Ft(m,k)~=0,
                    if addfirst==1,  addfirst = 0;
                        if k>n, fprintf(fid, 'Fk(%2d,%2d)*Pk(%2d,%2d)', m-1,k-1,n-1,k-1);  % 如行>列，改用Pk的上三角
                        else    fprintf(fid, 'Fk(%2d,%2d)*Pk(%2d,%2d)', m-1,k-1,k-1,n-1); end
                    else
                        if k>n, fprintf(fid, '+Fk(%2d,%2d)*Pk(%2d,%2d)', m-1,k-1,n-1,k-1);
                        else    fprintf(fid, '+Fk(%2d,%2d)*Pk(%2d,%2d)', m-1,k-1,k-1,n-1); end
                    end
                    op_mul = op_mul+1;
                end
            end
%            if sum(abs(Fk(m,:)))==0, fprintf(fid, '0.0'); end
            fprintf(fid, ';\n');
        end
    end
    % Pk = (I+Fk)*Pk*(I+Fk)' = Pk + Bk + Bk' + Bk*Fk'
    fprintf(fid, '\t//Pk = (I+Fk)*Pk*(I+Fk)\'' = Pk + Bk + Bk\'' + Bk*Fk\''\n'); 
    Pk = randn(N,N); Bk = Fk*Pk;
    for m=1:N    % 只需计算Pk的上三角
        for n=m:N 
            no0 = 0; % 统计非零元素
            if Bk(m,n)~=0||Bk(n,m)~=0, no0=1; end
            for k=1:N
                if Bk(m,k)~=0 && Fk(n,k)~=0,  no0=1; break; end
            end
            if no0==0, continue; end
            fprintf(fid, '\tPk(%2d,%2d)+=', m-1,n-1);
            if Bk(m,n)~=0, fprintf(fid, 'Bk(%2d,%2d)', m-1,n-1); op_add = op_add+1; end
            if Bk(n,m)~=0, fprintf(fid, '+Bk(%2d,%2d)', n-1,m-1); op_add = op_add+1; end
            for k=1:N
                if Bk(m,k)~=0 && Fk(n,k)~=0,  fprintf(fid, '+Bk(%2d,%2d)*Fk(%2d,%2d)', m-1,k-1,n-1,k-1);  op_add = op_add+1; op_mul = op_mul+1;  end
            end 
            fprintf(fid, ';\n');
        end
    end
    % Pk = Pk + Qt*Ts
    fprintf(fid, '\t//Pk = Pk + Qt*Ts\n'); 
    fprintf(fid, '\t'); 
    for m=1:N, fprintf(fid, 'Pk(%d,%d)+=Qt[%d]*Ts; ', m-1,m-1, m-1); op_add = op_add+1; end
    fprintf(fid, '\n');
    % Xk = (I+Ft)*Xk
    fprintf(fid, '\t//Xk = (I+Fk)*Xk\n'); 
    for m=1:N
        fprintf(fid, '\tX1[%2d]=Xk[%2d]', m-1,m-1);
        for n=1:N
            if Ft(m,n)~=0    fprintf(fid, '+Fk(%2d,%2d)*Xk[%2d]', m-1,n-1,n-1); op_mul = op_mul+1;  end
        end
        fprintf(fid, ';\n');
    end
    fprintf(fid, '\tmemcpy(Xk, X1, N*sizeof(double));\n');
    fprintf(fid, '\t//Ft nonzero elements=%d, op_mul+=%d, op_add+=%d;\n}\n\n', nz, op_mul, op_add);
	%% %%%%%%%%%%%%%%% measure update
    % %%%%%sub measurement update function: SubMUpdt
    op_mul = 0; op_add = 0;
    fprintf(fid, 'static void SubMUpdt(double *Xk, double *Pk, double *Pxz, double Pzz, double r)\n{\n'); 
    fprintf(fid, '\tdouble Kk[N];\n');
    % Kk = Pxz*Pzz^-1
    fprintf(fid, '\t//Kk = Pxz*Pzz^-1\n'); 
    for m=1:N, fprintf(fid, '\tKk[%2d]=Pxz[%2d]/Pzz;', m-1, m-1); op_mul = op_mul+1;  end
    fprintf(fid, '\n'); 
    % Xk = Xk + Kk*Inno;
    fprintf(fid, '\t//Xk = Xk + Kk*r\n'); 
    for m=1:N, fprintf(fid, '\tXk[%2d]+=Kk[%2d]*r;', m-1, m-1); op_add = op_add+1; op_mul = op_mul+1; end
    fprintf(fid, '\n'); 
    % Pk = Pk - Kk*Pxz';
    fprintf(fid, '\t//Pk = Pk - Kk*Pxz\''\n'); 
    for m=1:N    % 只需计算Pk的上三角
        fprintf(fid, '\t');
        for n=m:N
            fprintf(fid, 'Pk(%2d,%2d)-=Kk[%2d]*Pxz[%2d]; ', m-1,n-1, m-1, n-1); 
            op_add = op_add+1; op_mul = op_mul+1;
        end
        fprintf(fid, '\n');
    end
    fprintf(fid, '}\n\n');
    op_add = op_add*M; op_mul = op_mul*M;
    % %%%%%%%%%%
    fprintf(fid, 'double C%s::MeasUpdate(double zweight)\n{\n', classname);
    fprintf(fid, '\tdouble Pxz[N], *Hi, Pzz, r, Pz0, rr;\n');
    fprintf(fid, '\tif(zweight<0.5)\n\t\treturn -1.0;\n');
    fprintf(fid, '\tzweight = zweight*zweight;\n');
    fprintf(fid, '\tHi=Hk, chi2=0.0;\n');
    for i=1:M
        Hi = Hk(i,:);  
        % Pxz = Pk*Hk'
        fprintf(fid, '\tif(Zk[%2d]>EPS||Zk[%2d]<-EPS)\n\t{\n',i-1,i-1); 
        fprintf(fid, '\t\t//Pxz = Pk*Hk(%d,:)\''\n',i-1); 
        for m=1:N           
            fprintf(fid, '\t\tPxz[%2d]=', m-1); 
            for n=1:N
                if Hi(n)==1, op_add = op_add+1;
                    if m>n, fprintf(fid, '+Pk(%2d,%2d)', n-1,m-1);  % 只利用Pk上三角元素
                    else    fprintf(fid, '+Pk(%2d,%2d)', m-1,n-1); end
                elseif Hi(n)==-1, op_add = op_add+1;
                    if m>n, fprintf(fid, '-Pk(%2d,%2d)', n-1,m-1);
                    else    fprintf(fid, '-Pk(%2d,%2d)', m-1,n-1); end
                elseif Hi(n)~=0,  op_mul = op_mul+1; op_add = op_add+1;
                    if m>n, fprintf(fid, '+Pk(%2d,%2d)*Hi[%2d]', n-1,m-1,n-1);
                    else    fprintf(fid, '+Pk(%2d,%2d)*Hi[%2d]', m-1,n-1,n-1); end
                end
            end 
            fprintf(fid, ';\n');
        end
        % Pzz = Hk*Pxz + Ri
        fprintf(fid, '\t\t//Pzz = Hk(%d,:)*Pxz + Rk[%d]\n',i-1,i-1); 
        fprintf(fid, '\t\tPz0=');
        for m=1:N
            if Hi(m)==1,      fprintf(fid, '+Pxz[%2d]', m-1); op_add = op_add+1;
            elseif Hi(m)==-1, fprintf(fid, '-Pxz[%2d]', m-1); op_add = op_add+1;
            elseif Hi(m)~=0,  fprintf(fid, '+Hi[%2d]*Pxz[%2d]', m-1, m-1); op_mul = op_mul+1;
            end
        end
        fprintf(fid, ';\n');
        % Inno = Zk - Hk*Xk
        fprintf(fid, '\t\t//Innovation = Zk(%d) - Hk(%d,:)*Xk\n',i-1,i-1); 
        fprintf(fid, '\t\tr=Zk[%2d]',i-1);
        for m=1:N
            if Hi(m)==1,      fprintf(fid, '-Xk[%2d]', m-1); op_add = op_add+1;
            elseif Hi(m)==-1, fprintf(fid, '+Xk[%2d]', m-1); op_add = op_add+1;
            elseif Hi(m)~=0,  fprintf(fid, '-Hi[%2d]*Xk[%2d]', m-1, m-1); op_mul = op_mul+1;
            end
        end
        fprintf(fid, ';\n');
        fprintf(fid, '\t\t//Adaptive KF\n');
        fprintf(fid, '\t\trr = r*r-Pz0;\n');
        fprintf(fid, '\t\tif(rr<Rmin[%d]) rr = Rmin[%d];\n', i-1, i-1);
        fprintf(fid, '\t\tif(rr>Rmax[%d]) Rk[%d] = Rmax[%d];\n', i-1, i-1, i-1);
        fprintf(fid, '\t\telse Rk[%d] = (1.0-beta)*Rk[%d]+beta*rr;\n', i-1, i-1);        
        fprintf(fid, '\t\tPzz = Pz0+Rk[%d]*zweight;\n', i-1); op_mul = op_mul+1;
        fprintf(fid, '\t\tSubMUpdt(Xk, Pk, Pxz, Pzz, r);\n');
        fprintf(fid, '\t\tchi2+=r/Pzz*r;\n');
        fprintf(fid, '\t}\n');
        if i<M
            fprintf(fid, '\tHi += N;\n');
        end
    end
	fprintf(fid, '\tbeta = beta/(beta+b);\n');        
    fprintf(fid, '\t//fading\n\tdouble *p=Pk, *pEnd=p+N*N, *p0;\n\tif(fading>1.0){ for(;p<pEnd;p++){*p*=fading;} }\n');  op_mul = op_mul+n*n;
    fprintf(fid, '\t//Pk min constrain\n\tfor(p0=Pmin,p=Pk;p<pEnd;p0++,p+=N+1){ if(*p<*p0) *p=*p0; }\n');  op_mul = op_mul+n;
    fprintf(fid, '\treturn chi2;\n\t//op_mul+=%d, op_add+=%d;\n}\n', op_mul, op_add);
    %% %%%%%%%%%%%%%%% feedback
    fprintf(fid, '\nvoid C%s::Feedback(double ts)\n{\n', classname);
    fprintf(fid, '\tfor(double *p0=FBXk,*pt=FBTau,*px=Xk,*pxEnd=px+N; px<pxEnd; p0++,pt++,px++)\n\t{ if(*pt>36000) *p0=0.0; else if(*pt<ts) {*p0=*px;*px=0.0;} else {*p0=ts/(*pt)*(*px);*px-=*p0;} }\n');
    fprintf(fid, '}\n');

    fclose(fid);
