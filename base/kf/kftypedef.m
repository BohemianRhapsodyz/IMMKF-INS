function kftypedef(kftypestr)
% Kalman filter type define (kftypedef). To shorten or simplify the main 
% program, especially for kalman filter intergated progarmming, 
% user may add his specific kftypestr here, and then add corresponding 
% code in these functions: kfinit, kffk, kfhk and kfplot.
%
% Prototype: kftypedef(kftypestr)
% Input: kftypestr - Kalman filter type string, which will be used as 
%             identifier in other Kalman related routines.
%
% See also  kfinit, kffk, kfhk, kfplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/10/2013
    clear global kftype
    global kftype
    %%
    test_def = 100;
    kftype.test_GPS_SINS_tight     = test_def+1;
    kftype.test_SINS_DR            = test_def+21;
    kftype.test_SINS_GPS           = test_def+2;
    kftype.test_SINS_GPS_19        = test_def+3;
    kftype.test_SINS_GPS_18        = test_def+31;
    kftype.test_POS_fusion         = test_def+4;
    kftype.test_align_transfer     = test_def+5;
    kftype.test_align_ukf          = test_def+6;
    kftype.test_align_ekf          = test_def+7;
    %%
    user_def = 200;
    kftype.wangjun_ins_gps_19      = user_def+1;
    kftype.WangJun_POS_fusion_34   = user_def+2;
    kftype.leador_ins_od           = user_def+4;
    kftype.leador_ins_od_dt        = user_def+5;
    kftype.leador_POS_fusion_19    = user_def+7;
    kftype.leador_POS_fusion_34    = user_def+8;
    kftype.leador_MEMS_GPS_19      = user_def+9;
    kftype.test_SINS_DVL_19        = user_def+10;
    kftype.test_SINS_GPS_DVL_OC_20 = user_def+11;
    if ~isfield(kftype, kftypestr)
        kftype = setfield(kftype, kftypestr, user_def+1977);
        kftype.typename = kftypestr;
    end
    %%
    kftype.inittype = getfield(kftype, kftypestr);
    kftype.fktype = kftype.inittype;
    kftype.hktype = kftype.inittype;
    kftype.plottype = kftype.inittype;
    if isfield(kftype, 'typename')
        feval(kftype.typename, 'typedef');
    end

