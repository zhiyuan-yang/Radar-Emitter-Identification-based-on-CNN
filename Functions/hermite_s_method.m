function tfr=hermite_s_method(sig, M, L, K)
% k for # of windows usually 4
% L for length of the window usually L<10
% M for N/8
d0=zeros(6, 6);
d0(1,:)=[1 0 0 0 0 0]; 
d0(2,:)=[1.5 -0.5 0 0 0 0];
d0(3,:)=[1.75 -1 0.25 0 0 0]; 
d0(4,:)=[1.875 -1.375 0.625 -0.125 0 0];
d0(5,:)=[1.937  -1.625 1 -0.375 0.062 0];
d0(6,:)=[1.968 -1.781 1.312 -0.687 0.219 -0.031];

% tx=(-M:M)'/(2*M+1)*6.5105;
% hx=zeros(2*M+1, 6);
% hx(:,1)=exp(-tx.^2/2)/pi^(1/4);
% hx(:,2)=exp(-tx.^2/2)*sqrt(2).*tx/pi^(1/4);
% for ii=3:6
%     hx(:,ii)=hx(:,ii-1).*tx*sqrt(2/ii) - hx(:,ii-2)*sqrt(1-1/ii);
% end
[hx, vx]=dpss(2*M+1, 3);

N=length(sig);
tfr=zeros(N, N); tfr0=tfr;
for kk=1:K
    [tfr_k tx fx]=tfrstft(sig, 1:N, N, hx(:,kk), 0);
    for ii=1:N,  tfr_k(:,ii)=fftshift(tfr_k(:,ii)); end;
    tfr0=abs(tfr_k).^2;
    for nn=1:N
        for ii=1:L
            index1 = mod(nn+ii-1,N)+1;
            index2 = mod(nn-ii-1,N)+1;
            tfr0(nn,:) = tfr0(nn,:) + 2*real(tfr_k(index1,:).*conj(tfr_k(index2,:)));          
        end
    end
    tfr=tfr+d0(K, kk)*tfr0;
end