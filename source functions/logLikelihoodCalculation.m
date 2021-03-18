function logLHDVal = logLikelihoodCalculation(x_range, Gamma, Alpha, Delta, dist)
%% The function for calculating the logarithm of likelihood function.
%
% INPUTS:
%       ** x_range      : Data values for calculating the pdf
%       ** Gamma        : Scale parameter.
%       ** Alpha        : Shape Parameter.
%       ** Delta        : Location parameter.
%       ** dist         : Refers to the type of simulation.
%                       1: GG-Rician Amplitude modelling of example SAR image.
%                       2: GG-Rician Intensity modelling of example SAR image.
%                       3: GG-Rician Amplitude modelling of synthetically generated data.
%
% OUTPUTS:
%       ** logLHDVal    : The resulting log-likelihood value.
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
ppdf = genericPDFCalculation(dist, Gamma, Alpha, Delta, x_range);
idx = not(or(ppdf <= 0, isnan(ppdf)));
logLHDVal = sum(log(ppdf(idx)));

