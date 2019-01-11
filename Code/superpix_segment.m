%%_________________________________________________________________________
%% Multi-channel Image Superpixel Segmentation
%%_________________________________________________________________________
% for 3-channel images

% V.T. Bickel, 15.9.17
% valentin.bickel@erdw.ethz.ch
% ETH Zurich / MPS Goettingen

% MIT License
% Copyright (c) 2017 Valentin Tertius Bickel

% Please refer to this routine as:
% Bickel, V.T.
% "Multi-channel Image Superpixel Segmentation. 2017.

clear
clc

%% Read channels & Inputs
img = im2double(imread('outcrop.jpg'));
disp('Segmenting with:')
sup_pix = 1500 % number of used super-pixels, ADAPT MANUALLY!

%% ------------------- Segmentation with Superpixels ----------------------

img3chan = img(:,:,[1 2 3]);
[L2,NumLabels] = superpixels(img3chan,sup_pix); % careful with superpixels !!!
L = mod(L2,256);

figure(1)
imshow(img)

figure(2)
BW = boundarymask(L);
imshow(imoverlay(img3chan,BW,'red'),'InitialMagnification',sup_pix)

output = zeros(size(img3chan),'like',img3chan);
idx = label2idx(L2);
numRows = size(img3chan,1);
numCols = size(img3chan,2);
for labelVal = 1:NumLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    output(redIdx) = median(img3chan(redIdx));
    output(greenIdx) = median(img3chan(greenIdx));
    output(blueIdx) = median(img3chan(blueIdx));
end    

figure(3)
imshow(output,'InitialMagnification',sup_pix)
%imwrite(output,'segmented_image.tif','Compression','None');

% MIT License
% Copyright (c) 2017 Valentin Tertius Bickel