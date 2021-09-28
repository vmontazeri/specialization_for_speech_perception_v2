function [in_, window] = gen_ramp( in_, ramp_sec, fs )

if ~isempty(in_)

switch nargin 
    case 1
        ramp_sec = 5/1000;
        fs = 16e3;
    case 2
        fs = 16e3;
end

total_length = length(in_);

L_ramp = round(ramp_sec*fs);
L_steady = total_length - 2 * L_ramp;
window_up = linspace(0, 1, L_ramp);
window_down = linspace(1, 0, L_ramp);
window_steady = ones(1, L_steady);
window = [window_up window_steady window_down];
window = window(:);

in_ = in_(:) .* window;

else
    in_ = [];
    window = [];
end
