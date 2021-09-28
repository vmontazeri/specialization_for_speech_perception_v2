function [f1, f2] = decode_factor1_level( level )

indx = strfind( level, '-' );
f1 = str2double( level(1:indx-1) );
f2 = str2double( level(indx+1:end) );