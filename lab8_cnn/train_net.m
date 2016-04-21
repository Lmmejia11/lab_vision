function best=train_net(net,test_data)

if ~isa(test_data,'single')
    test_data = im2single(test_data) ;
end

res = cell(1,size(test_data,3)) ;
scores = cell(1,size(test_data,3)) ;
bestScore = zeros(1,size(test_data,3)) ;
best = zeros(1,size(test_data,3)) ;
for i=1:size(test_data,3)
res{i} = vl_simplenn(net, test_data(:,:,i)) ;
scores{i} = squeeze(gather(res{i}(end).x)) ;
[bestScore(i), best(i)] = max(scores{i}) ;
end
