function performancePlotting(hFig)
%% Code for drawing final fitting results in a single figure window.
%
% INPUTS:
%       ** hFig             : A figure object which will be used to plot
%           final performance graphs.
% 
% OTHER:
%       ** Results          : A structure type variable which stores
%           performance and estimation variables.
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
global Parameters
global Output
global Results
alpha = Output.Shape_alpha; 
gamma = Output.Scale_gamma; 
delta = Output.Location_delta; 
family = Parameters.distType;
Data = Parameters.Image(:);
burnInIdx = (Parameters.burnInPeriod+1):Parameters.NumberofIterations;
EstAlpha = mean(alpha(burnInIdx));
EstGamma = mean(gamma(burnInIdx));
EstDelta = mean(delta(burnInIdx));

set(hFig, 'Position', [70, 50, 1300, 600])
subplot('Position', [0.60 0.55 0.37 0.4])
runningMeanLocation = cumsum(delta(burnInIdx))./(1:Parameters.burnInPeriod);
plot(delta, '.', 'MarkerSize', 12);
hold on
plot(burnInIdx, runningMeanLocation, 'LineWidth', 2);
plot(1:Parameters.NumberofIterations, EstDelta*ones(1, Parameters.NumberofIterations), 'm:', 'LineWidth', 2);
stem(Parameters.burnInPeriod, 1.1*max(delta), 'r-.', 'LineWidth', 2, 'Marker', 'none');
if family == 3
    plot(1:Parameters.NumberofIterations, Parameters.location*ones(1, Parameters.NumberofIterations), 'k--', 'LineWidth', 1.5);
    legend('Instantenous Estimates', 'Running Mean', 'Posterior Mean', 'Burn In', 'Correct Paremeter', 'location', 'eastoutside');
else
    legend('Instantenous Estimates', 'Running Mean', 'Posterior Mean', 'Burn In', 'location', 'northeastoutside');
end
xlabel('Iteration')
ylabel('Parameter Estimations')
title('\delta Estimates')
grid on
if Parameters.distType == 3
    ylim([0.9*min(min(delta), Parameters.location) 1.1*max(delta)])
else
    ylim([0.9*min(delta) 1.1*max(delta)])
end
subplot('Position', [0.32 0.55 0.23 0.4])
runningMeanScale = cumsum(gamma(burnInIdx))./(1:Parameters.burnInPeriod);
plot(gamma, '.', 'MarkerSize', 12);
hold on
plot(burnInIdx, runningMeanScale, 'LineWidth', 2);
plot(1:Parameters.NumberofIterations, EstGamma*ones(1, Parameters.NumberofIterations), 'm:', 'LineWidth', 2);
stem(Parameters.burnInPeriod, 1.1*max(gamma), 'r-.', 'LineWidth', 2, 'Marker', 'none');
if family == 3
    plot(1:Parameters.NumberofIterations, Parameters.scale*ones(1, Parameters.NumberofIterations), 'k--', 'LineWidth', 1.5);
end
xlabel('Iteration')
ylabel('Parameter Estimations')
title('\gamma Estimates')
grid on
if Parameters.distType == 3
    ylim([0.9*min(min(gamma), Parameters.scale) 1.1*max(gamma)])
else
    ylim([0.9*min(gamma) 1.1*max(gamma)])
end
subplot('Position', [0.05 0.55 0.23 0.4])           % Family Histogram
runningMeanShape = cumsum(alpha(burnInIdx))./(1:Parameters.burnInPeriod);
plot(alpha, '.', 'MarkerSize', 12);
hold on
plot(burnInIdx, runningMeanShape, 'LineWidth', 2);
plot(1:Parameters.NumberofIterations, EstAlpha*ones(1, Parameters.NumberofIterations), 'm:', 'LineWidth', 2);
stem(Parameters.burnInPeriod, 1.1*max(alpha), 'r-.', 'LineWidth', 2, 'Marker', 'none');
if family == 3
    plot(1:Parameters.NumberofIterations, Parameters.shape*ones(1, Parameters.NumberofIterations), 'k--', 'LineWidth', 1.5);
end
xlabel('Iteration')
ylabel('Parameter Estimations')
title('\alpha Estimates')
grid on
if Parameters.distType == 3
    ylim([0.9*min(min(alpha), Parameters.shape) 1.1*max(alpha)])
else
    ylim([0.9*min(alpha) 1.1*max(alpha)])
end

subplot('Position', [0.05 0.08 0.35 0.35])
Data2 = Data(Data < 255);
Bins = calcnbins(Data2, 'sturges');
[aa, bb] = hist(Data2, Bins);
aa = aa./sum(aa);
ppdf = genericPDFCalculation(family, EstGamma, EstAlpha, EstDelta, bb);
ppdf = ppdf./sum(ppdf);
semilogy(bb, aa, 'b+', 'Markersize', 6);
hold on
semilogy(bb, ppdf, 'r', 'Linewidth', 3)
xlabel('Data')
ylabel('Log-Scale Frequency')
hold off
xlim([min(bb)*0.9 max(bb)*1.1])
grid on
title({'\bf Log-Scale Density Estimate'}, 'Interpreter', 'latex')

subplot('Position', [0.46 0.08 0.35 0.35]);
bar(bb, aa, 'FaceColor', [0.5 0.5 0.5]);
hold on
plot(bb, ppdf, 'r', 'Linewidth', 3)
xlabel('Data')
ylabel('Frequency')
hold off
xlim([0 max(bb)*1.1])

title({'\bf Density Estimate'}, 'Interpreter', 'latex')
grid on

KLVal = KLtest(aa, ppdf);
KSVal = KSScore(aa, ppdf);

Labels = {'GG-Rician (A)', 'GG-Rician (I)', 'Synthetically Generated'};
subplot('Position', [0.82 0.08 0.25 0.35])
ax5 = gca;
cla(ax5)
text(0.13, 1,{'\bf Family: ', Labels{family}}, 'Interpreter', 'latex')
text(0.13,0.8, {'\bf $\alpha$ - Estimation', ['E[$\alpha$] = ' num2str(EstAlpha)]}, 'Interpreter', 'latex')
text(0.13, 0.6, {'\bf $\gamma$ - Estimation', ['E[$\gamma$] = ' num2str(EstGamma)]}, 'Interpreter', 'latex')
text(0.13,0.4,{'\bf $\delta$ - Estimation', ['E[$\delta$] = ' num2str(EstDelta)]}, 'Interpreter', 'latex')
text(0.13, 0.2, {'\bf Fitting Performance', ['$D_{KL}$= ' num2str(KLVal)]}, 'Interpreter', 'latex')
text(0.13, 0, {'\bf Fitting Performance', ['$D_{KS}$= ' num2str(KSVal)]}, 'Interpreter', 'latex')
set(ax5,'Visible','off')

Results.estDelta = EstDelta;
Results.estGamma = EstGamma;
Results.estAlpha = EstAlpha;
Results.KLdiv = KLVal;
Results.KSscore = KSVal;