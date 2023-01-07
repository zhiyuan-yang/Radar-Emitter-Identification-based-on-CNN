function [ sig, RF_measured ,Fs, IF] = Intra_pulse_IF_sig( RF,BW,PW,MT)
%UNTITLED 此处显示有关此函数的摘要
%RF,射频频率范围：8-12 GHz
%BW,带宽范围：0或5-100 MHz 输入BW参数仅对线性调频有效
%PW,脉宽范围：1-20 us
%MT，调制方式：数字 0-9
%   此处显示详细说明
    IF=200e6;
    Fs=500e6;%采样率500MHz
    N=PW*Fs;
    t=(0:N-1)/Fs+rand(1)/Fs;
    switch MT
        case 0 %单频 BW参数无效
            sig=exp(1i*2*pi*IF.*t);
        case 1 %上调频
            K=BW/PW;
            sig=exp(1i*pi*K.*t.^2).*exp(1i*2*pi*(IF-BW/2).*t);
        case 2 %下调频
            K=BW/PW;
            sig=exp(-1i*pi*K.*t.^2).*exp(1i*2*pi*(IF+BW/2).*t);
        case 3 %巴克码7
            Barker=[1,1,1,-1,-1,1,-1];%7
            Code_len=length(Barker);
            sig=exp(1i*2*pi*IF.*t);            
            sig=sig.*Barker(ceil(t/PW*Code_len));        
        case 4 %巴克码11
            Barker=[1,1,1,-1,-1,-1,1,-1,-1,1,-1];%11
            Code_len=length(Barker);
            sig=exp(1i*2*pi*IF.*t);            
            sig=sig.*Barker(ceil(t/PW*Code_len));            
        case 5 %巴克码13
            Barker=[1,1,1,1,1,-1,-1,1,1,-1,1,-1,1];%13
            Code_len=length(Barker);
            sig=exp(1i*2*pi*IF.*t);            
            sig=sig.*Barker(ceil(t/PW*Code_len));
        case 6 %costas1 BW参数输入无效， BW*PW=N^2，1-20 us 1.8-36MHz
            Costas=[3,2,6,4,5,1];%[2,4,8,5,10,9,7,3,6,1];%[3,2,6,4,5,1];
            Code_len=length(Costas);
            f_code=Code_len/PW*(1:Code_len);
            f_code=f_code+IF-(f_code(Code_len)+f_code(1))/2;
            f_code=f_code(Costas);
            ft=f_code(ceil(t/PW*Code_len));
            sig=exp(1i*2*pi*ft.*t); 
        case 7 %costas2 BW参数输入无效， BW*PW=N^2，1-20 us 1.8-36MHz
            Costas=[5,4,6,2,3,1];%[6,3,7,9,10,5,8,4,2,1];%[5,4,6,2,3,1];
            Code_len=length(Costas);
            f_code=Code_len/PW*(1:Code_len);
            f_code=f_code+IF-(f_code(Code_len)+f_code(1))/2;
            f_code=f_code(Costas);
            ft=f_code(ceil(t/PW*Code_len));
            sig=exp(1i*2*pi*ft.*t);
        case 8 %Frank码
            K=4;%4相
            prime=3;%K的质因子
            M_p=(0:K-1)'*(0:K-1);
            Frank=(exp(1i.*M_p(:).*(2*pi*prime/K)))';
            Code_len=length(Frank);
            sig=exp(1i*2*pi*IF.*t);            
            sig=sig.*Frank(ceil(t/PW*Code_len));
        case 9 %P1码
            K=4;%4相
            M1=repmat((1:K),K,1);
            M2=repmat((1:K)',1,K);
            M_p=((M1-1)*K+M2-1).*(K-2*M1+1).*(-pi/K);
            P1=(exp(1i.*M_p(:)))';
            Code_len=length(P1);
            sig=exp(1i*2*pi*IF.*t);            
            sig=sig.*P1(ceil(t/PW*Code_len));                        
    end
    RF_measured=RF+RF/1000*(rand(1)-0.5);
%     [x,y]=size(sig);
%     sig=sig+wgn(x,y,1/SNR);  
end

