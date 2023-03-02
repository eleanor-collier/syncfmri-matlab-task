function [startTime, endTime] = playMovie(moviePtr, screenPointer, skipKey)

%This function plays a specified moviefile on a specified screen and returns the movie start and end time. 
%The name of a video skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the video. 

startTime   = GetSecs;
    
%Disable all keys on keyboard except for video skip key
RestrictKeysForKbCheck(KbName(skipKey));

while ~KbCheck 
    %Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', screenPointer, moviePtr);

    %Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        %We're done, break out of loop:
        break;
    end

    %Draw the new texture immediately to screen:
    Screen('DrawTexture', screenPointer, tex);

    %Update display:
    Screen('Flip', screenPointer);

    %Release texture:
    Screen('Close', tex);
end
    
%Get movie end time
endTime = GetSecs;

%Stop playback & close movie  
Screen('PlayMovie', moviePtr, 0);
Screen('CloseMovie', moviePtr);

%Wait for keys to be released before continuing
KbWait([], 1);

%Re-enable all keys
RestrictKeysForKbCheck([]);

end

