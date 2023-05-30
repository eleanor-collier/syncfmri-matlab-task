function do_math()
%SyncDisclosures fMRI script to present math problems on screen
%Eleanor Collier
%5/30/2023

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

%Set screen advance commands based on whether scanning
if scanning
    wait_for_button_press = 'WaitSecs(1); wait_for_DP_buttons(600, LH_red_button)'; %Wait for 1 second, then wait for button 2
    next_button = 'RED BUTTON'; %Key label in instructions
else
    wait_for_button_press = 'RestrictKeysForKbCheck(KbName(''rightarrow'')); KbStrokeWait; RestrictKeysForKbCheck([]);'; %Wait for right arrow key
    next_button = 'RIGHT ARROW KEY'; %Key label in instructions
end

%Math instructions
math_instructs=['If true, press the ', next_button ':'];

%Math problems (problem set picked randomly from 3 different sets)
randomized_problem_sets = Shuffle({
    {
        '1 + 2 = 6'
        '5 - 4 = 1'
        '5 + 5 = 20'
        '4 + 6 = 10'
        '7 - 3 = 6'
        '8 + 1 = 9'
    };
    
    {
        '3 + 3 = 5'
        '4 - 1 = 3'
        '6 - 1 = 3'
        '5 + 3 = 8'
        '9 - 4 = 2'
        '8 - 5 = 3'
    };
    
    {
        '2 + 8 = 9'
        '7 - 2 = 5'
        '3 + 4 = 8'
        '5 - 2 = 3'
        '9 - 2 = 5'
        '6 + 3 = 9'
    };
});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START MATH PROBLEMS
%Loop through math problems in desired set
problem_set = randomized_problem_sets{1}
for problem = 1:length(problem_set)
    % Display math problem
    DrawFormattedText(screenPointer, [math_instructs, '\n\n', problem_set{problem}], sx, sy, color, wrapat, flipHorizontal, flipVertical, vSpacing);
    Screen('Flip', screenPointer);
    WaitSecs(5);
    
    % Display blank screen for half second
    DrawFormattedText(screenPointer, '');
    Screen('Flip', screenPointer);
    WaitSecs(0.5);
end

end
