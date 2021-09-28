function [base_tone, RMS] = gen_base( f1_start, f1_end, f1_stable, f2_start, f2_end, f2_stable, f3_stable, trans_dur, stable_dur, ramp_ms, FS )


F1 = gen_complex_tone(f1_start, f1_end, f1_stable, trans_dur, stable_dur, FS);
F2 = gen_complex_tone(f2_start, f2_end, f2_stable, trans_dur, stable_dur, FS);
F3 = gen_complex_tone(-1, -1, f3_stable, trans_dur, stable_dur, FS);

F3 = F3 * (rms(F1)/rms(F3));
F3 = F3 * 10^(-5/20); %5db atten. for F3

RMS = rms(F1);

base_tone = F1 + F2 + F3;
base_tone = base_tone(:);

if ramp_ms > 0
    [base_tone, window] = gen_ramp( base_tone, ramp_ms/1000, FS );
end