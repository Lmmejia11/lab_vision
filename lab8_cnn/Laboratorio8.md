# Lab 8: CNN


## Integrantes
Maria Alejandra Barvo Sarmiento

Lina María Mejia Lopez

## Descripción:
Inicialmente, creamos dos networks diferentes: una con 4 capas de convolución, y otra con 5. A continuación describiremos brevemente cada una, y la intuición detrás de ellas.

Net1 | Net2
-------|--------
Convolución  5x5x1x20 stride = 1 | Convolución 5x5x1x20 stride = 1
Relu | Relu
NA | Maxpooling  2x2 stride 2
Convolución 9x9x20x70  con stride = 2| Convolución 5x5x20x70 con stride = 1
Relu | Relu
Maxpooling 2x2 stride de 2 | Maxpooling 2x2 stride de 2
Convolución 3x3x70x100 | Convolución 3x3x70x100
Relu | Relu
Maxpooling 3x3 stride 3 | Maxpooling 2x2 stride 2
Convolución 9x9x100x25 stride 1 | Convolución 3x3x100x200 stride 1
NA | Relu 
NA | Maxpooling 2x2 stride 2
NA | Convolución 6x6x200x25
Softmaxloss|Softmaxloss

Nos basamos en el ejemplo para la estructura general. Se observó que en el ejemplo de letras, utilizaban maxpooling y ningún Relu, pero en imagenetVGG siempre utilizaban Relu entre capas. Por lo tanto, se quiso hacer ambas. Se prefirió, en la primera red, reducir el tamaño con convolución con stride 2, en vez de maxpooling porque se realizarían menos consolaciones y el tiempo de entrenamiento y numero de parámetros sería menor. Como con esta red, solo se logró un máximo de 10% ACA, en la segunda red fuimos menos conservadoras. Agregamos otra capa convolución, y realizamos Maxpoolin en vez de strides en las convoluciones. Cabe agregar que el tamaño de los filtros y el número de maxpooling fueron escogidos teniendo en cuenta que se debería reducir una matriz de 128x128x1 a una de 1x1x25. Adicionalmente, se consideraron solo filtros de tamaño pequeño para reducir el tiempo de procesamiento.

## Resultados

### Net1
