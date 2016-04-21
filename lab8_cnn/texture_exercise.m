function texture_exercise(batch, epoch, rate, pjit)
% EXERCISE Lab 8 cnn textures
% jit = 0:NO jitter modification, 1:jitter modification
% clear ;
setup ;

% -------------------------------------------------------------------------
% 1. Prepare the data
% -------------------------------------------------------------------------

% Load texture dataset
imdb = load('dataTexture/textonsdb.mat') ;

% Separate train and validate
rng(1);
train_index = find(mod(0:length(imdb.images.id)-1,2) < 1) ;
val_index = setdiff(1:length(imdb.images.id),train_index) ;
imdb.images.set(1,val_index)=2;

% Visualize some of the data of class class form 1 to 25
% showClass = 15;
% figure(1) ; clf ; colormap gray ;
% subplot(1,2,1) ;
% vl_imarraysc(imdb.images.data(:,:,imdb.images.label==showClass & imdb.images.set==1)) ;
% axis image off ;
% title(['training images for ' imdb.meta.classes(showClass)]) ;
% 
% subplot(1,2,2) ;
% vl_imarraysc(imdb.images.data(:,:,imdb.images.label==showClass & imdb.images.set==2)) ;
% axis image off ;
% title(['validation images for ' imdb.meta.classes(showClass)]) ;

% -------------------------------------------------------------------------
%% 2. Initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializeTextureCNN() ;
vl_simplenn_display(net) ;

% -------------------------------------------------------------------------
%% 3. Set to train and evaluate the CNN
% -------------------------------------------------------------------------
batch=40; epoch=10; rate=5; pjit=0;
trainOpts.batchSize = 100 ;
trainOpts.numEpochs = 5 ;
trainOpts.continue = true ;
trainOpts.learningRate = 0.001 ;
trainOpts.useGpu = false ;
jit = 0;

if nargin >= 1
    trainOpts.batchSize = batch;
end
if nargin >= 2
    trainOpts.numEpochs = epoch;
end
if nargin >=3
    trainOpts.learningRate = 10^(-rate);
end
if nargin >=4
    jit = pjit;
end

if jit
trainOpts.expDir = ['dataTexture/experiment_b' num2str(trainOpts.batchSize)...
    '_e' num2str(trainOpts.numEpochs) '_r' num2str(-log10(trainOpts.learningRate)) '_jit/'] ;
else
trainOpts.expDir = ['dataTexture/experiment_b' num2str(trainOpts.batchSize)...
    '_e' num2str(trainOpts.numEpochs) '_r' num2str(-log10(trainOpts.learningRate)) '/'];
end
mkdir(trainOpts.expDir);
trainOpts = vl_argparse(trainOpts, '');

% Take the average image out
imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;

% Convert to a GPU array if needed
if trainOpts.useGpu
  imdb.images.data = gpuArray(imdb.images.data) ;
end

% -------------------------------------------------------------------------
%% 4. Train the CNN with function in MatConvNet
% -------------------------------------------------------------------------

% Call training 
trainOpts.trainTime = tic;
if jit
    [net,info] = cnn_train(net, imdb, @getBatchWithJitter, trainOpts) ;
else
    [net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;
end

% Move the CNN back to the CPU if it was trained on the GPU
if trainOpts.useGpu
  net = vl_simplenn_move(net, 'cpu') ;
end
trainOpts.trainTime = toc(trainOpts.trainTime);

% Save the result for later use
net.layers(end) = [] ;
net.imageMean = imageMean ;
save([trainOpts.expDir 'texture_net.mat'], '-struct', 'net') ;
save([trainOpts.expDir 'options.mat'], 'trainOpts') ;

% -------------------------------------------------------------------------
%% 5. Visualize the learned filters
% -------------------------------------------------------------------------
% net = load([trainOpts.expDir 'texture_net.mat']);
% figure(2) ; clf ; colormap gray ;
% vl_imarraysc(squeeze(net.layers{1}.filters),'spacing',2)
% axis equal ; title('filters in the first layer') ;

% -------------------------------------------------------------------------
%% 6. Evaluate net
% -------------------------------------------------------------------------
results.time = tic ;
% Evaluate Train
results.train_predic = train_net(net,imdb.images.data(:,:,train_index)) ;
results.train_class = imdb.images.label(train_index) ;
% Evaluate Validate
results.val_predic = train_net(net,imdb.images.data(:,:,val_index)) ;
results.val_class = imdb.images.label(val_index) ;
results.time = toc(results.time) ;

% Calculates confusion matriz
results.train_M = zeros(25) ; 
results.val_M = zeros(25) ; 

for i=1:25
 for j=1:25
  results.train_M(i,j) = sum(results.train_class==j & results.train_predic==i);
  results.val_M(i,j) = sum(results.val_class==j & results.val_predic==i);
 end
end

% Normalize matrix
results.train_M = results.train_M./repmat(sum(results.train_M),[25,1,1]) ;
results.train_ACA = mean(diag(results.train_M)) ;
results.val_M = results.val_M./repmat(sum(results.val_M),[25,1,1]) ;
results.val_ACA = mean(diag(results.val_M)) ;

save([trainOpts.expDir 'results'], 'results') ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = im2single(imdb.images.data(:,:,batch)) ;
im = 256 * reshape(im, 128, 128, 1, []) ;
labels = imdb.images.label(1,batch) ;

% --------------------------------------------------------------------
function [im, labels] = getBatchWithJitter(imdb, batch)
% --------------------------------------------------------------------
im = im2single(imdb.images.data(:,:,batch)) ;
labels = imdb.images.label(1,batch) ;
n = numel(batch) ;
[y, x, ~] = size(im);
I{1} = im ;

% Cortar cuadrado aleatorio
cy = randi(40) - 20;
cx = cy + randi(12) - 6;
if cx>0 && cy>0
    im = im(cy:end,cx:end,:);
elseif cy>0
    im = im(cy:end,1:end+cx,:);
elseif cx>0
    im = im(1:end+cy,cx:end,:);
else
    im = im(1:end+cy,1:end+cx,:);
end
I{2} = im ;

% Flip en eje y
fy = randi(2,[1,n]);
im(:,:,fy==2) = im(end:-1:1,:,fy==2);
I{3} = im ;

% Flip en eje x
fx = randi(2,[1,n]);
im(:,:,fx==2) = im(:,end:-1:1,fx==2);
I{4} = im ;

% Resize
im = imresize(im,[y,x]);
I{5} = im ;

% Flip en diagonal
fr = randi(2,[1,n]);
imr = im(:,:,fr==2);
im(:,:,fr==2) = permute(imr,[2,1,3]);
I{6} = im ;

% Numeros de 0 a 256
im = 256 * reshape(im, y, x, 1, []) ;

% Visualize the jitter images
% figure(100) ; clf ;
% subplot(231) ; vl_imarraysc(I{1}) ; title(['Original ' num2str(size(I{1}))]) ;
% subplot(232) ; vl_imarraysc(I{2}) ; title(['Corta ' num2str(size(I{2}))]) ;
% subplot(233) ; vl_imarraysc(I{3}) ; title(['Flip y ' num2str(size(I{3}))]) ;
% subplot(234) ; vl_imarraysc(I{4}) ; title(['Flip x ' num2str(size(I{4}))]) ;
% subplot(235) ; vl_imarraysc(I{5}) ; title(['Resize ' num2str(size(I{5}))]) ;
% subplot(236) ; vl_imarraysc(I{6}) ; title(['Flip d ' num2str(size(I{6}))]) ;
