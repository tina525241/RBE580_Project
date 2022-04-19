%% initialize
clear; clc;
% read data
M = readmatrix('davinci wrist sample.csv');
Group1_Rxyz=M(:,3:5);
Group1_Txyz=M(:,6:8);
Group2_Rxyz=M(:,9:11);
Group2_Txyz=M(:,12:14);
Group3_Rxyz=M(:,15:17);
Group3_Txyz=M(:,18:20);
%%
% red circle: target
% black circle: origin
% blue circle: hand


%----------------control------------------
% hand control transformation matrix 

% T_hand:
%
% _____ 0
%   |
%   |   hand      
%

T_hand=GetTransformationMatrix(Group2_Rxyz(5,:), Group2_Txyz(5,:)); 

origin=[0 0 0]';
hand=T_hand(1:3,1:3)*origin+T_hand(1:3,4);
plot3(origin(1),origin(2),origin(3),'o','Color','black');
hold on; grid on;
% plot3(hand(1),hand(2),hand(3),'o','Color','blue');
% grid on; hold on;
%------------------------------------------

%----------------target(fake)--------------------
% T_target:
%
% _____ 0
%   |
%   |   target      
%
% target tranformation matrix
R_target=eye(3);
P_target=[200 100 300]';
T_target=[R_target P_target;0 0 0 1];
% target
target=T_target(1:3,1:3)*origin+T_target(1:3,4);
% plot3(target(1),target(2),target(3),'o','Color','red')
% hold on;
%-------------------------------------------


%% start moving
for i=6:3619
    %new hand transformation matrix
    T_hand=GetTransformationMatrix(Group2_Rxyz(i,:), Group2_Txyz(i,:));
    %new hand action
    hand=T_hand(1:3,1:3)*origin+T_hand(1:3,4);
   
    %get T_targe_hand
    % T_target_hand:
    %
    % _____ targt        ______ targrt   ______ o
    %   |           ==      |               |   
    %   |   hand            |    0          |   hand
    %
    T_target_o=[R_target' -R_target*P_target; 0 0 0 1];
    T_target_hand=T_target_o*T_hand;
    
    %new target action

    target=T_target_hand(1:3,1:3)*hand+T_target_hand(1:3,4);
    
    %plot
    plot3(target(1),target(2),target(3),'o','Color','red');
    plot3(hand(1),hand(2),hand(3),'o','Color','blue');
    drawnow;
  
%      plot3(target(1),target(2),target(3),'o','Color','y');
%      plot3(hand(1),hand(2),hand(3),'o','Color','y');

    
    %update T_target
    % T_target:
    %
    % _____ 0            ______  0       ______ hand
    %   |           ==      |               |   
    %   |   target          |    hand       |   target
    T_hand_target=[T_target_hand(1:3,1:3)' -T_target_hand(1:3,1:3)*T_target_hand(1:3,4); 0 0 0 1];
    T_target=T_hand*T_hand_target;
    
end

