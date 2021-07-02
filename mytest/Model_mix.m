function [x_pro,P]=Model_mix(x1,x2,P1,P2,u)
x_pro=x1*u(1)+x2*u(2);
P=(P1+[x1-x_pro]*[x1-x_pro]')*u(1)+...
  (P2+[x2-x_pro]*[x2-x_pro]')*u(2);
