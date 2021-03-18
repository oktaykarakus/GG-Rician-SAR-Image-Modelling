function [dsData, dsKL, dsSize] = dsSARImage(dsTargetSize, oneDImage)
%% Code for down-sampling full-size SAR image.
%
% INPUTS:
%       ** dsTargetSize     : Downsampling target sample size.
%       ** oneDImage        : Sorted 1D full-size SAR data.
%
% OUTPUTS:
%       ** dsData           : Down-sampled data.
%       ** dsKL             : KL-divergence value between the full-size SAR
%          Image and DSInput. 
%       ** dsSize           : Final down-sampled data size.
%
% OTHER:
%       ** TargetKL         : Target KL-divergence value between the full-size SAR
%          Image and DSInput. Method keeps increasing dsSize until dsKL
%          reaches TargetKL value. Set to 1e-3. Can be replaced with other
%          value if needed.
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
dsKL = 1;
targetKL = 1e-3;
while dsKL > targetKL
    temp = round(length(oneDImage)/dsTargetSize);
    dsData = [oneDImage(1:temp:end); oneDImage(end)];
    t2 = oneDImage;
    t2 = t2(t2 < 255);
    Bins = calcnbins(t2, 'sturges');
    [aa2, ~] = hist(t2, Bins);
    aa2 = aa2./sum(aa2);
    
    t1 = dsData;
    t1 = t1(t1 < 255);
    [vals, ~] = hist(t1, Bins);
    vals = vals./sum(vals);
    
    dsKL = KLtest(vals, aa2);
    if dsKL > targetKL
        dsTargetSize = dsTargetSize + 500;
        dsKL = 1;
    end
end
dsSize = dsTargetSize;