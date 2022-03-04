clear all
close all
clc

%% Load a full image
disp('Loading full image...')
A = imread('turtlebot', 'jpeg'); %Input image
figure()
imshow(A);

%% Make input image black and white (grey)
Abw = rgb2gray(A); %Built-in MATLAB commmand
[nx, ny] = size(Abw);
figure(1)
subplot(2, 2, 1);
imshow(Abw);
title('Original image', 'FontSize', 12)

%% Compute the FFt of our image using fft2
disp('Doing FFT analysis for sparsity check...')
At = fft2(Abw);
F = log(abs(fftshift(At))+1);
F = mat2gray(F); % Use mat2gray to scale image between 0 and 1
figure()
imshow(F, []); % displaying the FFT coefficients

%% Zero out all small coefficients and inverse transform
disp('Zeroing out small Fourier Coefficients')
count_pic = 2;
for thresh = [0.0001 0.0005 0.001] * max(max(abs(At)))
    ind = abs(At)>thresh;
    count = nx*ny - sum(sum(ind));
    Atlow = At.*ind;
    percent = 100-count/(nx*ny)*100;
    Alow = uint8(ifft2(Atlow));
    figure(1)
    subplot(2,2,count_pic)
    imshow(Alow);
    count_pic = count_pic+1;
%     drawnow
    title([num2str(percent) '% of FFT basis'], 'Fontsize', 18)
end

