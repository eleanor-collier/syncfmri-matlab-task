function instructions(instructNum)
%EmpOrient fMRI script to present instructions
%Eleanor Collier
%3/19/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject group inputDevice trigger LH_red_button

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
    wait_for_button_press = 'WaitSecs(1); SimpleWFE(600, LH_red_button)'; %Wait for 1 second, then wait for button 2
    next_button = 'BUTTON 2'; %Key label in instructions
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET INSTRUCTIONS
%Choose instruction set based on whether experiment is in scanner or out of scanner. Each line corresponds to a new instruction page.
instructs = {
    {
    ['Please read the following instructions carefully. To advance through the instruction pages, press the ', next_button, '. ->']
    'In this first scan session, you will share the stories you prepared. You''ll be recorded through the mic in front of you. ->'
    'In order for us to get good data, it is EXTREMELY important that you keep your head still while talking and only move your mouth. ->'
    'If you move your head even a little bit, we will get blurry pictures of your brain, just like if you tried to take an ordinary picture of someone in motion. ->'
    'When people talk, they normally nod up and down a little. However, you should try as hard as you can not to do this. Here are some tips for how to keep your head still: ->'
    'TIP #1: Notice the little bump at the very back of your head that''s resting deep in the pillow. Try to talk in a way where you don''t feel the hair there moving as much. ->'
    'TIP #2: Notice the skin on your forehead where the tape is sticking to it. Try to talk in a way where you don''t feel the tape pulling on your skin.'
    'Alright, to help you practice talking without moving your head, let''s do a practice round. ->'
    'In this practice round, we''d like you to talk about your typical weekly schedule. As you talk, try to keep your head as still as possible.->'
    'The practice round will last for 30 seconds. You''ll see a timer on the screen to help you keep track of time. ->'
    'While you talk, there will be some loud noises from the scanner. Don''t be alarmed; this is normal. ->'
    'If you have any questions, please let the researcher know! Once the scan starts, you will not be able to communicate with the researcher. \n\nIf you''re ready, advance to the next screen and wait until the timer appears to begin talking. ->'
    }

    {
    'Alright, now we''ll have you share the actual stories you prepared. ->'
    'As a reminder, we would like you to share 2 stories about positive experiences and 2 stories about negative experiences. ->'
    'Before each scan starts, you will see a prompt on the screen letting you know which story to share next (i.e., positive experience #1 or #2, or negative experience #1 or #2). ->'
    'When you begin your story, please remember NOT to explicitly state which story you are sharing. \n\nIn other words, do NOT say, "Now I will be talking about my first negative experience." Instead, simply tell your story without labeling it. ->'
    'While you are speaking, you''ll see a timer on the screen to help you keep track of time. ->'
    'Each story should be as close to 3 minutes in length as possible. ->'
    'Try to include enough detail in your story so it lasts the entire 3 minutes. ->'
    'But also make sure not to go over 3 minutes. Once the timer ends, the recording will stop, so it''s important that you finish your story by then. ->'
    'If you have any questions, please let the researcher know! Once the scan starts, you will not be able to communicate with the researcher. \n\nIf you''re ready, advance to the next screen and wait for the researcher to check in with you. ->'
    }

    {
    ['Thank you for sharing your story. \n\nThis part of the study is now over. We''ll come take you out of the scanner to do some other tasks. Press the ', next_button, ' to exit the session. ->']
    }
};

triggerWait_messages = {
    []
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

% %OPTIONAL: Draw scan trigger wait screen; if in scanner, wait for scan trigger, otherwise wait for button press
% currentWait_message = triggerWait_messages{instructNum};
% if ~isempty(currentWait_message)
%     DrawFormattedText(screenPointer, currentWait_message, sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
%     Screen('Flip', screenPointer);
%     if strcmp(inputDevice, 'keyboard')
%         eval(wait_for_button_press);
%     end
% end

end

