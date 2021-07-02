function [avperr, i1, i0] = avpcmp(avp1, avp0, eb_db_Etc0)
% avp comparison can be denoted as 'avpErr=avp1-[avp0,eb_db_Etc0]'.
%
% Prototype: avperr = avpcmp(avp1, avp0, eb_db_Etc0)
% Inputs: avp1 - avp to be compared, may not just limit to [att;vel;pos]
%         avp0 - reference avp
%         eb_db_Etc0 - other reference parameters, so reference 
%              becomes [avp0, eb_db_Etc0]
% Outputs: avperr - error result
%
% See also  avpcmpplot, avpadderr, insupdate, inserrplot.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 10/10/2013, 17/09/2014
    [m,n] = size(avp0);
    if m==1 || n==1
        avp0 = avp0(:)';  % convert to row vector
        avp0 = [repmat(avp0,length(avp1),1), avp1(:,end)];
    end
    [t, i1, i0] = intersect(round(avp1(:,end)*1e4), round(avp0(:,end)*1e4)); t = t/1e4;
    avp1 = avp1(i1,1:end-1); avp0 = avp0(i0,1:end-1);
    dn = size(avp1,2) - size(avp0,2);
    if dn>0
        if ~exist('eb_db_Etc0', 'var')
            eb_db_Etc0 = zeros(1,dn);
        end
        if size(eb_db_Etc0,1)==1
            eb_db_Etc0 = repmat(eb_db_Etc0,length(t),1);
        end
        avp0 = [avp0,eb_db_Etc0];
    end
    avperr = [avp1-avp0,t];
    avperr(:,1:3) = aa2phi(avp1(:,1:3), avp0(:,1:3));
    %% some specific processing
    if ~exist('eb_db_Etc0', 'var'), eb_db_Etc0 = 0; end
    if strcmp(eb_db_Etc0, 'noatt')==1
    	avperr(:,1:3) = avp1(:,1:3) - avp0(:,1:3);
    elseif strcmp(eb_db_Etc0, 'mu')==1
    	avperr(:,1:3) = aa2mu(avp1(:,1:3), avp0(:,1:3));
    end

