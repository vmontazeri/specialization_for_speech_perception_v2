function F3_trans = gen_trans( f3_start, f3_end, trans_dur, ramp_ms, RMS, L, FS )


F3_trans = gen_complex_tone(f3_start, f3_end, -1, trans_dur, -1, FS);

F3_trans = F3_trans * (RMS/rms(F3_trans));
F3_trans = F3_trans * 10^(-5/20); %5db atten. for F3

if ramp_ms > 0
    [F3_trans, window] = gen_ramp( F3_trans, ramp_ms/1000, FS );
end

F3_trans = [F3_trans; zeros(L-length(F3_trans),1)];