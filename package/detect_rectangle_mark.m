function [x,y,aim] = detect_rectangle_mark(img)
%detect_rectangle_mark.m Detect white rectangle mark in medical images
% Detect white rectangle mark in medical images,
%   using morphological opening and Hough transform.
% input: img
% output: x location of the white rectangle mark
%         y location of the white rectangle mark
%       aim img in rectangle
% author        JiangWX, cxt213
% date          2020.Dec.31
% version       0.1.0
% software      MATLAB R2020b with Image Processing Toolbox

% read original image
oripic = img;
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

%check if the aspect ratio of aim is normal
aim_width=x(2)-x(1);
aim_height=y(2)-y(1);
aim_r=aim_height/aim_width;
if aim_r>asp_ratio
    x=[];
    y=[];
    aim=[];
else  
    x = [x(1) x(2) x(2) x(1)];
    y = [y(1) y(1) y(2) y(2)];
    aim = oripic(y(1):y(3), x(1):x(2), :);
end

end

