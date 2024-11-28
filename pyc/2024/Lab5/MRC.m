%Refershing Terminal & Workspace
clc
clear

L = 5;
L1 = 1;
nPilot = 10;
nData = 1e3;
blocklength = nPilot+nData;
nBlocks = 2e3;
SNRdb = 0:0.5:15;
SNR = 10.^(SNRdb/10);

No = 1;
BER_pCSI = zeros(size(SNRdb)); % BER of perfect chanel

for blk = 1:nBlocks
    h1 = randn(L,1) + 1j*randn(L,1);
    
    h5 = randn + 1j*randn;% 1. Generate complex gaussian channel
    Bits = randi([0,1],1,blocklength); % 2. Generate bits of length equal to blocklength
    Sym = 2 * Bits - 1;%2. Generate BPSK symbols, ie map bit 1--->+1 and 0--->-1
    pSym = Sym(1:nPilot); % 4. generate/get nPilot number of pilot symbols
    pNorm = norm(pSym.*pSym); % 5. Calculate the norm square of pilot symbols
    noise = sqrt(No/2)*(randn(L,blocklength) + 1j*randn(L,blocklength));
    
    
    

    omega = (h1)/(norm(h1));

    
    % Generate complex noise of variance N0 
    for K = 1: length(SNRdb)
        TxSym = sqrt(SNR(K))*Sym;  % Generate transmit symbol 
        RxSym = h1.*(TxSym) + noise;  % Calculate the received symbol
        RxSym = ctranspose(omega)*RxSym;
        EqSym_pCSI = RxSym; % Equlization of perfect channel
        Decbits_pCSI = (EqSym_pCSI > 0); % Make decision based on received symbols to recover the bits under perfect channel
        BER_pCSI(K) = BER_pCSI(K) + sum(Decbits_pCSI ~= Bits); % Calculate BER of perfect channel
       
        
    end
end

BER_pCSI = BER_pCSI/nData/nBlocks;


figure;
semilogy(SNRdb,BER_pCSI,'b','LineWidth',2.0)
hold on;
grid on




for blk = 1:nBlocks
    h1 = randn(L1,1) + 1j*randn(L1,1);
    
    h5 = randn + 1j*randn;% 1. Generate complex gaussian channel
    Bits = randi([0,1],1,blocklength); % 2. Generate bits of length equal to blocklength
    Sym = 2 * Bits - 1;%2. Generate BPSK symbols, ie map bit 1--->+1 and 0--->-1
    pSym = Sym(1:nPilot); % 4. generate/get nPilot number of pilot symbols
    pNorm = norm(pSym.*pSym); % 5. Calculate the norm square of pilot symbols
    noise = sqrt(No/2)*(randn(L1,blocklength) + 1j*randn(L1,blocklength));
    
    
    

    omega = (h1)/(norm(h1));

    
    % Generate complex noise of variance N0 
    for K = 1: length(SNRdb)
        TxSym = sqrt(SNR(K))*Sym;  % Generate transmit symbol 
        RxSym = h1.*(TxSym) + noise;  % Calculate the received symbol
        RxSym = ctranspose(omega)*RxSym;
        EqSym_pCSI = RxSym; % Equlization of perfect channel
        Decbits_pCSI = (EqSym_pCSI > 0); % Make decision based on received symbols to recover the bits under perfect channel
        BER_pCSI(K) = BER_pCSI(K) + sum(Decbits_pCSI ~= Bits); % Calculate BER of perfect channel
       
        
    end
end

BER_pCSI = BER_pCSI/nData/nBlocks;



semilogy(SNRdb,BER_pCSI,'r','LineWidth',2.0)

title('BPSK BER for MRC for L=1 and L=5')
xlabel('SNR');
ylabel('BER');
legend("L=5","L = 1")
grid on



