% Code for experiments described in 'A specialization for speech
% perception'.
%
% Rev. 1, by V. Montazeri, 3/22/2020
% Rev. 2: by V. Montazeri, 9/27/2021: Experiment 2 only with revised procedure.
%

clear
close all
clc

addpath('.\includes\');

addpath('F:\Research\MATLAB codes')
addpath('F:\Research\MATLAB')
addpath('F:\Research\MATLAB\Spectrogram\')

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
    
%     valid_answer = 0;
%     while(~valid_answer)
%         clc; disp('Enter mode (1) or (2):'); disp('(1) debug mode'); disp('(2) test mode');
%         s = input('Enter your answer: ', 's');
%         if(strcmpi(s, '1')), debug = 1; valid_answer = 1; elseif(strcmpi(s, '2')), debug = 0; valid_answer = 1; else, disp('invalid answer'); pause(1); end
%     end
    
    listener_code = input('Enter listener code or press enter to generate an automatic code:\n', 's');
    listener_code = {[listener_code '_' strrep(strrep(strrep(char(datetime), ':', '_'), '-', '_'), ' ', '_')]};
    
end

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

global trial
global tone_indx
global total
global return_value
global stimuli_to_play;
global practice_test

clc
input('Press enter to begin experiment 1');

factor1_levels = {'1-3'; '2-5'; '3-6'; '4-7'; '5-8'; '6-9'};
factor2_levels = {'AAB'; 'ABB'; 'BAA'; 'BBA'};

% determine wihch ear plays transient which plays stable parts
if(~recovery_mode)
    
    if(rand(1,1)<=.5)
        chirp_ear = 'left';
        speech_ear = 'right';
    else
        chirp_ear = 'right';
        speech_ear = 'left';
    end
    
    conditions = {'listener', 'stim_type', 'practice_test', 'factor_1', 'factor_2', 'speech_ear', 'chirp_ear', 'set', 'answer'};
    factor2_levels_1 = factor2_levels(randperm(length(factor2_levels)));
    st_indx = size(conditions,1);
    for ifactor2 = 1 : length( factor2_levels )
        
        factor2_level = factor2_levels_1(ifactor2);
        factor1_levels_1 = factor1_levels(randperm(length(factor1_levels)));
        
        temp1 = repelem( factor1_levels_1, trial_per_level ); temp1 = temp1(:);
        temp2 = repelem( factor2_level, trial_per_level*length(factor1_levels) ); temp2 = temp2(:);
        temp3 = repelem( {speech_ear}, length(temp2) ); temp3 = temp3(:);
        temp4 = repelem( {chirp_ear}, length(temp2) ); temp4 = temp4(:);
        temp5 = repelem( {ifactor2}, length(temp2) ); temp5 = temp5(:);
        temp6 = repelem( {''}, length(temp2) ); temp6 = temp6(:);
        temp0 = repelem( listener_code, length(temp2) ); temp0 = temp0(:);
        temp7 = repelem( {'speech'}, length(temp2) ); temp7 = temp7(:);
        temp8 = repelem( {'test'}, length(temp2) ); temp8 = temp8(:);
        
        current_condition = [temp0 temp7 temp8 temp1 temp2 temp3 temp4 temp5 temp6];
        
        conditions = [ conditions ; current_condition ];
        
    end
    end_indx = size(conditions, 1);
    practice = conditions(st_indx+1:st_indx+1+5,:);
    for ii=1:size(practice,1)
        practice(ii, 3) = {'practice'};
        practice(ii, 8) = {[0]};
    end
    conditions = [conditions(1:st_indx, :); practice; conditions(st_indx+1:end_indx, :)];
    
    factor2_levels_1 = factor2_levels(randperm(length(factor2_levels)));
    st_indx = size(conditions,1);
    for ifactor2 = 1 : length( factor2_levels )
        
        factor2_level = factor2_levels_1(ifactor2);
        factor1_levels_1 = factor1_levels(randperm(length(factor1_levels)));
        
        temp1 = repelem( factor1_levels_1, trial_per_level ); temp1 = temp1(:);
        temp2 = repelem( factor2_level, trial_per_level*length(factor1_levels) ); temp2 = temp2(:);
        temp3 = repelem( {speech_ear}, length(temp2) ); temp3 = temp3(:);
        temp4 = repelem( {chirp_ear}, length(temp2) ); temp4 = temp4(:);
        temp5 = repelem( {ifactor2}, length(temp2) ); temp5 = temp5(:);
        temp6 = repelem( {''}, length(temp2) ); temp6 = temp6(:);
        temp0 = repelem( listener_code, length(temp2) ); temp0 = temp0(:);
        temp7 = repelem( {'chirp'}, length(temp2) ); temp7 = temp7(:);
        temp8 = repelem( {'test'}, length(temp2) ); temp8 = temp8(:);
        
        current_condition = [temp0 temp7 temp8 temp1 temp2 temp3 temp4 temp5 temp6];
        
        conditions = [ conditions ; current_condition ];
        
    end
    end_indx = size(conditions, 1);
    practice = conditions(st_indx+1:st_indx+1+5,:);
    for ii=1:size(practice,1)
        practice(ii, 3) = {'practice'};
        practice(ii, 8) = {[0]};
    end
    conditions = [conditions(1:st_indx, :); practice; conditions(st_indx+1:end_indx, :)];
    
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
        case 'ABB'
            tone = [tone1; interstim_gap; tone2; interstim_gap; tone2];
            tone_indx = [length(tone1); length(interstim_gap); length(tone2); length(interstim_gap); length(tone2);];
        case 'BAA'
            tone = [tone2; interstim_gap; tone1; interstim_gap; tone1];
            tone_indx = [length(tone2); length(interstim_gap); length(tone1); length(interstim_gap); length(tone1);];
        case 'BBA'
            tone = [tone2; interstim_gap; tone2; interstim_gap; tone1];
            tone_indx = [length(tone2); length(interstim_gap); length(tone2); length(interstim_gap); length(tone1);];
    end
    
    stimuli_to_play = tone;
    
    ui_choices3;
    
    valid_answer = 0;
    while(~valid_answer)
        R = return_value;
        if(isempty(R))
            disp('invalid answer'); pause(1);
        else
            if( strcmpi(R, 'Sound (B)') || strcmpi(R, 'Sound (A)')), valid_answer = 1; else; disp('invalid answer'); pause(1); end
        end
    end
    
    conditions( trial+1, 9 ) = {R};
    save('.\includes\current_session.mat', 'conditions');
    save(['.\data\' char(listener_code) '.mat'], 'conditions');
    save('.\includes\start_trial.mat', 'start_trial');
    previous_set = current_set;
    previous_mode = cell2mat(conditions( trial+1,  3));  
    
end

disp('Experiment is completed.')

clear
rmpath('.\includes\');
delete('.\includes\current_session.mat')
delete('.\includes\exp_num.mat');
delete('.\includes\start_trial.mat');
