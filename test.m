%%
% -------------- Base Plot: Sensors & FoV --------------
figure();
hold on;
set(gcf, 'Position', [1100, 630, 648, 263]); % Standardized window size
xlim([-331.1, 2509.8]); % X-axis limits
ylim([0, 848.2465]); % Y-axis limits
grid on;

% --- Plot FoV ---
plot_fov(settings.source_info, model.fov_range, model.rD_max);

% --- Plot Sensor Nodes (Malicious vs. Honest) ---
for j = 1:length(settings.source_info)
    node_pos = settings.source_info{j}.source_pos;
    
    if settings.source_info{j}.malicious_flag == 1
        % Red marker for malicious nodes
        plot(node_pos(1), node_pos(2), 'or', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        node_status = '(Byzantine)';
    else
        % Black marker for honest nodes
        plot(node_pos(1), node_pos(2), 'ok', 'MarkerSize', 10);
        node_status = '(Honest)';
    end

    % Label the nodes
    text_label = sprintf('Node %d\n%s', j, node_status);
    text(node_pos(1), node_pos(2) + 50, text_label, ...
         'FontName', model.font_name, 'FontSize', model.font_size + 2, ...
         'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

title('Debugging View: Sensors and FoV');
xlabel('x-coordinate (m)');
ylabel('y-coordinate (m)');
hold on;


%% 
pos_x = est_temp{i}.X{1}(1, :);  % Extract x-coordinates
pos_y = est_temp{i}.X{1}(3, :);  % Extract y-coordinates
% Scatter plot for estimated positions
scatter(pos_x, pos_y, 100, 'r^', 'filled', 'DisplayName', sprintf('Estimate %d', i));

% Add text labels for time step numbers (Optional)
for idx = 1:length(pos_x)
    text(pos_x(idx), pos_y(idx), num2str(idx), 'FontSize', 10, ...
        'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center');
end

title(sprintf('Estimates from est\\_temp{%d} at k=%d', i, k));
xlabel('x-coordinate (m)');
ylabel('y-coordinate (m)');
legend show;
grid on;
% hold off;

%% 
pos_x = sel_Agent.est.X{k}(1, :);  % Extract x-coordinates
pos_y = sel_Agent.est.X{k}(3, :);  % Extract y-coordinates
% Scatter plot for estimated positions
scatter(pos_x, pos_y, 100, 'g^', 'filled', 'DisplayName', sprintf('Estimate %d', i));

% Add text labels for time step numbers (Optional)
for idx = 1:length(pos_x)
    text(pos_x(idx), pos_y(idx), num2str(idx), 'FontSize', 10, ...
        'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center');
end

title(sprintf('Estimates from est\\_temp{%d} at k=%d', i, k));
xlabel('x-coordinate (m)');
ylabel('y-coordinate (m)');
legend show;
grid on;
% hold on;

%% 
pos_x = cur_Agent.est.X{k}(1, :);  % Extract x-coordinates
pos_y = cur_Agent.est.X{k}(3, :);  % Extract y-coordinates
% Scatter plot for estimated positions
scatter(pos_x, pos_y, 100, 'r^', 'filled', 'DisplayName', sprintf('Estimate %d', i));

% Add text labels for time step numbers (Optional)
for idx = 1:length(pos_x)
    text(pos_x(idx), pos_y(idx), num2str(idx), 'FontSize', 10, ...
        'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center');
end

title(sprintf('Estimates from est\\_temp{%d} at k=%d', i, k));
xlabel('x-coordinate (m)');
ylabel('y-coordinate (m)');
legend show;
grid on;
% hold on;

%% 
pos_x = est_fused.X{1}(1, :);  % Extract x-coordinates
pos_y = est_fused.X{1}(3, :);  % Extract y-coordinates
% Scatter plot for estimated positions
scatter(pos_x, pos_y, 100, 'r^', 'filled', 'DisplayName', sprintf('Estimate %d', i));

% Add text labels for time step numbers (Optional)
for idx = 1:length(pos_x)
    text(pos_x(idx), pos_y(idx), num2str(idx), 'FontSize', 10, ...
        'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center');
end

title(sprintf('Estimates from est\\_temp{%d} at k=%d', i, k));
xlabel('x-coordinate (m)');
ylabel('y-coordinate (m)');
legend show;
grid on;
% hold off;