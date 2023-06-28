function test_volume()
%SyncDisclosures fMRI script to present short recordings of people talking
%about their weekly schedules in order to calibrate SoundPixx volume
%Eleanor Collier
%6/28/2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect speaker speaker_name scanning LH_red_button

%DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];
wrapat         = 55;
flipHorizontal = [];
flipVertical   = [];
vSpacing       = 1.5;

%Block name
block_name = 'listening';

%Set up folder to pull recordings from
speaker_folder = sprintf('P%d/', speaker);
getRecordingsHere = fullfile(pwd, 'recordings/', speaker_folder);

%List of audio files
recording_name = 'practice.wav';

%Audio length in seconds
audioLength = 39;

%Key to skip video
skipKey = 's';

%Messages to display between recordings
% Message subject sees while waiting for scan trigger to start a new recording (excluding first recording - see instructs.m for that message)
triggerWait_message  = ['We''ll now have you listen to ', speaker_name, '''s practice recording to calibrate the volume. The experimenter will check in with you afterward.'];  

%Set screen advance commands based on whether scanning
if scanning
    wait_for_button_press = 'wait_for_DP_buttons(600, LH_red_button);'; %Wait for button 2
else
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
end

%Set sound output ID based on whether scanning
devices = PsychPortAudio('GetDevices');
if scanning
    sound_out_ID = 4; %Should never really need this in console room, but use 4 if needed for some reason
else
    sound_out_ID = 3; %Use computer's default speakers; 1 for workroom, 3 for lab laptop
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START TASK

%RUN VOLUME TEST

%Set path to recording wavfile
audiofile =  fullfile(getRecordingsHere, recording_name);

%Buffer recording via computer or Datapixx
if scanning
    bufferAudio_DP(audiofile);
else
    pahandle  = bufferAudio(audiofile, sound_out_ID);
end

%Draw scan trigger wait screen
DrawFormattedText(screenPointer, triggerWait_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
Screen('Flip', screenPointer);

%Wait for trigger
if scanning
    wait_for_DP_trigger(); %Wait for scan trigger
    % RestrictKeysForKbCheck(KbName('rightarrow')); KbStrokeWait; RestrictKeysForKbCheck([]); %Troubleshooting only
else
    eval(wait_for_button_press);
end

%Play recording through internal speakers or Datapixx
if scanning
    playAudio_DP(audioLength, screenPointer, skipKey);
else
    playAudio(pahandle, audioLength, screenPointer, skipKey);
end

end

