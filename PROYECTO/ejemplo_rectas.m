cd  'F:\UNCUYO\IA_1\PROYECTO';         %Unicación de las imagenes

I=imread('tornillo1.jpeg');

imshow(I);

F=rgb2gray(I);

BWhite = edge(F,'canny');

[H,T,R] = hough(BWhite);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BWhite,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(I), hold on
max_len = 0;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% Highlight the longest line segment by coloring it cyan.
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');

%Luego ver de la longitud de xy_long y comparar clavos y tornillos