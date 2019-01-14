%%_________________________________________________________________________
%% Multi-channel Superpixel Segmentation & user-guided k-means Clustering
%%_________________________________________________________________________
% for 3-channel images

% V.T. Bickel, September 2017 & January 2019
% valentin.bickel@erdw.ethz.ch
% ETH Zurich / MPS Goettingen

% MIT License
% Copyright (c) 2017 Valentin Tertius Bickel

% Please refer to this routine as:
% Bickel, V.T.
% "Multi-channel Superpixel Segmentation & user-guided k-means Clustering. 2017.

clear
clc

%% Read channels & Inputs
img = im2double(imread('thinsection.jpg'));
disp('Segmenting with:')
sup_pix = 1500 % number of used super-pixels, ADAPT MANUALLY!

%% Segmentation with Superpixels

img3chan = img(:,:,[1 2 3]);
[L2,NumLabels] = superpixels(img3chan,sup_pix); % careful with superpixels !!!
L = mod(L2,256);

figure
imshow(img); title("Original")

figure
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

figure
imshow(output,'InitialMagnification',sup_pix); title("Superpixel Median")
%imwrite(output,'segmented_image.tif','Compression','None');

%% User-guided k-means Clustering
red = output(:,:,1);
green = output(:,:,2);
blue = output(:,:,3);

figure
subplot(2,3,1); imshow(red); title("RED")
subplot(2,3,2); imshow(green); title("GREEN")
subplot(2,3,3); imshow(blue); title("BLUE")
subplot(2,3,4); imagesc(red); colormap hot
subplot(2,3,5); imagesc(green); colormap hot
subplot(2,3,6); imagesc(blue); colormap hot

clusters = input('Select number of clusters:');

figure
heatscatter(red(:),green(:),'.','density_plot.png','20','100','.')
colormap jet; xlabel('RED'); ylabel('GREEN')
figure
heatscatter(red(:),blue(:),'.','density_plot.png','20','100','.')
colormap jet; xlabel('RED'); ylabel('BLUE')
figure
heatscatter(blue(:),green(:),'.','density_plot.png','20','100','.')
colormap jet; xlabel('BLUE'); ylabel('GREEN')

channel_combo = input('Select Channel combination, RG = 1, RB = 2, BG = 3:');

if channel_combo == 1
    a = red(:);
    b = green(:);
end
if channel_combo == 2
    a = red(:);
    b = blue(:);
end
if channel_combo == 3
    a = blue(:);
    b = green(:);
end

combo(:,1) = a; combo(:,2) = b;
[idx,C] = kmeans(combo,clusters,'Replicates',5);

figure
for i = 1:clusters
    plot(combo(idx==i,1),combo(idx==i,2),'.','color',rand(1,3),'MarkerSize',12)
    hold on
    title("Clusters")
end

idx_2d = reshape(idx,[size(img,1),size(img,2)]);
figure
imshow(img); hold on
imagesc(idx_2d, 'AlphaData', .4); title('Classes');

display('Extract classes from variable idx or idx_2d')

% MIT License
% Copyright (c) 2017 Valentin Tertius Bickel