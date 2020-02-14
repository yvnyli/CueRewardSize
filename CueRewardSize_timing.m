%Delayed Match-to-Sample (DMS) timing script

% This task requires that either an "eye" input or joystick (attached to the
% eye input channels) is available to perform the necessary responses.
%
% During a real experiment, a task such as this should make use of the
% "eventmarker" command to keep track of key actions and state changes (for
% instance, displaying or extinguishing an object, initiating a movement, etc).

% DEFINE TASKOBJECTS
fixation_point = 1;
trialGate = 2;
cue = 3;

% DEFINE EDITABLE VARIABLES
editable('wait_for_fix');
editable('initial_fix');
editable('sample_fix');
editable('delay');
editable('half_iti');
editable('fix_radius');
editable('reward_small');
editable('reward_large');

% define time intervals (in ms):
wait_for_fix = 1000;
initial_fix = 500;
cue_fix = 500;
delay = 500;
half_iti = 1000;
% max_reaction_time = 500;
% saccade_time = 80;
% hold_target_time = 300;

% fixation window (in degrees):
fix_radius = 1;

% reward
reward_small = 20;
reward_large = 150;


% TASK:
[TimeTrialGateOn] = toggleobject(trialGate, 'eventmarker',1,'status','on');

% initial fixation:
[TimeFixOn] = toggleobject(fixation_point,'eventmarker',3,'status','on');
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget 
  [TimeTrialGateOff] = toggleobject(trialGate,'eventmarker',2,'status','off');
  toggleobject(fixation_point,'eventmarker',4,'status','off');
  trialerror(4); % no fixation
  return
end

% hold FP fixation
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget
  [TimeTrialGateOff] = toggleobject(trialGate,'eventmarker',12,'status','off');
  toggleobject(fixation_point,'eventmarker',14,'status','off');
  trialerror(3); % broke fixation
  return
end

% turn on cue
[TimeCueOn] = toggleobject(cue,'eventmarker',25,'status','on'); 

% maintain FP fixation
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, cue_fix);
if ~ontarget
  [TimeTrialGateOff] = toggleobject(trialGate,'eventmarker',22,'status','off');
  toggleobject([fixation_point cue],'eventmarker',24,'status','off');
  trialerror(3); % broke fixation
 return
end

% delay epoch
% turn off FP and cue
toggleobject([fixation_point cue],'eventmarker',34,'status','off');
idle(delay);

% reward
if strcmp(TrialRecord.CurrentConditionInfo.RewardSize,'small')
  goodmonkey(reward_small, 'NumReward', 1);
else
  goodmonkey(reward_large, 'NumReward', 1);
end
idle(half_iti);
[TimeTrialGateOff] = toggleobject(trialGate,'eventmaker',100,'status','off');
idle(half_iti);
trialerror(0);
return