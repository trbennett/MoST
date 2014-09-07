function [entrop] = entrop( sig, sig_min, sig_max, bincnt)
%   Calculates the entropy for an input signal. 
%   The bincnt input is optional and can be overwritten.  11 is the default. 

if nargin < 2
   sig_max = max(sig);
   sig_min = min(sig);
   bincnt = 11;
elseif nargin < 4
    bincnt = 11;
end

win_size = length(sig);

% Set up the histograms for sig1 and sig2
binran = [sig_min:((sig_max + 1) - sig_min)/bincnt:sig_max + 1];

% Calculate the probabilities for sig
% The top histogram bin will always be empty (i.e. 0), so it is removed  
hist = histc(sig,binran);
hist(hist == 0) = []; 
prob = (hist/win_size);
    
% Calculate the entropy 
entrop = - sum(prob.*log2(prob)); 

end

