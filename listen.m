function listen()

%EmpOrient fMRI script to present high-empathy videos
%Eleanor Collier
%3/19/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject partner group inputDevice trigger LH_red_button

%DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];
wrapat         = 55;
flipHorizontal = [];
flipVertical   = [];
vSpacing       = 1.5;

%Block name
block_name = "listening";

%Set up folder to pull recordings from
partner_folder = "P" + partner + "/";
getRecordingsHere = fullfile(pwd, 'recordings/', partner_folder);

%List of audio files
recordings = {'self_disclosure_pos1.wav', 'self_disclosure_pos2.wav', 'self_disclosure_neg1.wav', 'self_disclosure_neg2.wav'};

%Audio length in seconds
audioLength = 180;

%Order recordings based on the order the study partner shared them in:

%If subject ID is odd, then partner ID is even, so play negative
%disclosures first
if group == 1
    recordings_ordered = {recordings{3:4}, recordings{1:2}};

%If subject ID is even, then partner ID is odd, so play positive
%disclosures first
elseif group == 2
    recordings_ordered = {recordings{1:2}, recordings{3:4}};
end

%Key to skip video
skipKey = 's';

%Messages to display between recordings
% Message subject sees while waiting for scan trigger to start a new recording (excluding first recording - see instructs.m for that message)
triggerWait_message  = 'The next story will start playing soon.';  
%Message subject sees at end of each recording
recordingEnd_message = 'Your study partner''s story has finished. If you''re ready to listen to the next one, advance to the next screen. ->'; 

%Set screen advance commands based on input device
if strcmp(inputDevice, 'keyboard')
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
elseif strcmp(inputDevice, 'buttonbox')
    wait_for_button_press = 'SimpleWFE(600, LH_red_button);'; %Wait for button 2
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START TASK

%RUN LISTENING BLOCK
for audio = 1:length(recordings_ordered)

    %Set path to recording wavfile
    recording_name = recordings_ordered{audio};
    audiofile =  fullfile(getRecordingsHere, recording_name);

    %Buffer recording
    pahandle  = bufferAudio(audiofile);

    %Draw scan trigger wait screen
    DrawFormattedText(screenPointer, triggerWait_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
    Screen('Flip', screenPointer);

    %Wait for trigger
    if strcmp(inputDevice, 'keyboard')
        eval(wait_for_button_press);
    elseif strcmp(inputDevice, 'buttonbox')
        SimpleWFE(600, trigger); %Wait for scan trigger
    end

    %Get trigger onset time
    tt = GetSecs;

    %Play recording
    [t0, tf]  = playAudio(pahandle, audioLength, screenPointer, skipKey);

    %Update data with recording info
    data = [
        data 
        subject group block_name recording_name tt t0 tf
        ];

    % Display between-recording instructions after every recording except for the last one
    if audio < length(recordings_ordered)
        %Display end of recording message
        DrawFormattedText(screenPointer, recordingEnd_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
        Screen('Flip', screenPointer);
        eval(wait_for_button_press);
    end

end

end

