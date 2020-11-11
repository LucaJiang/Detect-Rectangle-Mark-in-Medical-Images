% author        JiangWX
% date          2020.Nov.11 Wed.
% version       0.1.0
% software      MATLAB R2020b with Image Processing Toolbox

%-----------------------------------------------%
% Detect white rectangle mark in medical images, 
%   using morphological opening and Hough transform.
% input: img_name
% output: aim
%-----------------------------------------------%
% read original image 
img_name = imread('img.jpg');
oripic = img_name;
%----------------SETTINGS-----------------------%
% parameters could be adjusting
disk_size = 1; % disk size of imopen
min_sub = 40; % threshold of imsubtract
FillGap_value = 100; % params of hough
MinLength_value = 150; % params of hough
%-----------------------------------------------%
% get gray scale images
pic = rgb2gray(oripic);

% morphological operations
background = imopen(pic, strel('disk', disk_size));
sub = imsubtract(pic, background);
ind = sub >= min_sub;
[n, m]  =  size(ind);

% hough transform
[H, T, R]  =  hough(ind);
P  =  houghpeaks(H, 4, 'threshold', ceil(0.2*max(H(:))));
lines  =  houghlines(ind, T, R, P, 'FillGap', FillGap_value, 'MinLength', MinLength_value);

% obtain locations
to = zeros(length(lines), 2);
from = to;
for i = 1:length(lines)
    from(i, :) = lines(i).point1;
    to(i, :) = lines(i).point2;
end

% get the inner locations of box
x = zeros(1, 2);
y = x;
x(1) = min(from(:, 1))+2;
x(2) = max(from(:, 1))-2;
y(1) = min(from(:, 2))+2;
y(2) = max(to(:, 2))-2;
aim = oripic(y(1):y(2), x(1):x(2), :);

% show results
imshow(aim)
imwrite(aim, 'aim.jpg')

% END