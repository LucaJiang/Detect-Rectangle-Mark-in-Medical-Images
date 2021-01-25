[x,y,aim] = detect_rectangle_mark(img);

if isempty(aim)
  imshow(img)
  grid on
  [x_inp,y_inp]=ginput(2);
  x=[x_inp(1) x_inp(2) x_inp(2) x_inp(1)];
  y=[y_inp(1) y_inp(1) y_inp(2) y_inp(2)];
  aim = img(y(1):y(3), x(1):x(2), :);
end
imshow(aim)

imshow(img)
hold on
plot(x,y,'r')
hold off
