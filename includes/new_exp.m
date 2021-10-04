function new_exp()

fig1 = figure(1);
set(1, 'resize', 'On', 'numbertitle', 'Off', 'windowstyle', 'normal', 'Units', 'Norm', 'Pos', [0 0 1 1]);

h = uicontrol('Style', 'text', 'String','Please wait for new instruction before proceeding ...', 'FontSize', 25, ...
    'Units','Norm', 'Position', [ 0 0.55 1 0.05 ]);

h = uicontrol('Style','pushbutton','String','Proceed', 'FontSize', 25, ...
    'Units', 'Norm', 'Position', [0 0.15 1 0.2 ], 'Callback',  @(btn,event) ButtonPushed());

uiwait(fig1)

 function ButtonPushed()
        uiresume(fig1)
        close all
 end

end