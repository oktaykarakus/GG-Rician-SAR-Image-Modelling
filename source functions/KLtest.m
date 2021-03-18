function KLdivVal = KLtest(dist1, dist2, margin)
%% Code for calculating KL divergence between two distributions.
%
% INPUTS:
%       ** dist1    : 1st Distribution (pdf)
%       ** dist2    : 2nd Distribution (pdf)
%       ** margin   : Margin value for logarithm. 
%
% OUTPUTS:
%       ** KLdivVal : The resulting KL divergence value.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LICENSE
% 
% This program is free software: you can redistribute it and/or modify it under the terms
% of the GNU General Public License as published by the Free Software Foundation, either 
% version 3 of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program.
% If not, see <https://www.gnu.org/licenses/>.
% 
% Copyright © Oktay Karakus,PhD 
% o.karakus@bristol.ac.uk
% University of Bristol, UK
% June, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REFERENCE
%
% [1] O Karakus, E Kuruoglu and A Achim. "A Generalized Gaussian Extension to the Rician
%       Distribution for SAR Image Modeling."
%       arXiv preprint, arXiv:2006.08300, 2020.
%
% [2] O Karakus, E Kuruoglu and A Achim. "Modelling Sea Clutter In SAR Images Using 
%       Laplace-Rician Distribution," ICASSP 2020 - 2020 IEEE International Conference
%       on Acoustics, Speech and Signal Processing (ICASSP), Barcelona, Spain, 2020,
%       pp. 1454-1458." 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if nargin == 2
    margin = 0.001;
end
dist1 = dist1./sum(dist1);
dist2 = dist2./sum(dist2);
KLdivVal = sum(dist1.*log2(dist1 + margin) - dist1.*log2(dist2 + margin));

