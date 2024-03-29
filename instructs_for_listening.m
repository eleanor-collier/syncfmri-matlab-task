function instructs_for_listening(instructNum)
%SyncDisclosures fMRI script to present instructions
%Eleanor Collier
%3/19/2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject speaker speaker_name subject_is_odd speaker_is_odd scanning LH_red_button

%DrawFormattedText Defaults
sx             = 'center';
sy             = 'center';
color          = [255 255 255];
wrapat         = 55;
flipHorizontal = [];
flipVertical   = [];
vSpacing       = 1.5;

%Set screen advance commands based on whether scanning
if scanning
    wait_for_button_press = 'WaitSecs(1); wait_for_DP_buttons(600, LH_red_button)'; %Wait for 1 second, then wait for button 2
    next_button = 'RED BUTTON'; %Key label in instructions
else
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
    next_button = 'RIGHT ARROW KEY'; %Key label in instructions
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET INSTRUCTIONS
%Choose instruction set based on whether experiment is in scanner or out of scanner. Each line corresponds to a new instruction page.
instructs = {
    {
    ['Please read the following instructions carefully. To advance through the instruction pages, press the ', next_button, '. ->']
    ['In this scan session, you will listen to the stories ', speaker_name, ' shared. ->']
    'When each story starts playing, there will be nine seconds of silence before you hear the speaker''s voice.'
    'Once again, please make sure not to move your head while you listen to the stories. ->'
    'If you have any questions, please let the researcher know! Once the scan starts, you will not be able to communicate with the researcher. \n\nIf you''re ready to begin, advance to the next screen. ->'
    }

    {
    ['You''ve reached the end of all of ', speaker_name, '''s stories. ->']
    ['For the next minute, we''d like you to simply rest. You''ll see a timer on the screen, but feel free to close your eyes. \n\nPress the ', next_button, ' to begin the rest session. ->']
    }
    
    {
    ['Now we''d like you to do a few simple math problems. Don''t worry, they''ll be super easy. ->']
    ['You''ll see a true or false statement on the screen, for example: 2 + 2 = 5. \n\nIf the statement is true, press the ', next_button, '. If the statement is false, do nothing. ->']
    ['When you''re ready, press the ', next_button, ' to begin. ->']
    }
    
    {
    ['Great job! Press the ', next_button, ' to exit the window and wait for the researcher to check in with you. ->']
    }
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START INSTRUCTIONS
%Draw each line of instructions in the desired instruction set on a new page and wait for button press to advance
currentInstructs = instructs{instructNum};
for line = 1:length(currentInstructs)
  DrawFormattedText(screenPointer, currentInstructs{line}, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
  Screen('Flip', screenPointer);
  eval(wait_for_button_press);
end

end

