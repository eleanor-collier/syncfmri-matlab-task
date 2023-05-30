function [startTime, endTime] = displayTimer(maxsecs, screenPointer, skipKey)

% DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];

%Disable all keys on keyboard except for skip key
RestrictKeysForKbCheck(KbName(skipKey));

%Record start time
startTime = GetSecs;

% Stay in a loop until keypress or end of maxsecs:
time = 0;
while ~KbCheck && (time < maxsecs)

    % Display visual countdown
    timeRemaining = round(maxsecs - time);
    timeRemainingFormatted = char(duration(seconds(timeRemaining),'format','mm:ss'));
    DrawFormattedText(screenPointer, timeRemainingFormatted, sx, sy, color);
    Screen('Flip', screenPointer);

    % Wait one second
    WaitSecs(1);
    
    % Update counter
    time = time + 1;

end

% Record end time
endTime = GetSecs;

RestrictKeysForKbCheck([]);

end

