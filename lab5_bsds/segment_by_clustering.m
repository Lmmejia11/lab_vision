% Segmentation function 
% Input:
% feature_space = 'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'
% clustering_method = k-means, gmm, hierarchical or watershed
% Output:
% Imagewhere each pixel has a cluster label. 
% Pixels that belong to the same cluster should have the same integer label.

function my_segmentation = segment_by_clustering( rgb_image, ...
    feature_space, clustering_method, num_k)

% changes the type to double
if ~isequal(class(rgb_image),'double')
    rgb_image=im2double(rgb_image);
end
% gets the size of the image
if isequal(clustering_method,'hierarchical')
    [x,y,~] = size(rgb_image);
    l = max(x,y); s = ceil(l/140);
    if s>1, rgb_image = imresize(rgb_image,1/s); end;
end
[m,n,c]=size(rgb_image); %m=rows n=columns c=number of channels

%% Space selection
% Sets the image representation in the space the user wants and in a 
% normalize [0,1] vector form with c number of channels
switch feature_space
    case 'rgb'
        % Space transform
        image = rgb_image;
        % Vector transform
        Ivector = reshape(image(:), [], c);
    case 'lab'
        % Space transform
        colorTransform = makecform('srgb2lab');
        image = applycform(rgb_image, colorTransform);
        image = (image - min(image(:)))/(max(image(:))-min(image(:)));
%       image = rgb2lab(rgb_image);
        % Vector transform
        Ivector = reshape(image(:), [], c);
        % Scale normalization
        Ivector(:,1)=(max(Ivector(:,1))-Ivector(:,1))/(max(Ivector(:,1))-min(Ivector(:,1)));
        Ivector(:,2)=(max(Ivector(:,2))-Ivector(:,2))/(max(Ivector(:,2))-min(Ivector(:,2)));
        Ivector(:,3)=(max(Ivector(:,3))-Ivector(:,3))/(max(Ivector(:,3))-min(Ivector(:,3)));
    case 'hsv'
        % Space transform
        image = rgb2hsv(rgb_image);
        % Vector transform
        Ivector = reshape(image(:), [], c);
    case 'rgb+xy'
        % Space transform
        image = rgb_image;
        [image(:,:,4), image(:,:,5)] = meshgrid(1:n,1:m);
        c = 5;
        % Vector transform
        Ivector = reshape(image(:), [], c);
        % Scale normalization
        Ivector(:,4)=Ivector(:,4)/n;
        Ivector(:,5)=Ivector(:,5)/m;
    case 'lab+xy'
        % Space transform
        %image = rgb2lab(rgb_image);
        colorTransform = makecform('srgb2lab');
        image = applycform(rgb_image, colorTransform);
        image = (image - min(image(:)))/(max(image(:))-min(image(:)));
        [image(:,:,4), image(:,:,5)] = meshgrid(1:n,1:m);
        c = 5;
        % Vector transform
        Ivector = reshape(image(:), [], c);
        % Scale normalization
        Ivector(:,1)=(max(Ivector(:,1))-Ivector(:,1))/(max(Ivector(:,1))-min(Ivector(:,1)));
        Ivector(:,2)=(max(Ivector(:,2))-Ivector(:,2))/(max(Ivector(:,2))-min(Ivector(:,2)));
        Ivector(:,3)=(max(Ivector(:,3))-Ivector(:,3))/(max(Ivector(:,3))-min(Ivector(:,3)));
        Ivector(:,4)=Ivector(:,4)/n;
        Ivector(:,5)=Ivector(:,5)/m;
    case 'hsv+xy'
        % Space transform
        image = rgb2hsv(rgb_image);
        [image(:,:,4), image(:,:,5)] = meshgrid(1:n,1:m);
        c = 5;
        % Vector transform
        Ivector = reshape(image(:), [], c);
        % Scale normalization
        Ivector(:,4)=Ivector(:,4)/n;
        Ivector(:,5)=Ivector(:,5)/m;
end
%% Clustering method
options = statset('Display','final');
switch clustering_method
    case 'k-means'
        [idx,C] = kmeans(Ivector,num_k,'Options',options);
        my_segmentation = reshape(idx,[m n]);
    case 'gmm'
%       obj = gmdistribution.fit(Ivector,num_k,'MaxIter',20);
        obj = fitgmdist(Ivector,num_k,'Options',options);
        idx = cluster(obj,Ivector);
        my_segmentation = reshape(idx,[m n]);
    case 'hierarchical'
        idx = clusterdata(Ivector,'linkage','ward','savememory','on',...
            'maxclust',num_k);
        s = reshape(idx, [m n]);
        my_segmentation = imresize(s,[x y],'nearest');
    case 'watershed'
        imageG = rgb2gray(image(:,:,1:3));
        grad = imgradient(imageG);
        h = 1; l = 0; j = 0;
        while(j<=10) % Encontrar h para k regiones
            i = (h+l)/2;
            mini = imextendedmin(imageG,i);
            CC = bwconncomp(mini);
            c = CC.NumObjects;
            if c == num_k, break;
            elseif c>num_k, l = i;
            else h = i; 
            end
            j=j+1;
        end
        t = imimposemin(grad,mini);
        my_segmentation = watershed(t);
end
% Shows result
% figure(1)
% imagesc(my_segmentation);
% colormap colorcube
end