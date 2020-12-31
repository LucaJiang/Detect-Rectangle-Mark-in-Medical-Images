[x,y,aim] = detect_rectangle_mark(img);
imshow(aim)

imshow(img)
hold on
plot(x,y,'r')
hold off
