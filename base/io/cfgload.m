function [ins, kf, cfg] = cfgload(cfgfile, typestr)
% Parameter load from config file
global glv psinsdef
    %%
    fid = fopen(cfgfile, 'rt');
    cfg = []; idx0 = 10;
    for k=1:100
        str = fgetl(fid);
        if length(str)<5, continue; end
        if strcmp(str(1:5),'%#end'), break; end
        if str(1)=='%', continue; end
        equ = strfind(str, '=');
        if isempty(equ), continue; end
        bracket = strfind(str, '['); bracket1 = strfind(str, ']');
        if ~isempty(bracket)&&~isempty(bracket1)  % numeric value
                cfg = setfield(cfg, str(1:equ(1)-1), sscanf(str(bracket(1)+1:bracket1(1)-1), '%f', 3));
        else
            prime = strfind(str, '''');
            if length(prime)>=2  % string infomation
                cfg = setfield(cfg, str(1:equ(1)-1), str(prime(1)+1:prime(2)-1));
            end
        end
    end
    fclose(fid);
    cfg.fsimu = [cfg.dir,cfg.fsimu]; cfg.fgps = [cfg.dir,cfg.fgps]; cfg.fres = [cfg.dir,cfg.fres];
    cfg.att = cfg.att*glv.deg; cfg.pos = posset(cfg.pos);  % unit convention
    cfg.phi = cfg.phi*glv.min; cfg.dpos = posseterr(cfg.dpos);
    cfg.eb = cfg.eb*glv.dph; cfg.db = cfg.db*glv.ug;
    cfg.ebw = cfg.ebw*glv.dpsh; cfg.dbw = cfg.dbw*glv.ugpsHz;
    cfg.ebr = cfg.ebr*glv.dph; cfg.dbr = cfg.dbr*glv.ug;
    cfg.dkgii = cfg.dkgii*glv.ppm; cfg.dkaii = cfg.dkaii*glv.ppm;
    cfg.dkgij = cfg.dkgij*glv.sec; cfg.dkaij = cfg.dkaij*glv.sec;
    cfg.posw = posseterr(cfg.posw);
    %%
    [nn, ts, nts] = nnts(cfg.nnfs(1), 1/cfg.nnfs(2));
    ins = insinit([cfg.att;cfg.vn;cfg.pos], ts);  ins.tauG = cfg.ebtau; ins.tauA = cfg.dbtau;
    psinstypedef(typestr);
    psinsdef.kffk = 37; psinsdef.kfhk = 376; psinsdef.kfplot = 37;
    dKga = [cfg.dkgii(1),cfg.dkgij(1),cfg.dkgij(2), cfg.dkgij(1),cfg.dkgii(2),cfg.dkgij(3), cfg.dkgij(2),cfg.dkgij(3),cfg.dkgii(3),...
            cfg.dkaii(1),cfg.dkaij(1),cfg.dkaij(2), cfg.dkaii(2),cfg.dkaij(3),              cfg.dkaii(3)]';
    kf.Pxk = diag([cfg.phi;cfg.dvn;cfg.dpos; cfg.eb;cfg.db; cfg.lv; cfg.rsv1(1); dKga; cfg.dvn])^2;
	ebrw = cfg.ebr.*sqrt(2./cfg.ebtau); dbrw = cfg.dbr.*sqrt(2./cfg.dbtau);
	kf.Qt = diag([cfg.ebw; cfg.dbw; 0;0;0; ebrw; dbrw; zeros(22,1)])^2;
    kf.Rk = diag([cfg.vnw; cfg.posw])^2;
    kf.Hk = zeros(6, 37);
    kf.xtau = [cfg.fbatt; cfg.fbvn; cfg.fbpos; cfg.fbeb; cfg.fbdb; zeros(22,1)];
    kf = kfinit0(kf, nts);

