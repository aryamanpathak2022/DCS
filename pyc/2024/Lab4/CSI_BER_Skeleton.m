%Refershing Terminal & Workspace
clc
clear

nPilot = 10;
nData = 1e3;
blocklength = nPilot+nData;
nBlocks = 2e3;
SNRdb = 0:0.5:15;
SNR = 10.^(SNRdb/10);

No = 1;
BER_pCSI = zeros(size(SNRdb)); % BER of perfect chanel
BER_imCSI = zeros(size(SNRdb)); % BER of imperfect or estimated channel
hEstErr = zeros(size(SNRdb)); % Channel estimation error

for blk = 1:nBlocks
    h = randn + 1j*randn;  % 1. Generate complex gaussian channel
    Bits = randi([0,1],1,blocklength); % 2. Generate bits of length equal to blocklength
    Sym = 2 * Bits - 1;%2. Generate BPSK symbols, ie map bit 1--->+1 and 0--->-1
    pSym = Sym(1:nPilot); % 4. generate/get nPilot number of pilot symbols
    pNorm = norm(pSym.*pSym); % 5. Calculate the norm square of pilot symbols
    noise = sqrt(No/2)*(randn(1,blocklength) + 1j*randn(1,blocklength)); % Generate complex noise of variance N0 
    for K = 1: length(SNRdb)
        TxSym = sqrt(SNR(K))*Sym;  % Generate transmit symbol 
        RxSym = (TxSym)*h + noise;  % Calculate the received symbol
        pObser = RxSym(1:nPilot);
        pObser_trans = transpose(pObser);% Get the reveived observation vector corresponding to the pilot symbols
        hEst = ((pSym)*(pObser_trans))/(pNorm); % calculate estimated channel
        hEstErr(K) = hEstErr(K) + abs((h-hEst))^2;  % Calculate channel estimation error
        EqSym_pCSI = RxSym/h; % Equlization of perfect channel
        Decbits_pCSI = (EqSym_pCSI > 0); % Make decision based on received symbols to recover the bits under perfect channel
        BER_pCSI(K) = BER_pCSI(K) + sum(Decbits_pCSI ~= Bits); % Calculate BER of perfect channel
       
        EqSym_imCSI = RxSym(nPilot:blocklength)/hEst;
        Decbits_imCSI = (EqSym_imCSI > 0);
        % Equlization of estimated/imperfect channel
        
        %Make decision based on received symbols to recover the bits under imperfect channel
        BER_imCSI(K) =BER_imCSI(K) + sum(Decbits_imCSI ~= Bits(nPilot:blocklength)); 
    end
end
hEstMSE = hEstErr/nBlocks;
BER_pCSI = BER_pCSI/nData/nBlocks;
BER_imCSI = BER_imCSI/nData/nBlocks;

figure;
plot(SNRdb,10*log(hEstMSE),'b','LineWidth',2.0)
grid on
legend('Channel Estimation MSE')
xlabel('SNR(dB)')
ylabel('MSE (dB)')

figure;
semilogy(SNRdb,BER_pCSI,'b','LineWidth',2.0)
hold on
semilogy(SNRdb,BER_imCSI,'r','LineWidth',2.0)
grid on
legend('BER with perfect CSI','BER with Estimated CSI')
xlabel('SNR(dB)')
ylabel('BER')


