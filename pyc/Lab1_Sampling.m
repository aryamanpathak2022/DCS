%% Sampling and Reconstruction Example for signal cos(2*pi*fm*t)
% --- Explanation ---
% This code demonstrates the process of sampling and reconstruction.
% The message/information signal is is a cosine signal.
% Then, the signal is sampled using a sampling frequency.
% The reconstruction process is performed using the sinc function for interpolation.
% The last subplot compares the reconstructed signal with the original signal for visual analysis.
% Overall, this example illustrates the effect of sampling rate on reconstruction of original signal.

clc; clear all;

%% Define msg signal parameters
msgFreq = 200;         
msgPeriod = 1/msgFreq;
msgDuration = 0:0.0001:5*msgPeriod; % Define the time vector for 5 cycles (5 periods) of the signal
msgSignal = cos(2*pi*msgFreq*msgDuration);% Define the original signal for 5 cycles

%% Sampling the signal
sFreq = 400;          % New sampling frequency
sInstants = 0:(1/sFreq):5*msgPeriod;
sSignal = sin(2*pi*msgFreq*sInstants);

%% Reconstruction
rSignal = zeros(size(msgDuration));
for i = 1:length(sInstants)
    % Use the sinc function for interpolation
    rSignal = rSignal + sSignal(i) * sinc((msgDuration - sInstants(i))*sFreq);
end

%% Plot the signals
subplot(2, 2, 1);
plot(msgDuration, msgSignal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 2);
stem(sInstants, sSignal, 'b'); % Use 'stem' for discrete samples (blue stems)
hold on;
plot(sInstants, sSignal, 'r'); % Also, plot the envalop of the smapled signal (red line)
hold off;
title('Sampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 3);
plot(msgDuration, rSignal);
title('Reconstructed Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 2, 4); % Plot the reconstructed signal and the original signal for comparison
plot(msgDuration, rSignal, 'b'); % Plot reconstructed signal in blue
hold on;
plot(msgDuration, msgSignal, 'r');     % Plot original signal in red
hold off;
title('Reconstructed Signal vs Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Reconstructed Signal', 'Original Signal');

%% Sinc function for Interpolation (Reconstruction using Low-pass Filter)
function y = sinc(x)
    y = sin(pi*x)./(pi*x);
    y(x == 0) = 1;
end

