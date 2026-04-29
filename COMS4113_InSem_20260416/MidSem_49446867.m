clear all
%Student ID (Change this to your student number)
ID = 49446867;

logIt(ID);
fid = fopen(sprintf('%i.txt',ID),'wt');

%%%GENERIC SETUP%%%%

%Speed of light. If you need to change the speed of light, you've gone
%horribly wrong.
c = 299792458;

%Centre frequency (192 THz)
f0 = 192e12;

%Number of frequency points to simulate
freqCount = 1001;
lambdaCount = freqCount;

%Linearly spaced frequency points centred on f0
f = f0+linspace(-1,1,freqCount).*10e12;
%Frequency spacing in the frequency axis.
df = abs(f(2)-f(1));
%The time axis corresponding to the frequency (f) axis
timeAxis = (1./df).*(-(freqCount/2):(freqCount/2)-1)./(freqCount);
%Other representations of the frequency axis
w = 2.*pi.*f; %Angular frequency
lambda = c./f; %Wavelength
%The index of the frequency point closest to the centre frequency f0
[fV fIdx] = min(abs(f-f0));
%The centre wavelength
lambda0 = lambda(fIdx);

%This function takes an input of your student number (ID), and assigns you
%an optical material, 'material x'. The refractive index 'n' or 'material
%x' is returned for all wavelengths (lambda) you specify. This refractive
%index of this 'material x' will be used for some of the questions that
%follow.
[n] = refractiveIndex(ID,lambda);

%%%%%%%%%%%%%%%%%%%%  PHASE VELOCITY/GROUP VELOCITY  %%%%%%%%%%%%%%%%%%%%%%
% What is the phase velocity and group velocity of 'material x' at the 
% centre frequency?

%%WORKING START
phaseVelocity = 0;
groupVelocity = 0;

n0 = n(fIdx);
phaseVelocity = c/n0;

dn_dlambda = gradient(n,lambda);
ng = n0 - lambda0 * dn_dlambda(fIdx);
groupVelocity = c/ng;
%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('<PHASE/GROUP VELOCITY> [4 marks]');
fprintf(fid,'Phase velocity (m/s)	%3.3f\n', phaseVelocity); %2 mark
fprintf(fid,'Group velocity (m/s)	%3.3f\n', groupVelocity); %2 mark
%%PRINT ANSWER END

%%%%%%%%%%%%%%%%%%%%  DIFFRACTION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The function 'aperture' below generates the field (B) of a diffraction
%pattern due to some simple aperture at the specified wavelength (lambda0).
%It also returns the spatial frequency  axes kx and ky. What is the total
%width of the aperture which created this diffraction pattern?
[kx,ky,B] = aperture(ID,lambda0);

%%WORKING START
r0 = 0;

mid = ceil(length(ky)/2);
Bx = abs(B(mid,:));
Bx = Bx / max(Bx);
cx = ceil(length(kx)/2);

thr = 1e-3;
idx = find(Bx(cx+1:end) < thr, 1, 'first') + cx;
k_zero = abs(kx(idx));
r0 = 3.832 / k_zero;

%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('<DIFFRACTION> [4 marks]');
fprintf(fid,'Aperture total width (micron)	%3.3f\n',r0.*2.*1e6); %4 marks
%%PRINT ANSWER END

%%%%%%%%%%%%%%%%%%%%%  COHERENCE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The function [f] = laserFreq(ID), takes your student ID as an input, and
%outputs the instantaneous frequency in Hertz at which a laser is currently
%oscillating. The laser has a Gaussian-shaped power spectral density. 
%What is the linewidth of this laser source and the corresponding coherence time?

%%WORKING START
fwhm = 0;
t_c = 0;

Nsamp = 10000;
fsamp = zeros(1,Nsamp);

for k = 1:Nsamp
    fsamp(k) = laserFreq(ID);
end

sigma_f = std(fsamp);
fwhm_Hz = 2*sqrt(2*log(2))*sigma_f;
fwhm = fwhm_Hz / 1e12;      

t_c = 0.66 / fwhm_Hz;       

%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('<COHERENCE> [4 marks]');
fprintf(fid,'FWHM (THz)	%3.3f\n',fwhm); %2 marks
fprintf(fid,'Coherence time (ps)	%3.3f\n',t_c.*1e12); %2 marks
%%PRINT ANSWER END

%%%%%% POLARISATION %%%%%%%%
%How thick would a zero-order half-wave plate for the centre wavelength (lambda0) need to be, if
%it the material had a slow-axis of 1.006*n0 and a fast axis of n0 (material
%x)

%WORKING START
L = 0;

n0 = n(fIdx);
delta_n = 0.006*n0;
L = lambda0/(2*delta_n);
%WORKING END

%%PRINT ANSWER (Do not modify)
disp('<POLARISATION> [2 marks]');
fprintf(fid,'Thickness (micron)	%3.3f\n',L.*1e6);%2 marks
%%PRINT ANSWER END

