% Clearing Terminal & Workspace
clc
clear 

% Constants
Fs = 1000;
Tb = 1;

% Generating Rectangular Pulse
Tp = 1.2;
r_rect = rect(Tp, Fs); 
tp = -Tp/2:1/Fs:Tp/2;
p_rect = r_rect(((Tp-Tb)/2)*Fs:length(r_rect));

% Generating Raised Cosine Pulse
tp_rcp = -Tb/2:1/Fs:Tb/2;
Bt = Fs/2;
roll = 0.6;
Rb = 2*Bt/(1+roll);
r_rcp = rcp(tp_rcp, roll, Rb);
p_rcp = rcp(tp_rcp+Tb/2, roll, Rb);

% Random Bits
noOfBits = 10;
bits = randi([0 1],1,noOfBits);

% Line Coding
t = 0:1/Fs:Tb*noOfBits; %Time Vector of Line Code
x = zeros(size(t));
x(mod(t,Tb) == 0 & t ~= noOfBits*Tb) = bits; %x(t) = sigma delta(t-tb)*bit
s_rect = cconv(x,p_rect,length(x)); % Convolution x(t) & p_rect(t) . Use cconv
s_rcp = cconv(x,p_rcp,length(x)); % Convolution x(t) & p_rcp(t). Use cconv

%Decoding
decodedBits_rect = round(s_rect(mod(t,Tb) == 0 & t ~= noOfBits*Tb)); %Decoded Bits : Using s_rect(t)
decodedBits_rcp = round(s_rcp(mod(t,Tb) == 0 & t ~= noOfBits*Tb)); %Decoded Bits : Using s_rcp(t)

disp("Original Bits :")
disp(bits)
disp("Rectangular Pulse Decoded Bits :")
disp(decodedBits_rect)
disp("Raised Cosine Pulse Decoded Bits :")
disp(decodedBits_rcp)


% Plotting
subplot(2, 2, 1);
plot(tp, r_rect);
title('Rectangular Pulse');
xlabel('Time');
ylabel('Amplitude');

subplot(2, 2, 2);
plot(tp_rcp, r_rcp);
title('Raised Cosine Pulse');
xlabel('Time');
ylabel('Amplitude');

subplot(2, 2, 3);
plot(t, s_rect);
title('Transmitted Signal - Rectangular Pulse (ISI)');
xlabel('Time');
ylabel('Amplitude');

subplot(2, 2, 4);
plot(t, s_rcp);
title('Transmitted Signal - Raised Cosine Pulse (No ISI)');
xlabel('Time');
ylabel('Amplitude');

% Rectangular Pulse Generator
function pulse = rect(Tp, Fs)
    t = 0:1/Fs:Tp;
    pulse = zeros(size(t));
    pulse(t >= 0 & t < 0.1) = (t(t >= 0 & t < 0.1) - 0) / (0.1 - 0);
    pulse(t >= 0.1 & t < Tp-0.1) = 1;
    pulse(t >= Tp-0.1 & t <= Tp) = 1 - (t(t >= Tp-0.1 & t <= Tp) - (Tp-0.1)) / (Tp - (Tp-0.1));
end

% Raised Cosine Pulse
function y = rcp(t, roll, Rb)
    y = cos(pi * roll * Rb * t) .* sinc(Rb * t) ./ (1 - 4 * (roll * roll) * (Rb * Rb) * (t .* t));
end
