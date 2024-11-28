close all;
clc;
clearvars;

fs = 1000;
T1 = 2;
T2 = 0.5;
t1 = 0:1/fs:T1-1/fs;
t2 = 0:1/fs:T2;
T3 = T1+T2;
t3 = 0:1/fs:T3-1/fs;

fm = 50;
input_signal = sin(2*pi*fm*t1);

ref_signal = sin(2*pi*fm*t2);

figure;
plot(t1,input_signal);
title("Input signal");
ylabel("Amplitude");
xlabel("time");
grid on;

figure;
plot(t2,ref_signal);
title("Refrence signal");
ylabel("Amplitude");
xlabel("time");
grid on;

noise =  randn(size(t1));
noisy_sig = input_signal + noise;
figure;
plot(noisy_sig);
title("noisy signal");
ylabel("Amplitude");
xlabel("time");
grid on;

matched_filter = fliplr(ref_signal);

figure;
plot(t2,matched_filter);
title("Matched filter");
ylabel("Amplitude");
xlabel("time");
grid on;

filtered_signal = conv(input_signal, ref_signal);

figure;
plot(t3,filtered_signal);
title("Output of matched_filter");
ylabel("Amplitude");
xlabel("time");
grid on;

[cross_correlation,lags] = xcorr(input_signal,ref_signal);

% Normalize the cross-cross_correlation output manually
norm_factor = sqrt(sum(input_signal.^2)*sum(ref_signal.^2));
normalized_cross_correlation = (cross_correlation - mean(cross_correlation))/sqrt(var(cross_correlation));

% Align Cross-cross_correlation with the matched filter output signal i.e.,
% output of the Convolution 
lag_offset = (length(ref_signal)-1); % Centre of cross-cross_correlation
aligned_lags = lags-lag_offset;
aligned_cross_correlation = normalized_cross_correlation(lags>=1 & lags<=length(input_signal));

% Create a time Vector for cross-cross_correlation plot
t_corr = linspace(t1(1),t1(end),length(aligned_cross_correlation));

% Normalize the matched filter output and cross-cross_correlation result to their
% respective 
filteredSignalNormalized = filtered_signal/max(abs(filtered_signal));
cross_correlationNOrmalized = aligned_cross_correlation/max(abs(aligned_cross_correlation));

inter = length(cross_correlationNOrmalized);

figure;
plot(t_corr,cross_correlationNOrmalized);
title("Cross correlation");
ylabel("Amplitude");
xlabel("time");
grid on;


figure;
plot(t3,filteredSignalNormalized,'b','DisplayName','Matched Filter Output');
hold on;
plot(t_corr,cross_correlationNOrmalized,'r','DisplayName','Cross-Correlation output');
legend;
title('Comparison of normalized outputs');
xlabel('Time(s)');
ylabel('Normalized Amplitude');

