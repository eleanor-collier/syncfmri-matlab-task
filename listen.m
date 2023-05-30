function listen()
%SyncDisclosures fMRI script to present recorded disclosures in the order
%the speaker originally shared them in based on speaker ID
%Eleanor Collier
%3/19/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject session_ID speaker speaker_name subject_is_odd speaker_is_odd scanning LH_red_button

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
recordings = {'self_disclosure_pos1.wav', 'self_disclosure_pos2.wav', 'self_disclosure_neg1.wav', 'self_disclosure_neg2.wav'};

%Audio length in seconds
audioLength = 180;

%Order recordings based on the order the speaker shared them in:
if speaker_is_odd
    recordings_ordered = {recordings{1:2}, recordings{3:4}};
else
    recordings_ordered = {recordings{3:4}, recordings{1:2}};
end

%Key to skip video
skipKey = 's';

%Messages to display between recordings
% Message subject sees while waiting for scan trigger to start a new recording (excluding first recording - see instructs.m for that message)
triggerWait_message  = 'The next story will start playing soon.';  
%Message subject sees at end of each recording
recordingEnd_message = [speaker_name, '''s story has finished. Please wait for the experimenter to check in with you before advancing to the next screen. ->']; 

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

%RUN LISTENING BLOCK
for audio = 1:length(recordings_ordered)

    %Set path to recording wavfile
    recording_name = recordings_ordered{audio};
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
   
    %Get trigger onset time
    tt = GetSecs;

    %Play recording through internal speakers or Datapixx
    if scanning
        [t0, tf]  = playAudio_DP(audioLength, screenPointer, skipKey);
    else
        [t0, tf]  = playAudio(pahandle, audioLength, screenPointer, skipKey);
    end

    %Update data with recording info
    data = [data; subject session_ID speaker {speaker_name} {block_name} {recording_name} tt t0 tf];

    % Display between-recording instructions after every recording except for the last one
    if audio < length(recordings_ordered)
        %Display end of recording message
        DrawFormattedText(screenPointer, recordingEnd_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
        Screen('Flip', screenPointer);
        eval(wait_for_button_press);
        % RestrictKeysForKbCheck(KbName('rightarrow')); KbStrokeWait; RestrictKeysForKbCheck([]); %Troubleshooting only
    end

end

end

