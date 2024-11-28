%Refershing Terminal & Workspace
clc
clear

%Globals
N = 1e6;
amplitudeBins = 0:0.05:4; 
phaseBins = -pi:0.05:pi;

%Distributions : Raleigh Fading Channel
h = randn(1,N) + 1j*randn(1,N);
a = abs(h); %Amplitude of h
phi = angle(h); %Phase of h


subplot(2,1,1)
pdfa = hist(a,amplitudeBins);
bar(amplitudeBins,pdfa/(N*0.05))

%Graph Specifics
title('PDF of Amplitude')
grid 
xlabel('a')
ylabel('f A(a)')

subplot(2,1,2)
pdfp = hist(phi,phaseBins);
bar(phaseBins,pdfp/(N*0.05))

%Graph Specifics
title('PDF of Phase')
grid
xlabel('\theta')
ylabel('f_\Theta(\theta)')