%%%%%%%%%%%%%%%%%%%%%%%%%WAVEGUIDES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The function 'fibreModeCount' takes an input of your student ID, and a
%wavelength (lambda) and outputs the number of supported modes (N) for a
%parabolic index fibre of numerical aperture = 0.2, and an unknown core
%diameter (rho). What is the core diameter of the fibre?
[N] = fibreModeCount(ID,lambda);

%%%%%%%WORKING%%%%%%
rho = 0;

NA = 0.2;

N0 = N(fIdx);

rho = (lambda0/(pi*NA))*sqrt(4*N0);
%%%%%WORKING END%%%%%%
disp('<WAVEGUIDES> [2 marks]');
fprintf(fid,'Core diameter (micron)	%3.3f\n',rho.*1e6);%2 marks

%%%%%%%%%%%%%%%%%%%%%%%%%%%% RESONATORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%QUESTION : The function FP simulates a Fabry-Perot resonator  with an air cavity. 
% It inputs your student number and a list of wavelengths, and outputs the complex
%transmittance of the FP resonator at those wavelengths. What is the
%free-spectral range, cavity length, full-width to half maximum and the
%mirror reflectivity of your resonator?
[t] = FP(ID,lambda);

%%WORKING START
FSR = 0;
L = 0;
FWHM = 0;
R = 0;

T = abs(t).^2;
[pks,locs] = findpeaks(T, f, 'MinPeakProminence', 0.1*max(T));

FSR_Hz = mean(diff(locs));
FSR = FSR_Hz / 1e12;   
%FSR↑

L_m = c/(2*FSR_Hz);
L = L_m*1e3;   
%Cavity legnth

[pk, idxPk] = max(T);
halfMax = pk/2;

i1 = find(T(1:idxPk) < halfMax, 1, 'last');
f1 = interp1(T(i1:i1+1), f(i1:i1+1), halfMax);

i2 = find(T(idxPk:end) < halfMax, 1, 'first') + idxPk - 1;
f2 = interp1(T(i2-1:i2), f(i2-1:i2), halfMax);

FWHM_Hz = f2 - f1;
FWHM = FWHM_Hz / 1e9;   
%FWHM

Finesse = FSR_Hz / FWHM_Hz;
fun = @(R) pi*sqrt(R)./(1-R) - Finesse;
R = fzero(fun, [1e-6, 0.999999]);
%Reflectivity

%%WORKING END

%%PRINT ANSWER (Do not modify)
disp('<RESONATORS> [6 marks]');
fprintf(fid,'Free Spectral Range (THz)	%3.3f\n',FSR); %[1 mark]
fprintf(fid,'Cavity length (mm)	%3.3f\n',L);%[1 mark]
fprintf(fid,'FWHM (GHz)	%3.3f\n',FWHM);%[1 mark]
fprintf(fid,'Mirror Reflectivity (power fraction reflected)	%3.3f\n',R);%[1 mark]
%%PRINT ANSWER END


%%%%%%%%%%%%% RESONATOR + PULSE (together at last) %%%%%%%%%%%%%
% The code below generates a 1 ps Gaussian pulse with a time axis that
% corresponds directly with the wavelength (lambda) and frequency (f) axes
% used in the earlier question(s).
% Pass this pulse through your Fabry Perot cavity. How much of the total
% power of the pulse is transmitted through the cavity?

% NOTE: Performing an FFT followed by an IFFT in Matlab will result in
% energy being conserved (as it should). However FFT or IFFT by themselves
% are not properly normalised in Matlab (i.e. they don't obey Parseval's)
% https://en.wikipedia.org/wiki/Parseval%27s_theorem
% https://www.fftw.org/fftw3_doc/The-1d-Discrete-Fourier-Transform-_0028DFT_0029.html
% ('FFTW computes an unnormalized transform')
% Be careful with FFT normalisation.

%Width of our Gaussian pulse in time
pulseWidth = 1e-12;
%Generate a Gaussian pulse
pulse = exp(-timeAxis.^2./pulseWidth.^2);
%Normalise the pulse such that the total power/energy adds up to unity (i.e. the
%total energy of the pulse is 1.
pulse = pulse./sqrt(sum(sum(abs(pulse).^2)));

%%WORKING START
transPwr = 0;

Ein = pulse;

% f_domain
Ein_w = fftshift(fft(ifftshift(Ein)));

% pass through
Eout_w = Ein_w .* t;

% t_domain
Eout = fftshift(ifft(ifftshift(Eout_w)));

Pin = sum(abs(Ein).^2);
Pout = sum(abs(Eout).^2);

transPwr = Pout / Pin;
%%WORKING END

%%PRINT ANSWER (Do not modify)
fprintf(fid,'Fraction of input pulse power transmitted	%3.3f\n',transPwr);%[2 marks]
%%PRINT ANSWER END

logIt(ID);
fclose(fid);