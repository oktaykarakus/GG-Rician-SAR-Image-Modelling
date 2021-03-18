%% The main script for SAR image modelling with the GG-Rician distribution.
%
% Some Important Variables
%       ** *Parameters*                   : GLOBAL VARIABLE. A structure type 
%           variable which stores various parameters given below:
%                   *outSourceImage*      : Set to 1 for loading SAR image
%                       from computer. Set to 0, otherwise.
%                   *distType*            : Refers to the type of simulation.
%                       1: GG-Rician Amplitude modelling of example SAR image.
%                       2: GG-Rician Intensity modelling of example SAR image.
%                       3: GG-Rician Amplitude modelling of synthetically generated data.
%                   *dsTargetSize*        : Downsampling target sample size.
%                   *synDataLength*       : Synthetically generated data
%                       sample size.
%                       (Only active when Parameters.distType = 3)
%                   *scale*               : Synthetically generated data
%                       scale parameter.
%                       (Only active when Parameters.distType = 3) 
%                   *shape*               : Synthetically generated data
%                       shape parameter.
%                       (Only active when Parameters.distType = 3)
%                   *location*            : Synthetically generated data
%                       location parameter.
%                       (Only active when Parameters.distType = 3)
%                   *epsilon*             : Hyperparameter for location
%                   parameter proposal distribution. (Move M_1)
%                   *Xi_sq*               : Hyperparameter for scale
%                   parameter proposal distribution. (Move M_2)
%                   *eta*                 : Hyperparameter for shape
%                   parameter proposal distribution. (Move M_3)
%                   *P_M1*                : Probability of Move M_1 
%                   *P_M2*                : Probability of Move M_2
%                   *P_M3*                : Probability of Move M_3
%                   *AllP*                : CDF of move probabilities
%                   *NumberofIterations*  : Number of iterations for MCMC.
%                   *burnInPeriod*        : Burn-In sample size.
%                   *Image*               : Full-size SAR Image. Refers to
%                       the 1D synthetically generated data for distType=3.  
%                   *DSInput*             : Down-sampled input for MCMC.
%                   *dsKL*                : KL-divergence value between the
%                       full-size SAR Image and DSInput. 
%                   *dsSize*              : Final down-sampled data size.
%                   *noDSInput*           : Another parameter to store
%                       full-size SAR Image.
%                   *Data*                : 
%
%       ** *Output*                       : GLOBAL VARIABLE. A structure type 
%           variable which stores various output variables given below:
%                   *Location_delta*      : Instantenous location parameter
%                       estimates.
%                   *Scale_gamma*         : Instantenous scale parameter
%                       estimates.
%                   *Shape_alpha*         : Instantenous shape parameter
%                       estimates.
%                   *SelectedMove*        : Stores selected move type for
%                       each MCMC iteration.
%                   *AcceptanceRatio*     : Stores calculated acceptance
%                       ratio values for each MCMC iteration.
%                   *RatioXX*             : Stores each specific ratio values
%                       in acceptance ratio expressions. Has several forms
%                       such as Ratio1, Ratio21.
%
%       ** *Results*                      : GLOBAL VARIABLE. A structure type 
%           variable which stores variables given below:
%                   *estDelta*            : Posterior mean estimation for the
%                       location parameter.
%                   *estGamma*            : Posterior mean estimation for the
%                       scale parameter.
%                   *estAlpha*            : Posterior mean estimation for the
%                       shape parameter.
%                   *KLdiv*               : Performance metric. Shows
%                       corresponding KL divergence value for the modeling.
%                   *KSscore*             : Performance metric. Shows
%                       corresponding KS Score value for the modeling.
%
%       ** *alpha*                        : Instantenous proposal for the
%           shape parameter. 
%
%       ** *gamma*                        : Instantenous proposal for the
%           scale parameter. 
%
%       ** *delta*                        : Instantenous proposal for the
%           location parameter. 
%
%       ** *file, path, prompt, dlgtitle, dims, definput, answer, opts* : 
%           These are variables for pup-up dialog box. When user choses  
%           distType = 3, or ourSourceImage = 1, a specific dialog box 
%           pops-up and asks user to enter corresponding parameters.
%       ** *For the functions dsSARImage(.), logLikelihoodCalculation(.),
%       instantenousPlotting(.), and performancePlotting(.), please visit
%       specific function's .m file.*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%
% *LICENSE*
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
% 
%%
% *REFERENCE*
%
% [1] _O Karakus, E Kuruoglu and A Achim. "A Generalized Gaussian Extension to the Rician
%       Distribution for SAR Image Modeling."
%       arXiv preprint, arXiv:2006.08300, 2020._
%
% [2] _O Karakus, E Kuruoglu and A Achim. "Modelling Sea Clutter In SAR Images Using 
%       Laplace-Rician Distribution," ICASSP 2020 - 2020 IEEE International Conference
%       on Acoustics, Speech and Signal Processing (ICASSP), Barcelona, Spain, 2020,
%       pp. 1454-1458."_ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear
close all
addpath('.\source functions');
addpath('.\images');
%% User Defined Variables
global Parameters
global Output
global Results
Parameters.outSourceImage = 0;
Parameters.distType = 1;            
Parameters.dsTargetSize = 500;
Parameters.epsilon = 2.5;
Parameters.eta = 0.5;
Parameters.Xi_sq = 3^2;
Parameters.P_M1 = 1/3;
Parameters.P_M2 = 1/3;
Parameters.P_M3 = 1 - Parameters.P_M1 - Parameters.P_M2;
Parameters.AllP = cumsum([Parameters.P_M1 Parameters.P_M2 Parameters.P_M3]);
Parameters.NumberofIterations = 1e2;
Parameters.burnInPeriod = floor(Parameters.NumberofIterations/2);
Results = struct('estDelta', 1, 'estGamma', 1, 'estAlpha', 1, 'KLdiv', 1, 'KSscore', 1);
%% Data Loading
if Parameters.outSourceImage
    [file, path] = uigetfile({'*.tif';'*.bmp';'*.gif';'*.jpg';'*.tiff'}, 'Select file');
    prompt = {'Please Select Simualtion Type (Parameters.distType) (1: Amplitude, 2: Intensity)'};
    dlgtitle = '';
    dims = [1 100];
    definput = {'1'};
    opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
    Parameters.distType = str2double(answer{1});
    addpath(path);
    Parameters.Image = double(imread(file));
    if size(Parameters.Image, 3) > 1
        Parameters.Image = Parameters.Image(:, :, 1:3);
        Parameters.Image = mean(Parameters.Image, 3);
    end
    temp = sort(Parameters.Image(:));
    [Parameters.DSInput, Parameters.dsKL, Parameters.dsSize] = dsSARImage(Parameters.dsTargetSize, temp);
    Parameters.noDSInput = Parameters.Image;
    clear temp file path prompt dlgtitle dims definput answer opts
