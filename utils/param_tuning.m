function [lambda_out, cut_out] = param_tuning(Wp)
    % parameter tuning function
    % Input: 
    % Wp: Original shuffled (observed) adjacency matrix (-log(p-values))
    % lb: lower bound for lambda_0
    % ub: upper bound for lambda_0
    % By default, lb and ub are set to be lb = 0.5, ub = 0.7
    % and by default, the prior g(r) is assumed to be 5 distinct points

    %% User-defined parameters for parameter tuning
    lb = 0.4; ub = 0.7;
    lam_vec = linspace(0.5,0.7,10);
    % For convenience, we 5 distinct values to approximate a uniformly distributed
    % prior distirbution
    % locate 90, 92 94 96 98th percentile for cut-off
    nlogp = squareform(Wp);
    gr = prctile(nlogp, [80, 85, 90, 95, 98]);
    nodeLen = length(Wp);
    edgeLen = nchoosek(nodeLen,2);
    term_1_vec = zeros(length(lam_vec),length(gr));
    term_2_vec = zeros(length(lam_vec),length(gr));
    %% selection of lambda0 begins here
    for i = 1:length(lam_vec)
        
        lambda = lam_vec(i);
        % to speed up, we use k_means_iter = 1
        kmeans_iter = 2;

        for j = 1:length(gr)
            r = gr(j);
            
            % first determine the global edge density
            global_dens = sum(squareform(Wp)>r)/edgeLen;
            [CID_temp,W_temp, ~]=SICERS_final(Wp,r,lambda, kmeans_iter);
            % For now, we just take the first cluster to be the cluster of
            % interest
            cluster_temp = W_temp(1:CID_temp(1), 1:CID_temp(1));
            remaining_cluster = W_temp(1+CID_temp(1):end,1+CID_temp(1):end);
            pi_1 = sum(squareform(cluster_temp) > r)/(nchoosek(CID_temp(1),2));
            pi_0 = sum(squareform(remaining_cluster)>r)/(edgeLen - nchoosek(CID_temp(1),2));
            e_beta1 = squareform(cluster_temp > r);
            e_beta2 = squareform(remaining_cluster>r);
            term_1_vec(i,j) = sum(e_beta1*log(pi_1/global_dens+eps) +...
                (ones(size(e_beta1))- e_beta1)*log((1-pi_1)/(1-global_dens)+eps));
            term_2_vec(i,j) = sum(e_beta2*log(pi_0/global_dens+eps) +...
                (ones(size(e_beta2))- e_beta2)*log((1-pi_0)/(1-global_dens)+eps));
        end
        

    end
    %% choose lambda
    term_sum = term_1_vec + term_2_vec;
    lr_lambda = gr*term_sum';
    [~,lambda_idx] = max(lr_lambda);
    lambda_idx = lambda_idx(1);
    lambda_out = lam_vec(lambda_idx);
    %% choose cut
    lr_cut = lam_vec*term_sum;
    [~,cut_idx] = max(lr_cut);
    cut_idx = cut_idx(1);
    cut_out = gr(cut_idx);
end