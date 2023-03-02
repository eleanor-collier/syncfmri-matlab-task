function instructions(instructNum)
%EmpOrient fMRI script to present instructions
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

%Set screen advance commands based on input device
if strcmp(inputDevice, 'keyboard')
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
    next_button = 'RIGHT ARROW KEY'; %Key label in instructions
elseif strcmp(inputDevice, 'buttonbox')
    wait_for_button_press = 'WaitSecs(1); wait_for_DP_buttons(600, LH_red_button)'; %Wait for 1 second, then wait for button 2
    next_button = 'BUTTON 2'; %Key label in instructions
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET INSTRUCTIONS
%Choose instruction set based on whether experiment is in scanner or out of scanner. Each line corresponds to a new instruction page.
instructs = {
    {
    ['Please read the following instructions carefully. To advance through the instruction pages, press the ', next_button, '. ->']
    'In this second scan session, you will listen to the stories your study partner shared. ->'
    'Once again, please make sure not to move your head while you listen to the stories. ->'
    'If you have any questions, please let the researcher know! Once the scan starts, you will not be able to communicate with the researcher. \n\nIf you''re ready to begin, advance to the next screen. ->'
    }

    {
    ['Your study partner''s story has finished. \n\nThis part of the study is now over. We''ll come take you out of the scanner to do some other tasks. Press the ', next_button, ' to exit the session. ->']
    }
};

triggerWait_messages = {
    []
    []
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

%OPTIONAL: Draw scan trigger wait screen; if in scanner, wait for scan trigger, otherwise wait for button press
currentWait_message = triggerWait_messages{instructNum};
if ~isempty(currentWait_message)
    DrawFormattedText(screenPointer, currentWait_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
    Screen('Flip', screenPointer);
    if strcmp(inputDevice, 'keyboard')
        eval(wait_for_button_press);
    end
end

end

