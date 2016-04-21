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

Las redes se inicializan con la función *initializeTexturCNN.m* y *MAXinitializeTextureCNN.m* respectivamente. Después de inicializadas, la fase de entrenamiento se encuentra dentro de la función *texture_exercise.m*. Anidada a esta función, se encuentra *getBatch*, y *getBatchWithJitter*, las cuales preparan el siguiente batch, sin o con jitter. Finalmente, la red es evaluada en el conjunto de validación por la función *train_net.m*.

Nos basamos en el ejemplo para la estructura general. Se observó que en el ejemplo de letras, utilizaban maxpooling y ningún Relu, pero en imagenetVGG siempre utilizaban Relu entre capas. Por lo tanto, se quiso hacer ambas. Se prefirió, en la primera red, reducir el tamaño con convolución con stride 2, en vez de maxpooling porque se realizarían menos consolaciones y el tiempo de entrenamiento y numero de parámetros sería menor. Como con esta red, solo se logró un máximo de 10% ACA, en la segunda red fuimos menos conservadoras. Agregamos otra capa convolución, y realizamos Maxpoolin en vez de strides en las convoluciones. Cabe agregar que el tamaño de los filtros y el número de maxpooling fueron escogidos teniendo en cuenta que se debería reducir una matriz de 128x128x1 a una de 1x1x25. Adicionalmente, se consideraron solo filtros de tamaño pequeño para reducir el tiempo de procesamiento.

## Resultados de experimentación

### Net1

Todos los experimeentos se realizaron con 5 epocas.

Batch| LearningRate | ACA_Train | ACA_Val | Train time
-----|--------------|-----------|-------|--------------
100|10^-2|4.00%|4.00%|11050 sec
100|10^-3|4.01%|4.00%|6926 sec
100|10^-4|6.75%|6.63%|8693 sec

Batch | LearningRate | ACA_Train | ACA_Val | Train time
-----------|--------------|-----------|-------|---------
50|10^-3|5.50%|5.59%|24524 sec
50|10^-4|9.54%|9.15%|18035 sec
50 con jit|10^-4| 7.54%|7.69%|9817 sec
50|10^-5|9.52%|9.23%|8688 sec
50 con jit|10^-5|8.12%|8.13%|6425 sec

Batch | LearningRate | ACA_Train | ACA_Val | Train time
-----------|--------------|-----------|----|---------
30|10^-4|9.00%|8.79%|7638 sec
30|10^-5|5.50%|5.59%|6171 sec

Batch | LearningRate | ACA_Train | ACA_Val | Train time
-----------|--------------|-----------|----|---------
40|10^-4|9.02%|8.85%|8058 sec
40|10^-5|10.81%|10.57%|6171 sec
40 con jit| 10^-5|10.13%|9.85%|6425 sec
40|10^-6|5.42%|5.37%|12819 sec

Para el jitter, se reflejaban las imagenes en el ejex, ejey y la diagonal. Pero los resultados siempre fueron menores cuando se utilizó. Por esta razón, se decidió no utilizarlo.

Como es de esperarse, aumentar el numero de epocas, siempre aumenta el ACA, esto lo confirmamos realizando unicamente un experimento con 10 epocas. Los parametros utilizados para este fueron batch=100, L_rate=10^-3. En este obtuvimos un ACA de 5.03% para entrenamiento y 4.84% para validación, el tiempo de entrenamiento fue de 34588 sec. Al comparar con los valores obtenidos con los mismos parámetros pero con 5 epocas observamos que el ACA mejoró y el tiempo aumentó x5. 

### Net2

Batch | LearningRate | ACA_Train | ACA_Val | Train time
-----------|--------------|-----------|--------|--------
60|10^-4|4.00%|4.00%|4076 sec 
60|10^-5|5.28%|5.27%|3091 sec
60|10^-6|6.11%|5.85%|3339 sec
40|10^-4|4.82%|4.70%|4730 sec
40|10^-5|4.04%|4.06%|3619 sec
40|10^-6|6.75%|6.24%|3093 sec
40|10^-7|4.91%|4.74%|19654 sec

A pesar de los resultados esperados, en los que se creía que la red más larga entrenaría mejor, basadas en los experimentos realizados la red pequeña fue mejor. Sin embargo dado el tiempo no se lograron realizar más experimentos con la red neuronal larga y no podemos comparar para todos las variaciones de parámetros los resultados. Es probable que la red más larga tuviera necesidad de otros parámetros para poder entrenar así como de más imágenes debido al que el número de pesos que debe aprender es grande. 

Finalmente se eligió la red neuronal pequeña con batches de 40 imágenes y un learning rate de 10^-5. 


