cd  'F:\UNCUYO\IA_1\PROYECTO';         %Unicación de las imagenes

%Mirar de hacer con cd /media/datos... para Linux. Se usa PWD para conocer
%el path

%Base de datos con la Carpeta que contiene a las imágenes
imds = imageDatastore('F:\UNCUYO\IA_1\PROYECTO','FileExtensions',{'.jpeg','.jpg','.png'});

%%
%Matriz de excentricidad y forma (dimension 2 x n) de cada objeto
A=dir('*.jpeg');        % dir cuenta los archivos con la extension jpeg
B=dir('*.jpg');
n=length(A);
m=length(B);
muestra=n+m;
matriz = zeros(2,(muestra)); %Matriz donde se ponen los datos
etiqueta=zeros(1,muestra);        %zeros(1,(muestra));
i=1;

while hasdata(imds)
    

    img=read(imds);
    
    %Separa los canales
    img_R=img(:,:,1);   %Rojo
    img_G=img(:,:,2);   %Verde
    img_B=img(:,:,3);   %Azul
    
    %Niveles de los cancales RGB
    levelr=0.10;
    levelg=0.90;
    levelb=0.10;
    
    i1=imbinarize(img_R,levelr);
    i2=imbinarize(img_G,levelg);
    i3=imbinarize(img_B,levelb);
    
%     figure
%     subplot(2,2,1), imshow(img_R), title('red chanel')
%     subplot(2,2,2), imshow(img_G), title('green chanel')
%     subplot(2,2,3), imshow(img_B), title('blue chanel')
%     
%     %Para dar nitidez a la imagen 
%     imgsum=(i1&i2&i3);
%     subplot(2,2,4), imshow(imgsum), title('suma de los planos') 
    %La suma de los planos no resulta bien ya que se sacò la foto con flash 
    %y hay un brillo blanco en toda la foto
    
    I=rgb2gray(img); black = imbinarize(I); 
    %figure, subplot(2,1,1); imshow (black);
    black = bwareaopen(black,10000); %imshow(black), title('aca se ve el cambio');        %Elimina ruidos
    [B,L] = bwboundaries(black,'noholes');
    %imshow(label2rgb(L,@jet,[.5 .5 .5])); hold on; 
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
    end
    %Convertir a escala de grises
%     igray = rgb2gray(img);
%     figure
%     imshow(igray), title('igray');
%Esta opcion no funciona bien
    
    %Invertir las imàgenes
%      complement = imcomplement(imgsum);
%      completo = imfill (complement, 'holes');
%      figure, imshow (completo), title('rellenado ');
    
    %Pruebo con fondo verde
    f_verde=imcomplement(img_G);
    completo2= imfill(f_verde,'holes');
    %figure
    %subplot(2,1,1), imshow (completo2), title('rellenado para fondo verde ');
    
    %La misma con fondo verde pero pasada a blanco y negro
    BW=imbinarize(completo2);
    subplot(2,1,2), imshow(BW), title ('invertido');
    
    %Calcular cuantas lineas rectas hay (si hay)
    BWhite = edge(completo2,'Prewitt');
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CORRECCION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figure
%     imshow(BWhite), title('ESTE ES BWHITE')
    
    [H,T,R] = hough(BWhite);
    imshow(H,[],'XData',T,'YData',R,...
                'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;

    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    %plot(x,y,'s','color','white');

    lines = houghlines(BWhite,T,R,P,'FillGap',5,'MinLength',7);
   % figure, imshow(I), hold on
    max_len = 0;

    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

%       Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end

    % Highlight the longest line segment by coloring it cyan.
%     plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');

    %Luego ver de la longitud de xy_long y comparar clavos y tornillos
    
    
    %Pongo el numero de lineas para diferenciar tornillo y clavo
    matriz(2,i)=length(lines)/10;
    
    %Elijo las formas 
    
    
    
    %Buscar por formas
     se=strel('disk',0);
     Iopened=imopen(completo2, se);
     
%      figure
%      subplot(2,1,1), imshow(Iopened), title('rellenado y sacado por formas');
     BW2=imbinarize(Iopened);
%      subplot(2,1,2), imshow(BW2), title (strcat('invertido ' ,' ', num2str(i)));
     
     
     %Calculo de la circularidad de cada imagen
    %Perímetro
    CC=regionprops(BW,'Perimeter','Area','Eccentricity');       %Si no probar con Eccentricity
    peri=CC.Perimeter;
    area=CC.Area;
    exen=CC.Eccentricity;
    Circularity=(4*area*pi)/((peri)^2);
    %Otra forma
    Perim_calculado=sqrt(4*pi*area);
    
    %Circularity=Perim_calculado/peri;
    
    
    matriz(1,i)=exen;    %Falta normalizar
 
    %Etiquetado de la muestra
    if i<11
        etiqueta(1,i)=1;    % 'arandela';
    elseif (i>10 && i<21)
        etiqueta(1,i)=2;    %'clavo';  
    elseif (i>20 && i<31)
        etiqueta(1,i)=3;    %'tornillo';
    else
        etiqueta(1,i)=4;    %'tuerca';        
    end
i=i+1;      %suma de las posiciones para cada sector de la matriz
% Corregir la luz incidente en la foto
%   level=0.55;
%   Ithresh= imbinarize(igray, level);
%   imshowpair(img, Ithresh, 'montage');
%%
end

%Matriz=[num2cell(matriz); etiqueta];    %Guardo la matriz con caracteristicas y concateno etiquetas
                                         %Despues se debe cambiar el formato   
save('matriz.mat','matriz');
save('etiqueta.mat','etiqueta');



