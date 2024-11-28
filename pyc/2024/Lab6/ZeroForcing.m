close all;
clear;
clc;

% Simulation Parameters
blockLength = 1000; % Number of bits per block
nBlocks = 1000; % Number of blocks to simulate
SNRdB = 0:2:16; % SNR values in dB
SNR = 10.^(SNRdB/10); % Convert SNR to linear scale
No = 1; % Noise variance

% Receiver and Transmitter configurations
configs = [
    2, 2;
    2, 4;
    4, 2;
    4, 4
];

BER_QPSK = zeros(length(configs), length(SNR));

for cfg = 1:size(configs, 1)
    r = configs(cfg, 1); % Number of receivers
    t = configs(cfg, 2); % Number of transmitters

    for blk = 1:nBlocks
        % Generate random bits for QPSK modulation
        BitsI = randi([0, 1], t, blockLength); % In-phase bits
        BitsQ = randi([0, 1], t, blockLength); % Quadrature bits

        % Map bits to QPSK symbols
        TxSymbols = (2*BitsI - 1 + 1j*(2*BitsQ - 1)) / sqrt(2); % QPSK modulation

        for k = 1:length(SNRdB)
            % Generate random Rayleigh channel matrix
            H = (randn(r, t) + 1j*randn(r, t)) / sqrt(2);

            % Add noise
            noise = sqrt(No/2) * (randn(r, blockLength) + 1j*randn(r, blockLength));

            % Transmit symbols through the channel
            RxSymbols = H * sqrt(SNR(k)) * TxSymbols + noise;

            % Zero-Forcing Receiver
            H_inv = pinv(H); % Compute pseudo-inverse of H
            DetectedSymbols = H_inv * RxSymbols; % Zero-forcing detection

            % Demodulate detected symbols to bits
            DecBitsI = real(DetectedSymbols) > 0; % Decision for in-phase
            DecBitsQ = imag(DetectedSymbols) > 0; % Decision for quadrature

            % Compute BER
            BER_QPSK(cfg, k) = BER_QPSK(cfg, k) + sum(DecBitsI(:) ~= BitsI(:)) + sum(DecBitsQ(:) ~= BitsQ(:));
        end
    end

    % Normalize BER for QPSK
    BER_QPSK(cfg, :) = BER_QPSK(cfg, :) / (t * blockLength * nBlocks);
end

% Plot BER vs SNR for all configurations
figure;
for cfg = 1:size(configs, 1)
    r = configs(cfg, 1);
    t = configs(cfg, 2);
    semilogy(SNRdB, BER_QPSK(cfg, :), 'LineWidth', 2.0, 'DisplayName', sprintf('r = %d, t = %d', r, t));
    hold on;
end

grid on;
xlabel('SNR (dB)');
ylabel('BER');
legend('show');
title('BER vs SNR for QPSK with Zero-Forcing Receiver');