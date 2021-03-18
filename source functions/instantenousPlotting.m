function instantenousPlotting(hFig, iter)
%% Code for drawing various instantenous fitting results in a single figure window.
%
% INPUTS:
%       ** hFig             : A figure object which will be used to plot
%           graphs.
%       ** iter             : Current iteration value.
%
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

shape = Output.Shape_alpha; 
gamma = Output.Scale_gamma; 
delta = Output.Location_delta; 
family = Parameters.distType;
Data = Parameters.Data;
realIm = Parameters.noDSInput;

% For the first half of the iterations, we plot all samples. After that, we
% plot by applying Burn-In.
if iter > Parameters.NumberofIterations/2 
    idx2 = round(iter/2):iter;
else
    idx2 = 1:iter;
end

set(hFig, 'Position', [70, 50, 1400, 700])
subplot('Position', [0.53 0.55 0.2 0.4])
histogram(delta(idx2), 10, 'Normalization','probability');
title('\delta posterior')
ylabel('Probability')

subplot('Position', [0.29 0.55 0.2 0.4])
histogram(gamma(idx2), 10, 'Normalization','probability');
title('\gamma posterior')
ylabel('Probability')

subplot('Position', [0.05 0.55 0.2 0.4])           % Family Histogram
histogram(shape(idx2), 10, 'Normalization','probability');
title('\alpha posterior')
ylabel('Probability')

subplot('Position', [0.77 0.55 0.2 0.4])           % Family Histogram
if family == 3
    imshow(ones(100, 100)); % A dummy image instead of a SAR.
    text(20, 20, 'Synthetically', 'FontWeight', 'bold', 'Fontsize', 16)
    text(20, 30, 'Generated', 'FontWeight', 'bold', 'Fontsize', 16)
    text(20, 40, 'Sequence', 'FontWeight', 'bold', 'Fontsize', 16)
else
    imagesc(imresize(realIm, [500, 500]))
    colormap gray
    set(gca, 'XTickLabel', [], 'yTickLabel', [])
    if family == 1
        title('Amplitude SAR Image');
    elseif family == 2
        title('Intensity SAR Image');
    end
end

EstAlpha = mean(shape(idx2));
EstGamma = mean(gamma(idx2));
EstDelta = mean(delta(idx2));

subplot('Position', [0.2 0.08 0.35 0.35])
Data2 = Data(Data < 255);
[aa, bb] = hist(Data2, 30);
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

subplot('Position', [0.62 0.08 0.35 0.35]);
bar(bb, aa);
hold on
plot(bb, ppdf, 'r', 'Linewidth', 3)
xlabel('Data')
ylabel('Frequency')
hold off
xlim([min(bb)*0.9 max(bb)*1.1])
KLdist = KLtest(aa, ppdf);
title({'\bf Density Estimate'}, 'Interpreter', 'latex')
grid on

Labels = {'GG-Rician (A)', 'GG-Rician (I)', 'Synthetically Generated'};
subplot('Position', [0.02 0.08 0.15 0.35])
ax5 = gca;
cla(ax5)
text(0.13, 1,{'\bf Iteration', [num2str(iter) '/' num2str(length(delta))]}, 'Interpreter', 'latex')
text(0.13, 0.8,{'\bf Family: ', Labels{family}}, 'Interpreter', 'latex')
text(0.13,0.6, {'\bf $\alpha$ - Estimation', ['E[$\alpha$] = ' num2str(mean(shape(idx2)))]}, 'Interpreter', 'latex')
text(0.13, 0.4, {'\bf $\gamma$ - Estimation', ['E[$\gamma$] = ' num2str(mean(gamma(idx2)))]}, 'Interpreter', 'latex')
text(0.13,0.2,{'\bf $\delta$ - Estimation', ['E[$\delta$] = ' num2str(mean(delta(idx2)))]}, 'Interpreter', 'latex')
text(0.13, 0, {'\bf Fitting Performance', ['$D_{KL}$= ' num2str(mean(KLdist))]}, 'Interpreter', 'latex')
set(ax5,'Visible','off')