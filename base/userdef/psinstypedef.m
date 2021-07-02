function psinstypedef(typestr, kffk, kfhk, kfplot)
% PSINS type define (typedef). To shorten or simplify the main 
% program, especially for kalman filter intergated progarmming, 
% users may add their specific kftypestr here, and then add corresponding 
% code in these user-defined functions: kfinit, kffk, kfhk and kfplot.
%
% Prototype: psinstypedef(typestr)
% Inputs: typestr - PSINS type string (or kfinit), which will be used as 
%             identifier in other PSINS related routines.
%         kffk, kfhk, kfplot - related indicators
%
% See also  kfinit, kffk, kfhk, kfplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 05/10/2013, 02/02/2015
global psinsdef
    psinsdef = [];
    %% tags
    psinsdef.kfinittag = 1;
    psinsdef.kffktag = 2;
    psinsdef.kfhktag = 3;
    psinsdef.kfplottag = 4;
    %% kfinit
    psinsdef.kfinit93 = 93;
    psinsdef.kfinit96 = 96;
    psinsdef.kfinit152 = 152;
    psinsdef.kfinit153 = 153;
    psinsdef.kfinit156 = 156;
    psinsdef.kfinit183 = 183;
    psinsdef.kfinit186 = 186;
    psinsdef.kfinit193 = 193;
    psinsdef.kfinit196 = 196;
    psinsdef.kfinit343 = 343;
    psinsdef.kfinit346 = 346;
    psinsdef.kfinit373 = 373;
    psinsdef.kfinit376 = 376;
    %% kffk
    psinsdef.kffk9 = 9;
    psinsdef.kffk15 = 15;
    psinsdef.kffk18 = 18;
    psinsdef.kffk19 = 19;
    psinsdef.kffk34 = 34;
    psinsdef.kffk37 = 37;
    %% kfhk
    psinsdef.kfhk93 = 93;
    psinsdef.kfhk96 = 96;
    psinsdef.kfhk152 = 152;
    psinsdef.kfhk153 = 153;
    psinsdef.kfhk156 = 156;
    psinsdef.kfhk183 = 183;
    psinsdef.kfhk186 = 186;
    psinsdef.kfhk193 = 193;
    psinsdef.kfhk196 = 196;
    psinsdef.kfhk343 = 343;
    psinsdef.kfhk346 = 346;
    psinsdef.kfhk373 = 373;
    psinsdef.kfhk376 = 376;
    %% kfplot
    psinsdef.kfplot9 = 9;
    psinsdef.kfplot15 = 15;
    psinsdef.kfplot18 = 18;
    psinsdef.kfplot19 = 19;
    psinsdef.kfplot34 = 34;
    psinsdef.kfplot37 = 37;
    %%
    psinsdef.kfinit = 0;
    if ischar(typestr)
        psinsdef.typestr = typestr;
        psinsdef.kffk = 0;
        psinsdef.kfhk = 0;
        psinsdef.kfplot = 0;
    else
        psinsdef.kfinit = typestr;
        psinsdef.kffk = fix(psinsdef.kfinit/10);
        psinsdef.kfhk = psinsdef.kfinit;
        psinsdef.kfplot = psinsdef.kffk;
    end
    if exist('kffk', 'var'), psinsdef.kffk = kffk; end
    if exist('kfhk', 'var'), psinsdef.kfhk = kfhk; end
    if exist('kfplot', 'var'), psinsdef.kfplot = kfplot; end

