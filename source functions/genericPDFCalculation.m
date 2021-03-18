function ppdf = genericPDFCalculation(dist, Gamma, Alpha, Delta, x_range)
%% The generic function for calculating the pdf of GG-Rician amplitude and intensity.
%
% INPUTS:
%       ** dist         : Refers to the type of simulation.
%                       1: GG-Rician Amplitude modelling of example SAR image.
%                       2: GG-Rician Intensity modelling of example SAR image.
%                       3: GG-Rician Amplitude modelling of synthetically generated data.
%       ** Gamma        : Scale parameter.
%       ** Alpha        : Shape Parameter.
%       ** Delta        : Location parameter.
%       ** x_range      : Data values for calculating the pdf.
%
% OUTPUTS:
%       ** ppdf         : The resulting pdf values.
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
if dist == 1 || dist == 3
    ppdf = GGRicianAmpPdf(x_range, Alpha, Delta, Gamma);
elseif dist == 2
    ppdf = GGRicianIntPdf(x_range, Alpha, Delta, Gamma);
end