else
    switch Parameters.distType
        case 1 
            Parameters.Image = double(imread('mixed2_amp.tif'));
            Parameters.Image = Parameters.Image(:, :, 1:3);
            Parameters.Image = mean(Parameters.Image, 3);
            temp = sort(Parameters.Image(:));
            [Parameters.DSInput, Parameters.dsKL, Parameters.dsSize] = dsSARImage(Parameters.dsTargetSize, temp);
            Parameters.noDSInput = Parameters.Image;
            clear temp
        case 2 
            Parameters.Image = double(imread('mixed2_int.tif'));
            Parameters.Image = Parameters.Image(:, :, 1:3);
            Parameters.Image = mean(Parameters.Image, 3);
            temp = sort(Parameters.Image(:));
            [Parameters.DSInput, Parameters.dsKL, Parameters.dsSize] = dsSARImage(Parameters.dsTargetSize, temp);
            Parameters.noDSInput = Parameters.Image;
            clear temp
        case 3
            prompt = {'Sample Size = ', 'Shape Parameter (\alpha) = ', 'Scale Parameter (\gamma) = ', 'Location Parameter (\delta) = '};
            dlgtitle = 'Please Select Synthetically Generated Data Parameters';
            dims = [1 70; 1 70; 1 70; 1 70];
            definput = {'500', '2', '1', '1'};
            opts.Interpreter = 'tex';
            answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
            Parameters.synDataLength = str2double(answer{1});
            Parameters.scale = str2double(answer{2});
            Parameters.shape = str2double(answer{3});
            Parameters.location = str2double(answer{4});
            y1 = Parameters.location + Parameters.scale*(abs(gamrnd(1/Parameters.shape, 1, 1, Parameters.synDataLength)).^(1/Parameters.shape)).*((rand(1, Parameters.synDataLength)<0.5)*2-1);
            y2 = Parameters.location + Parameters.scale*(abs(gamrnd(1/Parameters.shape, 1, 1, Parameters.synDataLength)).^(1/Parameters.shape)).*((rand(1, Parameters.synDataLength)<0.5)*2-1);
            Parameters.noDSInput = sqrt(y1.^2 + y2.^2);
            Parameters.DSInput = Parameters.noDSInput;
            Parameters.Image = Parameters.DSInput;
            clear y1 y2 temp file path prompt dlgtitle dims definput answer opts
    end
end
Parameters.DSInput = Parameters.DSInput(:);
Parameters.Data = Parameters.DSInput;
idx = not(Parameters.Data == 0);
Parameters.Data = Parameters.Data(idx);
clear idx
%% Parameter Initialization
Output.Location_delta = zeros(1, Parameters.NumberofIterations);
Output.Scale_gamma = zeros(1, Parameters.NumberofIterations);
Output.Shape_alpha = zeros(1, Parameters.NumberofIterations);
Output.SelectedMove = 1e3*ones(1, Parameters.NumberofIterations);    

if Parameters.distType == 3
    Output.Location_delta(1) = 1;
    Output.Scale_gamma(1) = 1;
    Output.Shape_alpha(1) = 2;
    Parameters.epsilon = 0.5;
    Parameters.eta = 0.25;
    Parameters.Xi_sq = 0.3^2;
elseif Parameters.distType == 1
    Output.Shape_alpha(1) = 2;
    Output.Scale_gamma(1) = 20;
    Output.Location_delta(1) = 40;
