%%
clear 
close all

dim = 100:100000;

t = zeros(1, length(dim));
for h = 1:length(dim)
    
    tic
    A = zeros(1, dim(h));
    t(h) = toc;
    
    clear A 
end;
