function ppdf = GGRicianIntPdf(x_range, Alpha, Delta, Gamma)
%% The function for calculating the pdf of GG-Rician intensity.
%  The GG-Rician probability density function for modeling an intensity signal is given below [1]
% 
% $$f_I(\nu|\alpha, \gamma, \delta) = \frac{\alpha^2 }{8\gamma^2\Gamma^2(\frac{1}{\alpha})} 
% \int_0^{2\pi} \exp\left(-\frac{|\sqrt{\nu}\cos\theta - \delta|^{\alpha} + |\sqrt{\nu}\sin\theta - \delta|^{\alpha}}{\gamma^{\alpha}} \right) d\theta$$
%
% INPUTS:
%       ** x_range      : Data values for calculating the pdf
%       ** Alpha        : Shape Parameter.
%       ** Delta        : Location parameter.
%       ** Gamma        : Scale parameter.
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
ppdf = zeros(size(x_range));
for i = 1:length(x_range)
    funTheta = @(theta) exp(-(1/(Gamma^Alpha))*(abs((x_range(i).^0.5).*cos(theta) - Delta).^Alpha + abs((x_range(i).^0.5).*sin(theta) - Delta).^Alpha));
    ppdf(i) = ((Alpha^2)/(8*(gamma(1/Alpha)^2)*(Gamma^2)))*integral(funTheta, 0, 2*pi);
end

