function [startTime, endTime] = playAudio(pahandle, audioLength, screenPointer, skipKey)

%This function plays a specified audiofilefile with a blank screen and returns the audio start and end time. 
%The name of a recording skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the audio. 

%Draw blank screen
Screen('Flip', screenPointer);

%Disable all keys on keyboard except for skip key
RestrictKeysForKbCheck(KbName(skipKey));

% Start audio playback for 0 repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
stopTime = GetSecs + audioLength;
PsychPortAudio('Start', pahandle, 1, 0, 1, stopTime);
startTime = GetSecs;

%Stop playback if skip key is pressed
while round(GetSecs) ~= round(stopTime)
    if KbCheck
        PsychPortAudio('Stop', pahandle);
        break;
    end
end

%Stop playback & close audio device when recording is over
PsychPortAudio('Stop', pahandle, 1);
PsychPortAudio('Close', pahandle);

%Get recording end time
endTime = GetSecs;

%Wait for keys to be released before continuing
KbWait([], 1);

%Re-enable all keys
RestrictKeysForKbCheck([]);

end

