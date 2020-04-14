function L_filtered = TwoDfilter(L, ctrSF, s);


% L = GetLuminanceImage(filename);
% ctrSF = 0.06; % center SF
% s = 0.02; % sigma of Gaussian function



% calculate the number of points for FFT (power of 2)
FFT_pts = 2 .^ ceil(log2(size(L)));

[A fx fy mfx mfy] = Myff2(L, FFT_pts(1), FFT_pts(2));

SF = sqrt(mfx .^ 2 + mfy .^ 2);

% SF-bandpass and orientation-unselective filter
filt = exp(-(SF - ctrSF) .^ 2 / (2 * s ^ 2));

A_filtered = filt .* A; % SF filtering
L_filtered = real(ifft2(ifftshift(A_filtered))); % IFFT
L_filtered = L_filtered(1: size(L, 1), 1: size(L, 2));