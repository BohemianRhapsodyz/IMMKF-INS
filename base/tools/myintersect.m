function [t, i1, i0] = myintersect(t1, t0, tolerance)
    if nargin<3, tolerance = 1e-6; end
    t1 = fix(t1/tolerance);
    t0 = fix(t0/tolerance);
    [t, i1, i0] = intersect(t1, t0);
    t = t*tolerance;