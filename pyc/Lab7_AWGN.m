clear all;
close all;
clc

% Parameters
numBits = 10000;  % Number of bits to transmit
snrRange = 0:2:20;  % Range of SNR values to simulate (in dB)
numSNRs = length(snrRange);
numBlocks = 10;  % Number of blocks to simulate

% Initialize variables to store BER results for 4-QAM and 16-QAM
bitErrors4QAM = zeros(numSNRs, 1);
bitErrors16QAM = zeros(numSNRs, 1);

for snrIdx = 1:numSNRs
    snr = snrRange(snrIdx);
    noiseVar = 1;  % Set the noise variance to 1
    
    % Calculate the signal energy based on the desired SNR
    signalEnergy = noiseVar * 10^(snr/10);
    
    % Initialize bit error counts for this SNR
    totalBitErrors4QAM = 0;
    totalBitErrors16QAM = 0;
    
    for block = 1:numBlocks
        % Generate random bits (0 or 1)
        txBits = randi([0, 1], 1,numBits);
        
        % Map bits to 4-QAM symbols with the adjusted signal energy
        txSymbols4QAM = 2 * txBits - 1;
        txSymbols4QAM = sqrt(signalEnergy/2) * (txSymbols4QAM(1:2:end) + 1i * txSymbols4QAM(2:2:end));
        
        % Add Gaussian noise using 'awgn' function (same noise as 16-QAM)
        rxSymbols4QAM = awgn(txSymbols4QAM, snr, 'measured');
        
        % Demodulation (Minimum distance) for 4-QAM
        rxBits4QAM = [real(rxSymbols4QAM) > 0; imag(rxSymbols4QAM) > 0];
        rxBits4QAM = rxBits4QAM(:)';
        
        % Calculate bit errors for 4-QAM
        bitErrorsBlock4QAM = sum(txBits ~= rxBits4QAM);
        
        % Accumulate bit errors for 4-QAM
        totalBitErrors4QAM = totalBitErrors4QAM + bitErrorsBlock4QAM;
        
        % Modulate and demodulate using inbuilt functions for 16-QAM
        txBits = randi([0, 1],numBits,1);
        txSymbols16QAM = qammod(txBits, 16,'InputType', 'bit');
        rxSymbols16QAM = awgn(txSymbols16QAM, snr, 'measured');
        rxBits16QAM = qamdemod(rxSymbols16QAM, 16,'OutputType', 'bit');
        
        % Calculate bit errors for 16-QAM
        bitErrorsBlock16QAM = sum(txBits ~= rxBits16QAM);
        
        % Accumulate bit errors for 16-QAM
        totalBitErrors16QAM = totalBitErrors16QAM + bitErrorsBlock16QAM;
    end
    
    % Calculate BER for both 4-QAM and 16-QAM for this SNR
    bitErrorRate4QAM = totalBitErrors4QAM / (numBits * numBlocks);
    bitErrorRate16QAM = totalBitErrors16QAM / (numBits * numBlocks);
    bitErrors4QAM(snrIdx) = bitErrorRate4QAM;
    bitErrors16QAM(snrIdx) = bitErrorRate16QAM;
end

% Plot BER vs SNR for both 4-QAM and 16-QAM
figure;
semilogy(snrRange, bitErrors4QAM, '-o', 'DisplayName', '4-QAM');
hold on;
semilogy(snrRange, bitErrors16QAM, '-o', 'DisplayName', '16-QAM');
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for 4-QAM and 16-QAM Modulation');
legend('Location', 'best');


figure;

% Plot transmitted 4-QAM symbols
subplot(2, 2, 1);
scatter(real(txSymbols4QAM), imag(txSymbols4QAM), 'g.');
title('Transmitted 4-QAM Symbols');
xlabel('I');
ylabel('Q');

% Plot received 4-QAM symbols
subplot(2, 2, 2);
scatter(real(rxSymbols4QAM), imag(rxSymbols4QAM), 'b.');
title('Received 4-QAM Symbols');
xlabel('I');
ylabel('Q');

% Plot transmitted 16-QAM symbols
subplot(2, 2, 3);
scatter(real(txSymbols16QAM), imag(txSymbols16QAM), 'm.');
title('Transmitted 16-QAM Symbols');
xlabel('I');
ylabel('Q');

% Plot received 16-QAM symbols
subplot(2, 2, 4);
scatter(real(rxSymbols16QAM), imag(rxSymbols16QAM), 'r.');
title('Received 16-QAM Symbols');
xlabel('I');
ylabel('Q');
