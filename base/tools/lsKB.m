function [K, B] = lsKB(Y, X)
% Result for Y(k,1:3)' = K*X(k,1:3)'+B, where K is 3X3 & B is 3X1;

    kk = size(Y,1);
    O13 = zeros(1,3);
    for k=1:kk
        xk = X(k,1:3);
        A(3*k-2:3*k,:) = [[xk O13 O13; O13 xk O13; O13 O13 xk], eye(3)];
        y(3*k-2:3*k,1) = Y(k,1:3)';
    end
    b = lscov(A, y);
    K = [b(1:3)'; b(4:6)'; b(7:9)'];
    B = b(10:12);