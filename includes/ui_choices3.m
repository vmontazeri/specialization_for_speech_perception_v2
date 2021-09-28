function ui_choices3

global return_value;
global correct_answer_details;
global stimuli_to_play;
global FS
global trial
global total
global tone_indx
global practice_test

close all
fig1 = figure(1);
POS=[10 50 1660 910];
set(1, 'resize', 'On', 'numbertitle', 'Off', 'windowstyle', 'normal', 'Units', 'Norm',  'Pos', [0 0 1 1]);

if strcmpi(practice_test, 'practice')
    h = uicontrol('Style','text','String',['Practice trial ' num2str(trial)] , 'FontSize', 15, 'Units','Norm', 'Position', [0 0.90 1 0.05 ]);
else
    h = uicontrol('Style','text','String',['Trial ' num2str(trial) ' of ' num2str(total)] , 'FontSize', 15, 'Units','Norm', 'Position', [0 0.90 1 0.05 ]);
end

pause(0.5)
soundsc(stimuli_to_play, FS)

% disp('tone1')
h = uicontrol('Style','text','String','Sound (A)' , 'FontSize', 25, 'Units','Norm', 'Position', [0 0.75 0.35 0.05 ]);
pause( tone_indx(1)/FS )
% disp('')
pause( tone_indx(2)/FS )
% disp('tone2')
h = uicontrol('Style','text','String','Sound (X)' , 'FontSize', 25, 'Units','Norm', 'Position', [0.45 0.75 0.1 0.05 ]);
pause( tone_indx(3)/FS )
% disp('')
pause( tone_indx(4)/FS )
% disp('tone3')
h = uicontrol('Style','text','String','Sound (B)' , 'FontSize', 25, 'Units','Norm', 'Position', [0.75 0.75 0.1 0.05 ]);
pause( tone_indx(5)/FS )
pause(0.1)

if strcmpi(practice_test, 'test')
    h = uicontrol('Style','text','String','Sound (X) sounded less like ', 'FontSize', 25, ...
        'Units','Norm', ...
        'Position', [ 0 0.55 1 0.05 ]);
    
    bg = uibuttongroup('Visible','on',...
        'Units','Norm', ...,
        'Position',[0 0 1 0.5],...
        'SelectionChangedFcn',@bselection, ...
        'BorderType', 'none');
    
    Y = 0.85;
    
    % Create three radio buttons in the button group.
    r1 = uicontrol(bg,'Style',...
        'radiobutton',...
        'String','Sound (A)',...
        'Units','Norm', ...
        'Position',[0.30 Y 0.1 0.1],...
        'HandleVisibility','off', ...
        'FontSize', 20);
    
    r2 = uicontrol(bg,'Style','radiobutton',...
        'String','Sound (B)',...
        'Units','Norm', ...
        'Position',[0.65 Y .10 .10],...
        'HandleVisibility','off', ...
        'FontSize', 20);
    
    set(r1, 'Value', 0);
    %
    % % Make the uibuttongroup visible after creating child objects.
    bg.Visible = 'on';
else
    pause(1)
    uiresume(fig1)
    close all
end

    function bselection(source,event)
        %         disp(['Previous: ' event.OldValue.String]);
        %         disp(['Current: ' event.NewValue.String]);
        %         disp('------------------');
        temp = event.NewValue.String
        
        h = uicontrol('Style','pushbutton','String','Submit and proceed', 'FontSize', 25, ...
            'Units', 'Norm', ...
            'Position', [0 0.15 1 0.2 ],...
            'Callback',  @(btn,event) ButtonPushed(temp));
        
        %         h_button = uicontrol('Style','text','String', ['Correct answer is ' correct_answer_details], ...
        %             'FontSize', 25, ...
        %             'Units','Norm', ...
        %             'Position', [.0 .005 1 .1 ] );
        
        uiwait(fig1)
        
    end

    function ButtonPushed(temp)
        return_value = temp;
        uiresume(fig1)
        close all
    end

if strcmpi(practice_test, 'test')
uiwait(fig1)
end

end