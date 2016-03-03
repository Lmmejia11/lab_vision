% Cargar imagenes
Im1 = im2double(imread('procesada_hija.jpg'));
Im2 = im2double(imread('procesada_madre.jpg'));

% Filtro pasa-bajas
k = fspecial('gaussian',20,2);
FIm1 = imfilter(Im1,k);

% Filtro pasa-altas
k = fspecial('gaussian',20,4); %20,4
FIm2 = Im2 - imfilter(Im2,k);

% Imagen hybrida
H = (FIm1+FIm2);

% Visualizar
imshow(H);