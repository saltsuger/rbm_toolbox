%% Example 6 - hybrid training
% Tries to reproduce hybrid result from table 1 in 
% "Learning algorithms for the classification Restricted boltzmann machine"

[train_x,val_x,test_x,train_y,val_y,test_y] = setupmnist();

% Setup DBN
sizes = [1500 ];   % hidden layer size
[opts, valid_fields] = dbncreateopts();
opts.early_stopping = 1;
opts.patience = 15;
opts.numepochs = 10000;
opts.traintype = 'CD';
opts.init_type = 'cRBM';
opts.test_interval = 1;

opts.hybrid_alpha = 0.01;
opts.classRBM = 1;
opts.y_train = train_y;
opts.x_val = val_x;
opts.y_val = val_y;
opts.train_func = @rbmhybrid;

%% Set learningrate and momentum
opts.learningrate = @(t,momentum) 0.05;
opts.momentum = @(t) 0;

disp(opts)
dbncheckopts(opts,valid_fields);       %checks for validity of opts struct
dbn = dbnsetup(sizes, train_x, opts);  % train function 
dbn = dbntrain(dbn, train_x, opts);


class_vec = zeros(100,size(train_y,2));
for i = 1:size(train_y,2)
    class_vec((i-1)*10+1:i*10,i) = 1;
end
digits = dbnsample(dbn,100,10000,class_vec);


save('example.mat','dbn','opts','digits');
