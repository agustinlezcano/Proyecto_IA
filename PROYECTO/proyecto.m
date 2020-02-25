%cd  'media\datos\UNCUYO\IA_1\PROYECTO';         %Unicación de las imagenes

%Mirar de hacer con cd /media/datos...

%Poner acá las imagenes
imds = imageDatastore('media\datos\UNCUYO\IA_1\PROYECTO','FileExtensions',{'.jpeg'});

while hasdata(imds)
    img=read(imds);
    figure, imshow(img);
end