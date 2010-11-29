%%
clear
close all

N = 1024;
N_I = 256;
k = 2;

q = get_q_RANSAC(N, N_I, k);

M_max = N_I/k;

for m = 1:M_max

    N_I_ = round(N_I/m);
    N_ = round(N/m);
%     N_I_ = (N_I/m);
%     N_ = (N/m);
    
    num = N_I_:-1:N_I_-k+1;
    den = N_:-1:N_-k+1;
    q_dis(m) = 1 - (1-prod(num./den))^m;
    
end;
q_cen = 1-(1-q).^(1:M_max);


figure; 
hold on
plot(1:M_max, q_dis, 'r', 'LineWidth', 2)
plot(1:M_max, q_cen, '--b', 'LineWidth', 2)
xlabel('Number of Measurement Sensors')
ylabel('Probability of Finding a good MSS')
title(sprintf('N = %d, N_I = %d, k = %d', N, N_I, k))
axis tight
legend('Distributed', 'Centralized')
