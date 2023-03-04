function speak()
%EmpOrient fMRI script to present blank rest screen & rest period questions
%Eleanor Collier
%3/19/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject subject_is_odd scanning LH_red_button

%DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];
wrapat         = 55;
flipHorizontal = [];
flipVertical   = [];
vSpacing       = 1.5;

%Block name
block_name = 'speaking';

%List of names of stories for participant to share
stories = {'POSITIVE EXPERIENCE #1', 'POSITIVE EXPERIENCE #2', 'NEGATIVE EXPERIENCE #1', 'NEGATIVE EXPERIENCE #2'};

%Desired filenames for audio recordings
recordings = {'self_disclosure_pos1.wav', 'self_disclosure_pos2.wav', 'self_disclosure_neg1.wav', 'self_disclosure_neg2.wav'};

%Order participant's disclosure sharing order based on even/odd ID:
if subject_is_odd
    %If subject ID is odd, positive disclosures are recorded first
    stories_ordered = {stories{1:2}, stories{3:4}};
    recordings_ordered = {recordings{1:2}, recordings{3:4}};
else
    %If subject ID is even, negative disclosures are recorded first
    stories_ordered = {stories{3:4}, stories{1:2}};
    recordings_ordered = {recordings{3:4}, recordings{1:2}};
end

%Set up folder to save recordings to
subject_folder = sprintf('P%d/', subject);
saveRecordingsHere = fullfile(pwd, 'recordings/', subject_folder);
if ~exist(saveRecordingsHere,'dir') mkdir(saveRecordingsHere); end

%Recording length in seconds
recordingLength = 180;

%Key to skip recording
skipKey = 's';

%Messages to display between recordings:
%Message subject sees while waiting for scan trigger to start a new recording (excluding first recording - see instructs.m for that message)
triggerWait_message  = 'Story to share: storyName \n\nOnce the timer appears, you may begin talking.';
%Message subject sees at end of each story
recordingEnd_message = 'Thank you for sharing your story. If you''re ready to share your next one, advance to the next screen. ->'; 

%Set screen advance commands based on whether scanning
if scanning
    wait_for_button_press = 'wait_for_DP_buttons(600, LH_red_button);'; %Wait for button 2
else
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
end

%Set mic ID based on input device
% devices = PsychPortAudio('GetDevices');
if scanning
    %mic_name = 'Line In (BEHRINGER USB WDM AUDIO)';
    %mic_ID   = devices(strcmp({devices.DeviceName}, mic_name)).DeviceIndex;
    mic_ID = 2; %Use external scanner-compatible mic
else
    mic_ID = 1; %Use computer's default mic
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START TASK

%RUN SPEAKING BLOCK
for story = 1:length(stories_ordered)

    %Buffer recording
    % pahandle = bufferRecording(1);
    pahandle = bufferRecording(mic_ID);

    %Set path to recording wavfile
    recording_name = recordings_ordered{story};
    newWavFile = fullfile(saveRecordingsHere, recording_name);

    %Replace storyName placeholder in trigger wait message with story name
    storyName = stories_ordered{story};
    triggerWait_message_updated = strrep(triggerWait_message, 'storyName', storyName);
    
    %Draw scan trigger wait screen
    DrawFormattedText(screenPointer, triggerWait_message_updated, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
    Screen('Flip', screenPointer);

    %Wait for trigger
    if scanning
        wait_for_DP_trigger(); %Wait for scan trigger
    else
        eval(wait_for_button_press);
    end

    %Get trigger onset time
    tt = GetSecs;
    
    %Record audio
    [t0, tf] = recordAudio(newWavFile, recordingLength, pahandle, screenPointer, skipKey);
    
    %Update data with recording info
    data = [data; subject {block_name} {recording_name} tt t0 tf];

    % Display end of recording message after every recording except for the last one
    if story < length(stories_ordered)
        DrawFormattedText(screenPointer, recordingEnd_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
        Screen('Flip', screenPointer);
        eval(wait_for_button_press);
    end

end

