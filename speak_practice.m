function speak_practice()
%SyncDisclosures fMRI script to record practice disclosure
%Eleanor Collier
%3/22/2023

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

%Desired filename for audio recording
recording_name = 'practice.wav';

%Set up folder to save recordings to
subject_folder = sprintf('P%d/', subject);
saveAudioHere = fullfile(pwd, 'recordings/', subject_folder);
if ~exist(saveAudioHere,'dir') mkdir(saveAudioHere); end

%Recording length in seconds
recordingLength = 30;

%Key to skip recording
skipKey = 's';

%Messages to display between recordings:
%Message subject sees while waiting for scan trigger to start a new recording (excluding first recording - see instructs.m for that message)
triggerWait_message  = 'Once the 2nd timer appears, you may begin talking.';
%Message subject sees at end of each story
recordingEnd_message = 'The practice session has ended. Please wait for the researcher to check in with you. \n\nOnce the researcher says it''s okay, go ahead and advance to the next page. ->'; 

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
%% START PRACTICE
%Draw scan trigger wait screen
DrawFormattedText(screenPointer, triggerWait_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
Screen('Flip', screenPointer);

%Buffer recording & set up path to save recording to
% pahandle = bufferRecording(1);
pahandle = bufferRecording(mic_ID);
newWavFile = fullfile(saveAudioHere, recording_name);

%Wait for trigger
if scanning
    wait_for_DP_trigger(); %Wait for scan trigger
else
    eval(wait_for_button_press);
end

%Record audio
[t0, tf] = recordAudio(newWavFile, recordingLength, pahandle, screenPointer, skipKey);

%Display end of recording message
DrawFormattedText(screenPointer, recordingEnd_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
Screen('Flip', screenPointer);
eval(wait_for_button_press);
end
