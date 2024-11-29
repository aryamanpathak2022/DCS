rSignal = zeros(size(msgDuration));
for i = 1:length(sInstants)
    rSignal = rSignal + sSignal(i) * sinc((msgDuration - sInstants(i)) * sFreq);
end

subplot(2, 2, 1);
plot(msgDuration, msgSignal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

quantizedSignal = round((sampledSignal + 1) * (quantLevels - 1) / 2);

bitstream = int2bit(quantizedSignal, bitsPerSample);

decodedLevels = bit2int(bitstream, bitsPerSample);

decodedSignal = 2 * decodedLevels / (quantLevels - 1) - 1;

filtered_signal = lowpass(decodedSignal, f_message, Fs);

Tp = 1.2;
r_rect = rect(Tp, Fs);
tp = -Tp / 2 : 1 / Fs : Tp / 2;
p_rect = r_rect(((Tp - Tb) / 2) * Fs : length(r_rect));

tp_rcp = -Tb / 2 : 1 / Fs : Tb / 2;
Bt = Fs / 2;
roll = 0.6;
Rb = 2 * Bt / (1 + roll);
r_rcp = rcp(tp_rcp, roll, Rb);
p_rcp = rcp(tp_rcp + Tb / 2, roll, Rb);

t = 0 : 1 / Fs : Tb * noOfBits;
x = zeros(size(t));
x(mod(t, Tb) == 0 & t ~= noOfBits * Tb) = bits;
s_rect = cconv(x, p_rect, length(x));
s_rcp = cconv(x, p_rcp, length(x));

decodedBits_rect = round(s_rect(mod(t, Tb) == 0 & t ~= noOfBits * Tb));
decodedBits_rcp = round(s_rcp(mod(t, Tb) == 0 & t ~= noOfBits * Tb));

subplot(2, 1, 1);
pdfa = hist(a, amplitudeBins);
bar(amplitudeBins, pdfa / (N * 0.05));

txBits = randi([0, 1], numBits, 1);
txSymbols16QAM = qammod(txBits, 16, 'InputType', 'bit');
rxSymbols16QAM = awgn(txSymbols16QAM, snr, 'measured');
rxBits16QAM = qamdemod(rxSymbols16QAM, 16, 'OutputType', 'bit');
bitErrorsBlock16QAM = sum(txBits ~= rxBits16QAM);

qfunc(abs(h) * sqrt(2 * SNR(K)));

pObser = RxSym(1:nPilot).';
hEst = (pSym / pNorm)' * pObser;
hEstErr(K) = hEstErr(K) + abs(hEst - h)^2;

normalized_cross_correlation = (cross_correlation - mean(cross_correlation)) / sqrt(var(cross_correlation));

lag_offset = (length(ref_signal) - 1);
aligned_lags = lags - lag_offset;
aligned_cross_correlation = normalized_cross_correlation(lags >= 1 & lags <= length(input_signal));

t_corr = linspace(t1(1), t1(end), length(aligned_cross_correlation));
