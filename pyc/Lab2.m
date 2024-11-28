clear all;
close all;
clc;
% PCM implementation

% Parameters
Fs = 500;           %Sampling frequency
duration  = 1;      %Duration of signal
bitsPerSample = 4;  %Number of bits per Sample

%Generate a message signal(sine wave)
t = 0:1/Fs:duration;
f_message = 10;
sampledSignal = cos(2*pi*f_message*t);

% Normalize the message signal to the range [-1, 1]
sampledSignal = sampledSignal / max(abs(sampledSignal));

% Quantization levels
quantLevels = power(2,bitsPerSample);

% Encode the message signal using PCM i.e. mapping to quatized levels (0 to
% quatlLevels -1)
quantizedSignal = round((sampledSignal+1)*(quantLevels-1)/2);

%% encoding- maping quantized samples (levels) to bits
% using int2bit
bitstream = int2bit(quantizedSignal,bitsPerSample);

%% decoding - de-mapping bits to quantized levels {Noiseless in out case}
% using bit2int
decodedLevels = bit2int(bitstream,bitsPerSample);

% Decode the quantized signal
decodedSignal = 2*decodedLevels/(quantLevels-1)-1;


%% reconstruction 
% Filtering out the ripples from the decoded signal using lowpass
filtered_signal = lowpass(decodedSignal,f_message,Fs);

% Plot the original message signal
subplot(4,1,1);
plot(t, sampledSignal);
title('Original Message Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the quantized signal
subplot(4,1,2);
stem(t, quantizedSignal, 'r');
title('Quantized Signal (PCM)');
xlabel('Time (s)');
ylabel('Quantized Value');

% Plot the decoded message signal
subplot(4,1,3);
plot(t, decodedSignal);
title('Decoded Message Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Filter and plot the filtered message signal
subplot(4,1,4)
plot(t, filtered_signal);
hold on
plot(t,sampledSignal,'-r')
hold off
title('Filtered vs Original Message Signal');
legend('Filtered Signal','Original Signal')
xlabel('Time (s)');
ylabel('Amplitude');
