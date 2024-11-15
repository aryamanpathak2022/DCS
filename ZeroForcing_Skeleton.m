clc
clear

% Plot for r = 2, t = 2
[y, x] = MIMO(2, 2);
semilogy(x, y, "LineWidth", 3);
hold on;

% Plot for r = 4, t = 2
[y, x] = MIMO(4, 2);
semilogy(x, y, "LineWidth", 3);

% Plot for r = 2, t = 4
[y, x] = MIMO(2, 4);
semilogy(x, y, "LineWidth", 3);

hold off;

% Grid settings
grid on;
grid minor;

% Labels and legend
xlabel("SNR (dB)");
ylabel("BER");
legend("r = 2, t= 2", "r = 4, t= 2", "r = 2, t= 4");

% MIMO Function
function [ber, snr_db] = MIMO(r, t)
    % Parameters
    num_symbols = 1e6;           % Number of symbols
    snr_db = 0:2:20;             % SNR range in dB
    snr_linear = 10.^(snr_db / 10); % SNR linear scale
    ber = zeros(size(snr_db));   % Preallocate BER array
    
    % Simulation Loop
    for i = 1:length(snr_linear)
        % Generate random symbols for transmit antennas
        tx_symbols = randi([0 1], t, num_symbols);
        
        % Map symbols to BPSK (1 -> 1, 0 -> -1)
        tx_modulated = 2 * tx_symbols - 1;
        
        % Create random MIMO channel (Rayleigh fading)
        h = (randn(r, t) + 1j * randn(r, t)) / sqrt(2);
        
        % Additive White Gaussian Noise (AWGN)
        noise = (randn(r, num_symbols) + 1j * randn(r, num_symbols)) / sqrt(2);
        noise_power = 1 / sqrt(snr_linear(i));
        rx_signal = h * tx_modulated + noise * noise_power;
        
        % Zero Forcing (ZF) Receiver
        h_pseudo_inverse = pinv(h); % Pseudo-inverse of the channel
        rx_estimated = h_pseudo_inverse * rx_signal; 
        
        % Demodulation (BPSK: >0 -> 1, <=0 -> 0)
        rx_demodulated = real(rx_estimated) > 0;
        
        % Calculate Bit Errors
        bit_errors = sum(sum(rx_demodulated ~= tx_symbols));
        ber(i) = bit_errors / (num_symbols * t);
    end
end
