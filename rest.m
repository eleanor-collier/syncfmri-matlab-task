function rest()
%SyncDisclosures fMRI script to present timer on screen while participant
%rests
%Eleanor Collier
%5/30/2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Global variables
global screenPointer rect data subject session_ID speaker speaker_name subject_is_odd speaker_is_odd scanning LH_red_button

%Recording length in seconds
restLength = 60;

%Key to skip recording
skipKey = 's';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START REST PERIOD
%Display timer for rest period
displayTimer(restLength, screenPointer, skipKey);

end
