%% SICERS network detection and testing
% Network object oriented statistics method is a new appraoch to detect and test hidden phenotype related connectivity patterns at the "network" level. Notet that the subgraph may vary a little bit due to the random intialization of the kmeans++ algorithm.
%% D1 data analysis
load('data_d1.mat')
figure;imagesc(WnTr);colorbar;colormap("jet")
title('Fig 1: Heatmap of -log transformed p-values of 90*90 matrix');
snapnow;
% parameter tuning
[lambda_out, cut_out] = param_tuning(WnTr);
% identify subnetwork
kmeans_iter = 10;
[CID_SICERS,W_SICERS, Clist_SICERS]=SICERS_final(WnTr,cut_out,lambda_out, kmeans_iter);
% display figure
figure;imagesc(W_SICERS);colorbar;colormap("jet")
title('Fig 2: Heatmap of -log transformed p-values of 90*90 matrix with detected subnetworks');
snapnow;