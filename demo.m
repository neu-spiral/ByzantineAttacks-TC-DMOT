clearvars; 
close all; 
restoredefaultpath; matlabrc;
add_paths;
rng(2);                                                                                                         % default seed (0)

% Scenarios FUSION 2025 Helena Calatrava
% 'case_id' = "attack_00": 
% 'case_id' = "attack_01": 

% --- initialisation
case_id = "1";
case_id = "attack_02";
lambda_c = 1; % very small for fast experiment (but then we need to force detections in generation)
settings =  gen_settings('case_id',case_id,'sel_pd',0.98);                                                            % generate settings for a scenario
model = gen_model(settings,'meas_sigma',2,'sigma_v',5,'lambda_c',lambda_c,'track_threshold',0.001,'metric_type','ospa_union');   % generate model parameters
model.force_detections=1;
truth = gen_truth(model,settings);                                                                       % generate ground truths
plot_flags.show_time_labels = true; % Show time step numbers
plot_flags.show_fake_trajectory = true; % Show attack trajectory
[~,colorarray] = plot_truth(settings.source_info, model, truth, plot_flags);
figure;
plot_flags.show_time_labels = true; % Show time step numbers
[~,colorarray] = plot_truth(settings.source_info, model, truth, plot_flags);         % plot the current truths
meas = gen_all_meas(settings, model, truth);
% plot_measurements(settings, model, meas, truth);
                                                             % generate measurements

% --- main fusion program
fused_agents = run_fused_filter(settings,model,truth,meas);

% --- report results
sel_agent = 2;
report_single_result(sel_agent,fused_agents); 

% --- plot results
% [h_ospa,h_ospa2,h_card,h_proc, h_weights] =  plot_fused_results(model,truth,fused_agents,'sel_agent',sel_agent);
plot_est_vs_truth(model, settings, truth, fused_agents,'sel_agent',sel_agent,'colorarray',colorarray);
sel_agent = 1;
plot_est_vs_truth(model, settings, truth, fused_agents,'sel_agent',sel_agent,'colorarray',colorarray);
sel_agent = 3;
plot_est_vs_truth(model, settings, truth, fused_agents,'sel_agent',sel_agent,'colorarray',colorarray);
settings.plot_flags.show_time_labels = true; % Show time step numbers
plot_node_estimates(model, settings, truth, fused_agents, 'show_truth', false);
pause(2);
xlim(model.limit(1,:)); ylim(model.limit(2,:));
set(gcf,'Position',[-948,255,795,561]); set(gca,'FontSize',16);

