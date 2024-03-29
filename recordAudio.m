function [startTime, endTime] = recordAudio(wavfilename, maxsecs, pahandle, screenPointer, skipKey)

% DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];

%Disable all keys on keyboard except for skip key
RestrictKeysForKbCheck(KbName(skipKey));

% Start audio capture immediately and wait for the capture to start.
% We set the number of 'repetitions' to zero,
% i.e. record until recording is manually stopped.
PsychPortAudio('Start', pahandle, 0, 0, 1);
startTime = GetSecs;

% Start with empty sound vector:
recordedaudio = [];

% Retrieve status once to get access to SampleRate:
s = PsychPortAudio('GetStatus', pahandle);
freq = s.SampleRate;

waitsecs = 9;

% Record non-speech audio for length of waitsecs
while ~KbCheck && ((length(recordedaudio) / freq) < (waitsecs))
    
    % Display visual countdown for waiting to speak
    waitTimeRemaining = round(waitsecs - (length(recordedaudio) / freq));
    waitTimeRemainingFormatted = char(duration(seconds(waitTimeRemaining),'format','mm:ss'));
    DrawFormattedText(screenPointer, ['Recording starts in:\n\n', waitTimeRemainingFormatted], sx, sy, color);
    Screen('Flip', screenPointer);
    
    % Wait one second
    WaitSecs(1);
    
    % Retrieve pending audio data from the drivers internal ringbuffer:
    audiodata = PsychPortAudio('GetAudioData', pahandle);

    % And attach it to our full sound vector:
    recordedaudio = [recordedaudio audiodata];
    
end

% Stay in a loop until keypress or end of maxsecs:
while ~KbCheck && ((length(recordedaudio) / freq) < (maxsecs + waitsecs))
    
    % Display visual countdown for speaking
    timeRemaining = round(maxsecs - (length(recordedaudio) / freq - waitsecs));
    timeRemainingFormatted = char(duration(seconds(timeRemaining),'format','mm:ss'));
    DrawFormattedText(screenPointer, ['Time remaining:\n\n', timeRemainingFormatted], sx, sy, color);
    Screen('Flip', screenPointer);
    
    % Wait one second
    WaitSecs(1);

    % Retrieve pending audio data from the drivers internal ringbuffer:
    audiodata = PsychPortAudio('GetAudioData', pahandle);

    % And attach it to our full sound vector:
    recordedaudio = [recordedaudio audiodata];
        
end

% Stop capture:
PsychPortAudio('Stop', pahandle);
endTime   = GetSecs;

% Perform a last fetch operation to get all remaining data from the capture engine:
audiodata = PsychPortAudio('GetAudioData', pahandle);

% Attach it to our full sound vector:
recordedaudio = [recordedaudio audiodata];

% Close the audio device:
PsychPortAudio('Close', pahandle);

RestrictKeysForKbCheck([]);

% Store recorded sound to wavfile?
% NOTE: May want to update the frequency and bit-depth we use later...
if ~isempty(wavfilename)
    psychwavwrite(transpose(recordedaudio), freq, 16, wavfilename)
end

end

