% Code for experiments described in 'A specialization for speech
% perception'.
%
% Rev. 1, by V. Montazeri, 3/22/2020
% Rev. 2, by V. Montazeri, 9/27/2021: Experiment 2 only with revised procedure.
% Rev. 3, by V. Montazeri, 10/2/2021: Fixed the ear for chirp and speech.
%               Modified the procedure, both experiments play the same stimuli  

clear
close all
clc

addpath('.\includes\');

% addpath('F:\Research\MATLAB codes')
% addpath('F:\Research\MATLAB')
% addpath('F:\Research\MATLAB\Spectrogram\')

if(exist('.\includes\current_session.mat', 'file'))
    recovery = input('Recovery mode? (Y/N)\n', 's');
    if(strcmpi(recovery, 'Y'))
        recovery_mode = 1;
    else
        recovery_mode = 0;
        delete('.\includes\current_session.mat')
        delete('.\includes\exp_num.mat');
        delete('.\includes\start_trial.mat');
    end
else
    recovery_mode = 0;
end

if(~recovery_mode)
    
    recovery_mode = 0;
    
    listener_code = input('Enter listener code or press enter to generate an automatic code:\n', 's');
    listener_code = {[listener_code '_' strrep(strrep(strrep(char(datetime), ':', '_'), '-', '_'), ' ', '_')]};
    
    valid_answer = 0;
    while(~valid_answer)
        clc; disp('Enter instruction mode (1) or (2):'); disp('(1) Speech only first'); disp('(2) Chirp only first');
        s = input('Enter your answer: ', 's');
        if(strcmpi(s, '1')) 
            instruction = {'speech_then_chirp'};
            valid_answer = 1; 
        elseif(strcmpi(s, '2')) 
            instruction = {'chirp_then_speech'};
            valid_answer = 1; 
        else 
            disp('invalid answer'); 
            pause(1); 
        end
    end
    
end

chirp_ear = 'right';
speech_ear = 'left';

F1_f_stable = 765;
F1_f_start    = 279;
F1_f_end     = F1_f_stable;

F2_f_stable = 1230;
F2_f_start    = 1764;
F2_f_end     = F2_f_stable;

F3_f_stable          = 2527;
F3_min_trans_f   = 1853;
F3_max_trans_f  = 3196;

trans_ramp_dur_ms = 5;
base_ramp_dur_ms = 5;
trans_dur_ms = 50;
stable_dur_ms = 200;

interstim_interval_ms = 500;

FS = 16e3;
left_ear = 1;
right_ear = 2;

silence = zeros(0.5*FS,2);
interstim_gap = zeros( FS * interstim_interval_ms/1000, 2  );
tone_len = (trans_dur_ms + stable_dur_ms)*FS/1000;
w = hanning(tone_len + 2*length(silence));

transition_indx = 1:trans_dur_ms*FS/1000;
stable_indx = trans_dur_ms*FS/1000+1: tone_len;

trial_per_level = 1;

% global trial
% global tone_indx
% global total
% global return_value
% global stimuli_to_play;
% global practice_test

clc
input('Press enter to begin experiment 1');

factor1_levels = {'1_3'; '2_5'; '3_6'; '4_7'; '5_8'; '6_9'};
factor2_levels = {'AAB'; 'ABB'; 'BAA'; 'BBA'};

% determine wihch ear plays transient which plays stable parts
if(~recovery_mode)
        
    conditions = {'listener', 'stim_type', 'practice_test', 'factor_1', 'factor_2', 'speech_ear', 'chirp_ear', 'set', 'instruction_mode', 'answer', 'correct'};
%     factor2_levels_1 = factor2_levels(randperm(length(factor2_levels)));
%     st_indx = size(conditions,1);
    for iset = 0 : 6
        
        set_conditions = [];
        
        if iset < 1, practice_test = {'practice'}; else, practice_test = {'test'}; end
        if(strcmpi(char(instruction), 'speech_then_chirp'))
            instruction_mode = {'speech only'};
        else
            instruction_mode = {'chirp only'};
        end     
        
        for ifact1 = 1 : length(factor1_levels)
            
            factor1_level = factor1_levels( ifact1 );
            
            for ifact2 = 1 : length(factor2_levels)
                
                factor2_level = factor2_levels( ifact2 );
                current_condition = [listener_code {'speech'} practice_test factor1_level factor2_level {speech_ear} {chirp_ear} ...
                    {iset} instruction_mode {''} {''}];
                set_conditions = [ set_conditions ; current_condition ];
            end
            
        end
        
        set_conditions = set_conditions( randperm(length(set_conditions)),: );
        
        conditions = [ conditions ; set_conditions ];
        
    end

    factor2_levels_1 = factor2_levels(randperm(length(factor2_levels)));
    st_indx = size(conditions,1);
        for iset = 0 : 6
        
        set_conditions = [];
        
        if iset < 1, practice_test = {'practice'}; else, practice_test = {'test'}; end
        if(strcmpi(char(instruction), 'speech_then_chirp'))
            instruction_mode = {'chirp only'};
        else
            instruction_mode = {'speech only'};
        end     
        
        for ifact1 = 1 : length(factor1_levels)
            
            factor1_level = factor1_levels( ifact1 );
            
            for ifact2 = 1 : length(factor2_levels)
                
                factor2_level = factor2_levels( ifact2 );
                current_condition = [listener_code {'speech'} practice_test factor1_level factor2_level {speech_ear} {chirp_ear} ...
                    {iset} instruction_mode {''} {''}];
                set_conditions = [ set_conditions ; current_condition ];
            end
            
        end
        
        set_conditions = set_conditions( randperm(length(set_conditions)),: );
        
        conditions = [ conditions ; set_conditions ];
        
    end

    exp_num = 1;
    start_trial = 1;
    save('.\includes\current_session.mat', 'conditions')
    save('.\includes\exp_num.mat', 'exp_num');
    save('.\includes\start_trial.mat', 'start_trial');
    
else
    load('.\includes\current_session.mat')
    load('.\includes\exp_num.mat');
    load('.\includes\start_trial.mat');
    listener_code = conditions(2,1);
end

total = length(conditions) - 1;
current_set =  cell2mat(conditions( start_trial+1,  8));
previous_set =  cell2mat(conditions( start_trial+1,  8));

for trial = start_trial : total
    
    start_trial = trial;    
    if(start_trial == total/2 + 1)
        new_exp(); 
    end
    practice_test = char(conditions(trial+1,3));
    clc;
    
    current_set = cell2mat(conditions( trial+1,  8));          
    if(current_set ~= previous_set)        
        new_set(previous_set); pause(6);
    end       
    
    factor1_level = char(conditions(trial+1, 4)); % formant transition difference. 1-4, 2-5, ...
    [formant_trans1, formant_trans2] = decode_factor1_level( factor1_level );
    factor2_level = char(conditions(trial+1, 5));  %   ABB, BAA, etc.
    
    F3_f_start_1 = find_F3_f_start(F3_min_trans_f, F3_max_trans_f, formant_trans1);
    F3_f_start_2 = find_F3_f_start(F3_min_trans_f, F3_max_trans_f, formant_trans2);
    F3_f_end  = F3_f_stable;
    
    [base_1, RMS] = gen_base(F1_f_start, F1_f_end, F1_f_stable, F2_f_start, F2_f_end, ...
        F2_f_stable, F3_f_stable, trans_dur_ms, stable_dur_ms, base_ramp_dur_ms, FS );
    if( strcmpi(char( conditions(trial+1, 2) ), 'chirp') )
        base_1 = base_1 * 0;
    end
    base_2 = base_1;    
    
    trans_1 = gen_trans( F3_f_start_1, F3_f_end, trans_dur_ms, trans_ramp_dur_ms, RMS, length(base_1), FS );
    trans_2 = gen_trans( F3_f_start_2, F3_f_end, trans_dur_ms, trans_ramp_dur_ms, RMS, length(base_1), FS );
    
    % R - L
    if( strcmpi(char( conditions(trial+1, 7) ), 'right') )
        tone1 = [trans_1 base_1];
        tone2 = [trans_2 base_2];        
    else
        tone1 = [base_1 trans_1];
        tone2 = [base_2 trans_2];
    end
    
    switch factor2_level
        case 'AAB'
            tone = [tone1; interstim_gap; tone1; interstim_gap; tone2];
            tone_indx = [length(tone1); length(interstim_gap); length(tone1); length(interstim_gap); length(tone2);];
            correct_answer = 'Sound (B)';
        case 'ABB'
            tone = [tone1; interstim_gap; tone2; interstim_gap; tone2];
            tone_indx = [length(tone1); length(interstim_gap); length(tone2); length(interstim_gap); length(tone2);];
            correct_answer = 'Sound (A)';
        case 'BAA'
            tone = [tone2; interstim_gap; tone1; interstim_gap; tone1];
            tone_indx = [length(tone2); length(interstim_gap); length(tone1); length(interstim_gap); length(tone1);];
            correct_answer = 'Sound (B)';
        case 'BBA'
            tone = [tone2; interstim_gap; tone2; interstim_gap; tone1];
            tone_indx = [length(tone2); length(interstim_gap); length(tone2); length(interstim_gap); length(tone1);];
            correct_answer = 'Sound (A)';
    end
    
    stimuli_to_play = tone;
    
    return_value = ui_choices3(FS, trial, total, tone_indx, practice_test, stimuli_to_play);
    
    valid_answer = 0;
    while(~valid_answer)
        R = return_value;
        if(isempty(R))
            disp('invalid answer'); pause(1);
        else
            if( strcmpi(R, 'Sound (B)') || strcmpi(R, 'Sound (A)')), valid_answer = 1; else; disp('invalid answer'); pause(1); end
        end
    end
    
    if( strcmpi(R, correct_answer) ), correct = 1; else, correct = 0; end
    
    conditions( trial+1, 10 ) = {R};
    conditions( trial+1, 11 ) = {correct};
    save('.\includes\current_session.mat', 'conditions');
    save(['.\data\' char(listener_code) '.mat'], 'conditions');
    save('.\includes\start_trial.mat', 'start_trial');
    previous_set = current_set;
    previous_mode = cell2mat(conditions( trial+1,  3));  
    
end

disp('Experiment is completed.')

T = cell2table( conditions(2:end,:), 'VariableNames', conditions(1,:) );
writetable( T, ['.\data\' char(listener_code) '.csv'] )

clear
rmpath('.\includes\');
delete('.\includes\current_session.mat')
delete('.\includes\exp_num.mat');
delete('.\includes\start_trial.mat');
