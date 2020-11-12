# 检测医学图像中的矩形标记
使用形态学开运算和霍夫变换检测医学图像中的白色矩形标记。


## 目录
  * [背景](#背景)
  * [方法](#方法)
  * [结果](#结果)
  * [MATLAB代码](#代码)


## 背景

医学图像中常常有医生标记的感兴趣的区域。一般而言，在建立深度学习模型之前，需要手动将这些区域选出。但是手动操作非常花时间，并且可能引入额外的人工误差。这个项目提出一种基于图形学方法来自动选择这些区域。 

以这个甲状腺超声（US）图像为例，中间的黑色阴影是甲状腺结节。周围的白色细框是一个标记。 我们需要获取医生认为有价值的区域的图像，并根据这些区域建立模型。

<p align="center">
<img src="img/ori.jpg" alt="ultrasound(US) images" width="250" height="250"  />
</p>

如果白框的灰度稳定，比如为某个固定的值。我们很容易能通过计算机程序定位白框。然而不幸的是，大多数情况下，白框的灰度会受背景颜色的影响。我们常常用于探测直线的霍夫变换在这儿也会失效。医学图像中往往有干扰元素。比如此例中颈部皮肤和肌肉的分界线就很容易被计算机误判为白框的一部分。实话实说，这种图手动处理也很费劲，因为白线太细了。

综上所述，我们很难在医学图像中检测出白色矩形标记。而且我没有在互联网或论文上找到合适的方法来解决此类问题。因此，我提出了一种基于形态学运算和霍夫变换的方法。 *顺便说一句，我建议您在处理后应该自己检查一下。 尽管此程序运行良好，但在某些特殊情况下可能会失败。*

## 方法

为了应用霍夫变换，我们需要将白线与背景分开。因此，首先我们在**灰度图像**上应用**开运算**。开运算是先腐蚀再膨胀，这两个操作使用相同的结构元素。详细信息，请参见[这](https://www.mathworks.com/help/images/ref/imopen.html#f5-345703_seealso)。

然后，我们可以轻松地应付接下来的情况（请参见结果中间一行图片）。在这里，我应用了**霍夫变换**，但是您可以使用任何您想用的方法。霍夫变换的理论可以在[这](https://en.wikipedia.org/wiki/Hough_transform)找到。

上述过程核心 MATLAB 代码如下所示。
```matlab
% to gray scale images
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

## 结果

结果如下所示。

![Diagram of method 1](img/result_method1.png)

## 代码

MATLAB 代码在[这](code.m).

## Note

霍夫变换后的点定位处理可以改进。例如，插入try-catch异常捕捉模块。但是目前的效果已经达到我的需求。