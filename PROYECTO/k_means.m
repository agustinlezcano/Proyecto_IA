%%K-means
%Propongo los centroides

%Obtengo la matriz con base de datos
matriz=load('matriz.mat');
matriz=cell2mat(struct2cell(matriz));

valor=load('caracteristicas.mat');
valor=cell2mat(struct2cell(valor)); %Importo las características de la foto

p=4;
k=zeros(2,p);
for i=1:4
    k(1,i)=rand;
    k(2,i)=rand;
end
disp('k inicial')
k
cont=zeros(p,1);            %Contador para numero de menores distancias
flag=true;
%dif=[10 0 0 0];               %la diferencia entre cada K y c/punto
j=1;
sum=zeros(2,p);                 %Matriz auxiliar de suma
k_nuevo=zeros(2,p);
dist=zeros(p,muestra);
vector=zeros(1,muestra);
vector_viejo=zeros(1,muestra);
limite=10;

while flag==true
    for i=1:p
        [xx,yy] = meshgrid((matriz(1,:)-k(1,i)),(matriz(2,:)-k(2,i)));
        distancia=sqrt(xx.^2+yy.^2);
        dist(i,:)=(diag(distancia))';
    end
    %Ubicacion de los baricentros
    for i=1:muestra
        for j=1:p
            if dist(j,i)<limite
                jmin=j;
                limite=dist(j,i);
            end
        end
        %Suma para sacar la nueva media ACA ESTA EL ERROR
        sum(1,jmin)=sum(1,jmin)+matriz(1,i);
        sum(2,jmin)=sum(2,jmin)+matriz(2,i);
        cont(jmin)=cont(jmin)+1;
        %dif=[10 0 0 0];
        limite=10;
        vector(i)=jmin;         %Vector que sera bandera
    end
    %Obtengo los nuevos k
    for j=1:p
        if cont(j)~=0
            k_nuevo(1,j)=(sum(1,j)+k(1,j))/(cont(j)+1);     %Se suma uno porque cuento los puntos cercanos MÁS
            k_nuevo(2,j)=(sum(2,j)+k(2,j))/(cont(j)+1);     %el baricentro
        else
            k_nuevo(1,j)=k(1,j);
            k_nuevo(2,j)=k(2,j);
        end
       
    end
     if vector==vector_viejo
            flag=false;
        else
            vector_viejo=vector;
            k=k_nuevo;
     end
     %for i=1:muestra
         
end

disp('k final')
k
figure
scatter(matriz(1,:), matriz(2,:),  30, 'filled')       %vector(1,:),

%Distancia euclidiana a cada baricentro

[xx,yy]=meshgrid((k(1,:)-valor(1,1)),(k(2,:)-valor(2,1)));
distance=sqrt(xx.^2+yy.^2);
diff=(diag(distance))             %Distancia del objeto a c/punto
