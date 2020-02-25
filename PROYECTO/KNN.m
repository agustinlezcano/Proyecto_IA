%Algoritmo KNN
matriz=load('matriz.mat');          %Importo la base de datos
matriz=cell2mat(struct2cell(matriz));
valor=load('caracteristicas.mat');
valor=cell2mat(struct2cell(valor)); %Importo las características de la foto
etiqueta=load('etiqueta.mat');
etiqueta=cell2mat(struct2cell(etiqueta));

[a, n]=size(matriz);
%Distancia euclidiana a cada punto

[xx,yy]=meshgrid((matriz(1,:)-valor(1,1)),(matriz(2,:)-valor(2,1)));
distance=sqrt(xx.^2+yy.^2);
disp('vector de diferencias antes')
diff=(diag(distance))             %Distancia del objeto a c/punto

%Bubblesort (cambio de lugar etiquetas tambien)

swap=true;          %flag
while swap==true
swap=false;
    for i=2:n
        if diff(i-1)>diff(i)
            %Cambio de posiciones del vector de distancias
            aux=diff(i);
            diff(i)=diff(i-1);
            diff(i-1)=aux;
            %Cambio de posiciones del vector de etiquetas
            aux2=etiqueta(i);
            etiqueta(i)=etiqueta(i-1);
            etiqueta(i-1)=aux2;
            
            swap=true;
        end
    end
end
disp('vector de diferencias y etiquetas despues')
diff
etiqueta
%Selecciono el k
%variable=cell2str(etiqueta)
c=15;                    %Es el numero de K vecinos maximo
for i=1:c
    
    for j=1:i
        eti=etiqueta(1:i);
        %eti{j}=cambio;
        m=mode(eti');
    end
    %M=['Moda para k= ', num2str(i), ' ',num2str(m)];
    %disp(M)
    
end
    if m==1
        disp('el elemento es una arandela');
    elseif (m==2)
        disp('el elemento es un clavo');  
    elseif (m==3)
        disp('el elemento es un tornillo');
    else
        disp('el elemento es una tuerca');        
    end
%% 
%Ver como corregir esto
% for i=1:c
%     eti=strings([1,i]);
%     for j=1:size(eti)
%         cambio=etiqueta{j};
%         eti(1,j)=cambio;
%         disp('Para k= '),j;
%         m=mode(eti')
%     end
% end
