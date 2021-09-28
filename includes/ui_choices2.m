function ui_choices2

global return_value;
global correct_answer_details;
global stimuli_to_play;
global FS
global trial
global total

close all
fig1 = figure(1);
POS=[10 50 1660 910];
set(1,'resize','On','numbertitle','Off',...
    'windowstyle','normal',...
    'Units','Norm', ...
    'Pos',[0 0 1 1]);

h = uicontrol('Style','text','String',['Trial ' num2str(trial) ' of ' num2str(total)] , 'FontSize', 12, ...
    'Units','Norm', ...
    'Position', [.0 .90 1 .05 ]);

pause(0.1)
soundsc(stimuli_to_play, FS)
pause(length(stimuli_to_play)/FS)

h = uicontrol('Style','text','String','What did you hear?', 'FontSize', 25, ...
    'Units','Norm', ...
    'Position', [.0 .65 1 .2 ]);

bg = uibuttongroup('Visible','on',...
    'Units','Norm', ...,
    'Position',[.0 0 1 0.75],...
    'SelectionChangedFcn',@bselection, ...
    'BorderType', 'none');

Y = 0.70;

% Create three radio buttons in the button group.
r1 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','/da/',...
    'Units','Norm', ...
    'Position',[0.05 Y 0.1 0.1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r2 = uicontrol(bg,'Style','radiobutton',...
    'String','/ga/',...
    'Units','Norm', ...
    'Position',[.15 Y .10 .10],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r3 = uicontrol(bg,'Style','radiobutton',...
    'String','Rising chirp',...
    'Units','Norm', ...
    'Position',[.25 Y .15 .1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r4 = uicontrol(bg,'Style','radiobutton',...
    'String','Falling chirp',...
    'Units','Norm', ...
    'Position',[.40 Y .15 .1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r5 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','/da/ + Rising chirp',...
    'Units','Norm', ...
    'Position',[0.55 Y 0.15 0.1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r6 = uicontrol(bg,'Style','radiobutton',...
    'String','/da/ + Falling chirp',...
    'Units','Norm', ...
    'Position',[.70 Y .15 .10],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r7 = uicontrol(bg,'Style','radiobutton',...
    'String','/ga/ + Falling chirp',...
    'Units','Norm', ...
    'Position',[.85 Y .15 .1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

r8 = uicontrol(bg,'Style','radiobutton',...
    'String','/ga/ + Falling chirp',...
    'Units','Norm', ...
    'Position',[.45 Y-.1 .15 .1],...
    'HandleVisibility','off', ...
    'FontSize', 15);

set(r1, 'Value', 0);  

% Make the uibuttongroup visible after creating child objects.
bg.Visible = 'on';

    function bselection(source,event)
%         disp(['Previous: ' event.OldValue.String]);
%         disp(['Current: ' event.NewValue.String]);
%         disp('------------------');
        temp = event.NewValue.String;
        
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

uiwait(fig1)

end