elseif Parameters.distType == 2
    Output.Shape_alpha(1) = 2;
    Output.Scale_gamma(1) = 1;
    Output.Location_delta(1) = 1;
end
Output.AcceptanceRatio = zeros(1, Parameters.NumberofIterations);
%% MCMC based parameter estimation step
for i = 2:Parameters.NumberofIterations
    %% Model Move Selection
    Output.SelectedMove(i) = find(rand < Parameters.AllP, 1, 'first');
    %% Sampling step
    if Output.SelectedMove(i) == 1 % Move M_1
        alpha = Output.Shape_alpha(i-1);
        gamma = Output.Scale_gamma(i-1);
        delta = -10;
        while delta <= 0
            delta = (2*Parameters.epsilon*rand - Parameters.epsilon) + Output.Location_delta(i-1);
        end
        % *************************************************************
        Output.Ratio11 = logLikelihoodCalculation(Parameters.Data, gamma, alpha, delta, Parameters.distType);
        Output.Ratio12 = logLikelihoodCalculation(Parameters.Data, Output.Scale_gamma(i-1), Output.Shape_alpha(i-1), Output.Location_delta(i-1), Parameters.distType);
        Output.Ratio1 = exp(Output.Ratio11 - Output.Ratio12);
        Output.Ratio2 = 1;
        Output.Ratio3 = 1;
        % *************************************************************
        Output.AcceptanceRatio(i) = min(1, Output.Ratio1*Output.Ratio2*Output.Ratio3);
    elseif Output.SelectedMove(i) == 2 % Move M_2
        alpha = Output.Shape_alpha(i-1);
        delta = Output.Location_delta(i-1);
        % *************************************************************
        pd = makedist('Normal','mu',Output.Scale_gamma(i-1),'sigma',sqrt(Parameters.Xi_sq));
        pd2 = truncate(pd, 0, 5*Output.Scale_gamma(i-1));
        gamma = random(pd2, 1, 1);
        pdd = makedist('Normal','mu',gamma,'sigma',sqrt(Parameters.Xi_sq));
        pdd2 = truncate(pdd, 0, 5*gamma);
        % *************************************************************
        Output.Ratio11 = logLikelihoodCalculation(Parameters.Data, gamma, alpha, delta, Parameters.distType);
        Output.Ratio12 = logLikelihoodCalculation(Parameters.Data, Output.Scale_gamma(i-1), Output.Shape_alpha(i-1), Output.Location_delta(i-1), Parameters.distType);
        Output.Ratio1 = exp(Output.Ratio11 - Output.Ratio12);
        Output.Ratio21 = 1/gamma;
        Output.Ratio22 = 1/Output.Scale_gamma(i-1);
        Output.Ratio2 = Output.Ratio21/Output.Ratio22;
        Output.Ratio31 = pdf(pdd2, Output.Scale_gamma(i-1));
        Output.Ratio32 = pdf(pd2, gamma);
        Output.Ratio3 = Output.Ratio31/Output.Ratio32;
        % *************************************************************
        Output.AcceptanceRatio(i) = min(1, Output.Ratio1*Output.Ratio2*Output.Ratio3);
    elseif Output.SelectedMove(i) == 3 % Move M_3
        alpha = -10;
        while alpha <= 0.1
            alpha = (2*Parameters.eta*rand - Parameters.eta) + Output.Shape_alpha(i - 1);
        end
        
        delta = Output.Location_delta(i-1);
        gamma = Output.Scale_gamma(i-1);
        % *************************************************************
        Output.Ratio11 = logLikelihoodCalculation(Parameters.Data, gamma, alpha, delta, Parameters.distType);
        Output.Ratio12 = logLikelihoodCalculation(Parameters.Data, Output.Scale_gamma(i-1), Output.Shape_alpha(i-1), Output.Location_delta(i-1), Parameters.distType);
        Output.Ratio1 = exp(Output.Ratio11 - Output.Ratio12);
        Output.Ratio2 = 1;
        Output.Ratio3 = 1;
        Output.Ratio4 = 1;
        % *************************************************************
        Output.AcceptanceRatio(i) = min(1, Output.Ratio1*Output.Ratio2*Output.Ratio3*Output.Ratio4);
    end
    %% Decision Step
    Prob = rand;
    if  Prob <= Output.AcceptanceRatio(i)     %Accept
        Output.Location_delta(i) = delta;
        Output.Scale_gamma(i) = gamma;
        Output.Shape_alpha(i) = alpha;
    else            % Reject
        Output.Location_delta(i) = Output.Location_delta(i-1);
        Output.Scale_gamma(i) = Output.Scale_gamma(i-1);
        Output.Shape_alpha(i) = Output.Shape_alpha(i-1);
    end
    %% Drawing instantenous results at every 10 iterations
    if  mod(i, 10) == 0
        hFig = figure(1);
        instantenousPlotting(hFig, i);
        drawnow
    end
end
clear pd* Prob gamma delta alpha i
%% Performance analysis
close
hFig = figure('Name', 'Results and Performance');
performancePlotting(hFig);