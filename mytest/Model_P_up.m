function [u]=Model_P_up(r1,r2,S1,S2,c_j) %Model probability update function

%Calculate likelihood function
Lfun1=(1/sqrt(abs(2*pi*(det(S1)))))*exp((-1/2)*(r1'*inv(S1)*r1));   
Lfun2=(1/sqrt(abs(2*pi*(det(S2)))))*exp((-1/2)*(r2'*inv(S2)*r2));   

%Normalization
Lfun11=Lfun1/(Lfun1+Lfun2);
Lfun21=Lfun2/(Lfun1+Lfun2);

% Calculate model update probability,multiply the model probability in last time
c=[Lfun11,Lfun21]*c_j;

% Normalization again
u=(1/c).*[Lfun11,Lfun21]'.*c_j;
