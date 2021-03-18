************************************* GG-Rician SAR Image Modelling *********************************************

This package includes the MATLAB source code for the modeling of SAR images with the Generalized-Gaussian Rician (GG-Rician) distribution. The GG-Rician distribution is a novel statistical model specifically developed for the characterization of synthetic aperture radar (SAR) images. It is based on the Rician distribution to model the amplitude of the complex SAR signal, the in-phase and quadrature components of which are assumed to be generalized-Gaussian distributed. The extension to modeling SAR images in intensity format is also included.

This package includes the MATLAB source codes for the modelling of SAR images with the Generalized-Gaussian 
	Rician (GG-Rician) distribution.

This package includes three folders:

	1) images		: Stores images for SAR image modelling. We have only shared two example images 
		from TerraSAR-X which are the amplitude and intensity SAR images belongs to the same scene.

	2) main_HELP 		: Stores html help file for main.m script.

	3) source functions	: Stores three source functions:
		3.1) calcnbins.m
		
		3.2) dsSARImage.m
		
		3.3) genericPDFCalculation.m
		
		3.4) GGRicianAmpPdf.m
		
		3.5) GGRicianIntPdf.m
		
		3.6) instantenousPlotting.m
		
		3.7) KLtest.m
		
		3.8) KSScore.m
		
		3.9) logLikelihoodCalculation.m
		
		3.10) performancePlotting.m

and MATLAB scripts:

	1) main.m 		: The main function.

	2) main_HELP.m 		: The Matlab script to generate the help files. 

*****************************************************************************************************************
LICENSE

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

Copyright (c) Oktay Karakus <o.karakus@bristol.ac.uk>, Ercan E. Kuruoglu <ercan.kuruoglu@isti.cnr.it> and Alin Achim <alin.achim@bristol.ac.uk>, 16-03-2021, University of Bristol, UK

*****************************************************************************************************************
REFERENCE

[1] O Karakus, E Kuruoglu and A Achim. "A Generalized Gaussian Extension to the Rician Distribution for SAR Image Modeling." IEEE Transactions on Geoscience and Remote Sensing (2021).

arXiv link 	: https://arxiv.org/abs/2006.08300 

[2] O Karakus, E Kuruoglu and A Achim. "Modelling Sea Clutter In SAR Images Using Laplace-Rician Distribution," ICASSP 2020 - 2020 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP), Barcelona, Spain, 2020, pp. 1454-1458." 

link        : https://doi.org/10.1109/ICASSP40776.2020.9053289

[3]  O Karakus, A Achim, and EE Kuruoglu. (2021): "GG-Rician SAR Image Modelling" 

https://doi.org/10.5523/bris.3nqhdd4qvorwx28hjh8bh6g3r8
*****************************************************************************************************************
