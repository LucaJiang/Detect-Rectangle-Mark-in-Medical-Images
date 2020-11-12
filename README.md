# Detect Rectangle Mark in Medical Images
Detect white rectangle mark in medical images, using morphological opening and Hough transform.

中文版 readme, 见 [这](README_zhCN.md).

## Content
  * [Background](#background)
  * [Method](#method)
  * [Result](#result)
  * [MATLAB Code](#code)

## Background

Medical images often have regions of interest marked by doctors. Generally speaking, before building a deep learning model, we need to manually select these areas, which is time-consuming and may introduce extra errors. This repo proposes a graphics-based method to select these areas automatically.

Take this thyroid ultrasound(US) image for example. The black shadow in the middle is a thyroid nodule. The thin white box around it is a mark. We need to obtain images of areas deemed valuable by doctors and build models based on those areas. 

<p align="center">
<img src="img/ori.jpg" alt="ultrasound(US) images" width="250" height="250" />
</p>

If the gray scale of the white box is stable. For example, it is a fixed value. We can easily locate the white box through a computer program. Unfortunately, in most cases, the gray scale would be affected by the background color. 

We generally use hough transform to detect straight lines. However, medical images often have interference elements. For example, in this case, the dividing line between the skin and muscles of the neck could be easily misjudged by the computer as part of the white box. That's why hough transform can not be applied directly.

Besides, to be honest, manual processing of this kind of images is also very laborious. Because the lines are too thin.

To sum up, it is difficult to detect  white rectangle mark in medical images. And I failed to find a suitable way to deal with such problem on the internet or papers. So I try my best to propose my own ideas on it.

In the following sections, I propose a method based on morphological operations and hough transform. *BTW, I suggest that you should check it yourself after processing. Although this program works well, it could fail in some special cases.*


## Method

In order to apply hough transform, we need to separate white line from interference background. So, firstly, we apply **morphological opening** on the **gray scale images**. The morphological open operation is an erosion followed by a dilation, using the same structuring element for both operations. For more details, see [here](https://www.mathworks.com/help/images/ref/imopen.html#f5-345703_seealso).

Then, we can easily detect the mark in current situation (see the middle row of result). Here, I apply **hough transform**, but you can use whatever you want. The theory of hough transform can be found [here](https://en.wikipedia.org/wiki/Hough_transform).

The core MATLAB codes of this process are
```matlab
% get gray scale images
img = rgb2gray(ori_img);

% morphological operations
background = imopen(img, strel('disk', disk_size));
sub = imsubtract(img, background);
ind = sub >= min_sub;
imshow(ind)

% hough transform
[n, m] = size(ind);
[H,T,R] = hough(ind);
P = houghpeaks(H, 4, 'threshold', ceil(0.2*max(H(:))));
lines = houghlines(ind, T, R, P, 'FillGap', 
                FillGap_value,'MinLength', MinLength_value);
% cropping along lines
...
```

## Result

The results show as follows.

![Diagram of method 1](img/result_method1.png)

## Code

MATLAB code available at [here](code.m).

## Note

The processing of locating the point after the Hough transform could be improved. Insert try-catch exception module, for instance. But the current processing effect has reached my requirements.