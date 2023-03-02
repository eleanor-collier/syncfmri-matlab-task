function [moviePtr] = bufferMovie(moviefile, screenPointer)

%This function plays a specified moviefile on a specified screen and returns the movie start and end time. 
%The name of a video skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the video. 

%Initialize audio driver
InitializePsychSound;

moviePtr  = Screen('OpenMovie', screenPointer, moviefile); 
Screen('PlayMovie', moviePtr, 1);

end

