function ang = angle2c(ang)
% See also att2c.
    df = diff(ang);    % find discontinuous points
    g = find(df>pi);   % greater than pi
    s = find(df<-pi);  % smaller than -pi
    for k=1:length(g)
        ang(g(k)+1:end) = ang(g(k)+1:end) - 2*pi;
    end
    for k=1:length(s)
        ang(s(k)+1:end) = ang(s(k)+1:end) + 2*pi;
    end
