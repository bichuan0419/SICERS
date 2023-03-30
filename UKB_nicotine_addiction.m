%% SICERS network detection and testing
% Network object oriented statistics method is a new appraoch to detect and test hidden phenotype related connectivity patterns at the "network" level. Notet that the subgraph may vary a little bit due to the random intialization of the kmeans++ algorithm.
%% UKB_Nicotine_addiction data analysis
load('UKB_Nicotine_addiction.mat')
figure;imagesc(Wp);colorbar;colormap("jet")
title('Fig 1: Heatmap of -log transformed p-values');
snapnow;
% parameter tuning
[lambda_out, cut_out] = param_tuning(Wp);
% identify subnetwork
kmeans_iter = 20;
[CID_SICERS,W_SICERS, Clist_SICERS]=SICERS_final(Wp,cut_out,lambda_out, kmeans_iter);
% display figure
figure;imagesc(W_SICERS);colorbar;colormap("jet")
title('Fig 2: Heatmap of -log transformed p-values with detected subnetworks');
snapnow;