function krm = rmpsinspath
% Remove PSINS path from search path.

% Copyright(c) 2009-2015, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 31/01/2015
    pp = [';',path,';'];
    kpsins = strfind(pp, 'psins');
    ksemicolon = strfind(pp, ';');
    krm = length(kpsins);
    for k=1:krm
        k1 = find(ksemicolon<kpsins(k),1,'last');
        k2 = find(kpsins(k)<ksemicolon,1,'first');
        pk = pp(ksemicolon(k1)+1:ksemicolon(k2)-1);
        rmpath(pk);
    end