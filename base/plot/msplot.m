function msplot(mnp, x, y, xstr, ystr)
% my sub plot
    if mod(mnp,10)==1, figure; end   % ����ǵ�һ��Сͼ�����½�һ��figure
    subplot(mnp); plot(x, y, 'linewidth', 2); grid on;
    if nargin==4, ystr = xstr; xstr = '\itt\rm / s'; end  % ���ֻ����һ���ַ�������Ĭ��xlabelΪʱ��
    if exist('ystr', 'var'), xlabel(xstr); ylabel(ystr); end