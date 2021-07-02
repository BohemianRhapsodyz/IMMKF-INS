function [s, r] = txtextract(infile, outfile, frq_istart, iend)
    exefile = 'G:\高精度对准16\preprocess\Debug\preprocess.exe';
    if nargin<4, 
        frq = frq_istart;
        str = sprintf('%s %s %s %d', exefile, infile, outfile, frq);
    elseif nargin==4,
        istart = frq_istart;
        str = sprintf('%s %s %s %d %d', exefile, infile, outfile, istart, iend);
    end
    [s, r] = dos(str);
    