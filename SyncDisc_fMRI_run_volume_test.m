%SyncDisc fMRI volume test master script
%Eleanor Collier
%6/28/2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DESCRIPTION
%This script takes runs a single audio file for the purpose of volume testing by calling the 
%test_volume function.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Clear existing variables & screens
clear all;
sca;

%Global variables
global screenPointer rect speaker speaker_name scanning LH_red_button

%Collect user-specified subject ID for speaker
speaker = input('Enter Speaker ID: ');

%Collect user-specified name of speaker
speaker_name = input('Enter First Name of Speaker: ');

%Determine whether scanning or not
scanning = input('Scanning? (0 = no, 1 = yes): ');

%Button box DINs
LH_red_button = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP
% Clear workspace & screen
close all;
sca;

%Set screen defaults
Screen('Preference', 'SkipSyncTests', 1);
%Screen('Preference', 'DefaultFontName', 'Avenir Book');
Screen('Preference', 'DefaultFontName', 'Helvetica');
Screen('Preference', 'DefaultFontSize', 70);
screens      = Screen('Screens');
screenNumber = max(screens);
white        = WhiteIndex(screenNumber);
black        = BlackIndex(screenNumber);
PsychDefaultSetup(2);

%Hide cursor
HideCursor();

%Display black screen
[screenPointer, rect] = Screen('OpenWindow', screenNumber, black);

%Initialize audio driver
% InitializePsychSound;

%Open Datapixx
if scanning
    Datapixx('Open');
    Datapixx('StopAllSchedules');
    Datapixx('RegWrRd');
    Datapixx('EnableDinDebounce');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN EXPERIMENT

%Experiment blocks
test_volume();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLOSE EVERYTHING & CLEAN UP
%Close Datapixx
if scanning
    Datapixx('Close');
end

close all;
clearvars;
sca;



