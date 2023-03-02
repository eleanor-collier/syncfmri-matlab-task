function [startTime, endTime] = playAudio_DP(audioLength, screenPointer, skipKey)

%This function plays a specified audiofilefile with a blank screen and returns the audio start and end time. 
%The name of a recording skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the audio. 

%Draw blank screen
Screen('Flip', screenPointer);

%Disable all keys on keyboard except for skip key
RestrictKeysForKbCheck(KbName(skipKey));

%Start audio playback
stopTime = GetSecs + audioLength;
Datapixx('SetMarker');
Datapixx('StartAudioSchedule');
Datapixx('RegWrVideoSync'); 
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache
startTime = GetSecs;

%Stop playback if skip key is pressed or when schedule stops
while 1
    Datapixx('RegWrRd');   % Update registers for GetAudioStatus
    status = Datapixx('GetAudioStatus');
    if ~status.scheduleRunning
        break;
    end
    
    if KbCheck
        Datapixx('StopAudioSchedule');
        break;
    end
end

% Synchronize Datapixx registers to local register cache
Datapixx('RegWrRd');    

%Get recording end time
endTime = GetSecs;

%Wait for keys to be released before continuing
KbWait([], 1);

%Re-enable all keys
RestrictKeysForKbCheck([]);

end

