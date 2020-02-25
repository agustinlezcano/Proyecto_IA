cd  'F:\UNCUYO\IA_1\PROYECTO';
R= imread('gg.jpeg'); imshow (R);
F=rgb2gray(R);
I=imbinarize(F);
I=bwareaopen(I,100);
BW1 = edge(I,'Canny');
BW2 = edge(I,'Prewitt');
imshowpair(BW1,BW2,'montage'), title('Comparison');
