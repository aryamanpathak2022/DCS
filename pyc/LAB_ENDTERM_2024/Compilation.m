% Sampling and reconstruction using sinc
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

% pcm encoding and decoding
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


% ISI

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

% Line Coding
t = 0:1/Fs:Tb*noOfBits; %Time Vector of Line Code
x = zeros(size(t));
x(mod(t,Tb) == 0 & t ~= noOfBits*Tb) = bits; %x(t) = sigma delta(t-tb)*bit
s_rect = cconv(x,p_rect,length(x)); % Convolution x(t) & p_rect(t) . Use cconv
s_rcp = cconv(x,p_rcp,length(x)); % Convolution x(t) & p_rcp(t). Use cconv

%Decoding
decodedBits_rect = round(s_rect(mod(t,Tb) == 0 & t ~= noOfBits*Tb)); %Decoded Bits : Using s_rect(t)
decodedBits_rcp = round(s_rcp(mod(t,Tb) == 0 & t ~= noOfBits*Tb)); %Decoded Bits : Using

% PLOT HISTOGRAM GRAPHS
subplot(2,1,1)
pdfa = hist(a,amplitudeBins);
bar(amplitudeBins,pdfa/(N*0.05))

% QPSK
    % Modulate and demodulate using inbuilt functions for 16-QAM
    txBits = randi([0, 1],numBits,1);
    txSymbols16QAM = qammod(txBits, 16,'InputType', 'bit');
    rxSymbols16QAM = awgn(txSymbols16QAM, snr, 'measured');
    rxBits16QAM = qamdemod(rxSymbols16QAM, 16,'OutputType', 'bit');
    
    % Calculate bit errors for 16-QAM
    bitErrorsBlock16QAM = sum(txBits ~= rxBits16QAM);

% THEORITICAL
qfunc(abs(h)*sqrt(2*SNR(K)));

% PILOT ESTIMAITON
pObser = RxSym(1:nPilot).';
hEst = (pSym/pNorm)'*pObser;
hEstErr(K) = hEstErr(K) + abs(hEst - h)^2;


% CORR
normalized_cross_correlation = (cross_correlation - mean(cross_correlation))/sqrt(var(cross_correlation));

% Align Cross-cross_correlation with the matched filter output signal i.e.,
% output of the Convolution 
lag_offset = (length(ref_signal)-1); % Centre of cross-cross_correlation
aligned_lags = lags-lag_offset;
aligned_cross_correlation = normalized_cross_correlation(lags>=1 & lags<=length(input_signal));

% Create a time Vector for cross-cross_correlation plot
t_corr = linspace(t1(1),t1(end),length(aligned_cross_correlation));