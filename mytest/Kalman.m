function [X,P,e,S]=Kalman(X_Forward,P_Forward,Z,A,G,Q,H,R)
% Predict
X_Pre=A*X_Forward;
P_Pre=A*P_Forward*A'+G*Q*G';

K=P_Pre*H'*inv(H*P_Pre*H'+R)';  % Gain matrix
    
e = Z-H*(A*X_Forward);
S=H*P_Pre*H'+R; 

% Modification
X=A*X_Forward+K*(Z-H*(A*X_Forward));

M=K*H;
n=size(M);
I=eye(n);
P=(I-K*H)*P_Pre*(I-K*H)'+ K*R*K';
