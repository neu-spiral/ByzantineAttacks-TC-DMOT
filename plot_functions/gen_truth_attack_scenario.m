function truth = gen_truth_attack_scenario(model, settings)
    % Generate modified ground truth for attack scenarios

    case_id = settings.p.Results.case_id;

    % --- Initialise truth variables for Real Targets ---
    truth.K = model.K;                  
    truth.X = cell(truth.K,1);          
    truth.N = zeros(truth.K,1);         
    truth.L = cell(truth.K,1);          
    truth.track_list = cell(truth.K,1);  
    truth.total_tracks = 0;              

    % --- Initialise truth variables for Attack Targets ---
    truth.attack.K = model.K;                 
    truth.attack.X = cell(truth.K,1);         
    truth.attack.N = zeros(truth.K,1);        
    truth.attack.L = cell(truth.K,1);         
    truth.attack.track_list = cell(truth.K,1);
    truth.attack.total_tracks = 0;

    % --- Use target data from gen_settings.m ---
    xstart = settings.xstart;     % Real target initial states
    tbirth = settings.tbirth;     % Real target birth times
    tdeath = settings.tdeath;     % Real target death times
    nbirths = size(xstart,2);     % Number of real targets

    % --- Generate Trajectories for Real Targets First ---
    for targetnum = 1:nbirths
        targetstate = xstart(:, targetnum);

        for k = tbirth(targetnum):min(tdeath(targetnum), truth.K)
            
            % --- Modify Trajectories Based on Target ---
            if targetnum == 1  % First Target (Blue)
                if k < 46
                    targetstate(1) = targetstate(1) +30;  % Move right faster
                elseif k <78
                    targetstate(1) = targetstate(1) + 22 * cos(0.05 * (k-46)); % Erratic motion
                    targetstate(3) = targetstate(3) - 15 * sin(0.05 * (k-46));
                else
                    targetstate(3) = targetstate(3) - 30;  % Move downward faster
                end

            elseif targetnum == 2  % Second Target (Orange)
                % IF wanting to start attack after tgt1 enters FoV
                % from node 3 (tgt birth at 30)
                % if k < 45
                %     targetstate(1) = targetstate(1) - 45;  % Move right in a straight line
                % elseif k < 67
                %     targetstate(1) = targetstate(1) - 30 * cos(0.075 * (k - 45));  % Smoother, wider curve
                %     targetstate(3) = targetstate(3) + 15 * sin(0.075 * (k - 45));  % More gradual rise
                % 
                % else
                %     targetstate(3) = targetstate(3) + 25;  % Move straight up
                % end
                if k < 43
                    targetstate(1) = targetstate(1) - 45;  % Move right in a straight line
                elseif k < 65
                    targetstate(1) = targetstate(1) - 30 * cos(0.075 * (k - 43));  
                    targetstate(3) = targetstate(3) + 15 * sin(0.075 * (k - 43));  
                else
                    targetstate(3) = targetstate(3) + 15;  
                end
            end

            % Store real target data
            truth.X{k} = [truth.X{k}, targetstate];
            truth.track_list{k} = [truth.track_list{k}, targetnum];
            truth.N(k) = truth.N(k) + 1;
        end
    end

    % --- Now Generate the Attack Target Separately ---
    xstart_attack = settings.xstart_attack;  
    tbirth_attack = settings.tbirth_attack;  
    tdeath_attack = settings.tdeath_attack;  

    for attacknum = 1:size(xstart_attack,2)  
        targetstate = xstart_attack(:, attacknum);

        for k = tbirth_attack(attacknum):min(tdeath_attack(attacknum), truth.K)
            
            % --- Modify Fake Target Trajectory ---
            if attacknum == 1 && strcmp(case_id, "attack_02") % until march 9th
                if k < 37
                    targetstate(1) = targetstate(1) +30;  
                elseif k <49
                    targetstate(1) = targetstate(1) + 22 * cos(0.1 * (k-37)); 
                    targetstate(3) = targetstate(3) + 10 * sin(0.1 * (k-37));
                elseif k < 55
                    last_x = 22 * cos(0.1 * (49 - 37));  
                    last_y = 10 * sin(0.1 * (49 - 37));  

                    targetstate(1) = targetstate(1) + last_x + 30 * sin(0.25 * (k - 49)); 
                    targetstate(3) = targetstate(3) + last_y + 1 * cos(0.25 * (k - 49));
                % elseif k<56
                %     targetstate(1) = targetstate(1) +30;  
                elseif k < 67
                    targetstate(1) = targetstate(1) + 20 * cos(0.1 * (k-55)); 
                    targetstate(3) = targetstate(3) + 10 * sin(0.1 * (k-55));
                else
                    if k <= length(truth.X) && ~isempty(truth.X{k})  
                        idx_target2 = find(truth.track_list{k} == 2, 1); % Find Target 2 at step k

                        if ~isempty(idx_target2)
                            targetstate = truth.X{k}(:, idx_target2); % Copy state from Target 2
                        end
                    end
                % IF we do not want to steal trajectory directly from tgt2
                % elseif k<65
                %     targetstate(1) = targetstate(1) + 22 * cos(0.02 * (k-58)); 
                %     targetstate(3) = targetstate(3) + 30 * sin(0.2 * (k-58));
                % else
                %     targetstate(3) = targetstate(3) +20;  
                end
            % if attacknum == 1 && strcmp(case_id, "attack_02") % until march 9th
            %     if k < 37
            %         targetstate(1) = targetstate(1) +30;  
            %     elseif k <49
            %         targetstate(1) = targetstate(1) + 22 * cos(0.1 * (k-37)); 
            %         targetstate(3) = targetstate(3) + 10 * sin(0.1 * (k-37));
            %     elseif k < 55
            %         last_x = 22 * cos(0.1 * (49 - 37));  
            %         last_y = 10 * sin(0.1 * (49 - 37));  
            % 
            %         targetstate(1) = targetstate(1) + last_x + 30 * sin(0.25 * (k - 49)); 
            %         targetstate(3) = targetstate(3) + last_y + 1 * cos(0.25 * (k - 49));
            %     elseif k<62
            %         targetstate(1) = targetstate(1) +30;  
            %     else
            %         if k <= length(truth.X) && ~isempty(truth.X{k})  
            %             idx_target2 = find(truth.track_list{k} == 2, 1); % Find Target 2 at step k
            % 
            %             if ~isempty(idx_target2)
            %                 targetstate = truth.X{k}(:, idx_target2); % Copy state from Target 2
            %             end
            %         end
            %     % IF we do not want to steal trajectory directly from tgt2
            %     % elseif k<65
            %     %     targetstate(1) = targetstate(1) + 22 * cos(0.02 * (k-58)); 
            %     %     targetstate(3) = targetstate(3) + 30 * sin(0.2 * (k-58));
            %     % else
            %     %     targetstate(3) = targetstate(3) +20;  
            %     end
            % if attacknum == 1 && strcmp(case_id, "attack_02") 
            %     if k < 43
            %         targetstate(1) = targetstate(1) +30;  
            %     elseif k <59
            %         targetstate(1) = targetstate(1) + 38 * cos(0.1 * (k-43)); 
            %         targetstate(3) = targetstate(3) + 8 * sin(0.1 * (k-43)); 
            %         last_x = targetstate(1);
            %     elseif k <62
            %         targetstate(1) = last_x; 
            %         targetstate(3) = targetstate(3) + 5;
            %     else
            %         targetstate = truth.X{k}(:,2);
            %     end
            elseif attacknum == 1 && strcmp(case_id, "attack_01") 

                if k < 38
                    targetstate(1) = targetstate(1) +30;  
                else
                    if k <= length(truth.X) && ~isempty(truth.X{k})  
                        idx_target2 = find(truth.track_list{k} == 2, 1); % Find Target 2 at step k
                        
                        if ~isempty(idx_target2)
                            targetstate = truth.X{k}(:, idx_target2); % Copy state from Target 2
                        end
                    end
                end
            end
            % Store attack target data separately
            truth.attack.X{k} = [truth.attack.X{k}, targetstate];
            truth.attack.track_list{k} = [truth.attack.track_list{k}, attacknum + nbirths];  
            truth.attack.N(k) = truth.attack.N(k) + 1;
        end
    end

    % Finalize the track count
    truth.total_tracks = nbirths;
    truth.L = truth.track_list;
    truth.attack.total_tracks = size(xstart_attack,2);
    truth.attack.L = truth.attack.track_list;

end
