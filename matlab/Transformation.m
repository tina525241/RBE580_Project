%% initialize
clear; clc;

% read data
M = readmatrix('davinci wrist sample.csv');

% Extracting rotations and translations from the vicon data collected in lab
Group1_Rxyz=M(:,3:5);
Group1_Txyz=M(:,6:8);
Group2_Rxyz=M(:,9:11);
Group2_Txyz=M(:,12:14);
Group3_Rxyz=M(:,15:17);
Group3_Txyz=M(:,18:20);

% Creating empty matrixces for preallocation
handang=[];tarang=[];

% %--------ROS---------
rosshutdown
setenv('ROS_MASTER_URI','http://192.168.1.19:11311') %%%%%%%%%% change this 
rosinit

% % Define publisher
TransMatrix_pub = rospublisher('TransMatrix', 'std_msgs/Float64MultiArray');
HandAng_pub = rospublisher('HandAng', 'std_msgs/Float64');
TransMatrix_msg = rosmessage(TransMatrix_pub);
HandAng_msg = rosmessage(HandAng_pub);

% %-----------------------

%----------------hand------------------
% Hand control transformation matrix 
%
% T_hand:
%
% _____ 0
%   |
%   |   hand      
%

T1_hand=GetTransformationMatrix(Group1_Rxyz(5,:), Group1_Txyz(5,:)); 
T2_hand=GetTransformationMatrix(Group2_Rxyz(5,:), Group2_Txyz(5,:)); 
T3_hand=GetTransformationMatrix(Group3_Rxyz(5,:), Group3_Txyz(5,:));

g1=Group1_Txyz(5,:);
g2=Group2_Txyz(5,:);
g3=Group3_Txyz(5,:);
hand=vertcat(g1,g2,g3);
plot3(hand(:,1),hand(:,2),hand(:,3),'color','blue')
hold on; grid on;


%----------------target--------------------------------------------------
%--read transformation matrix from the simulation and replace the T_target
%below??
%------------------------------------------------------------------------
% T_target:
%
% _____ 0
%   |
%   |   target      
%
% target tranformation matrix
R1_target=eye(3);
P1_target=[100 100 100]';
T1_target=[R1_target P1_target;0 0 0 1];
R2_target=eye(3);
P2_target=[100 101 101]';
T2_target=[R2_target P2_target;0 0 0 1];
R3_target=eye(3);
P3_target=[100 105 100]';
T3_target=[R3_target P3_target;0 0 0 1];
%-------------------------------------------


%% start moving
% red circle: target
% blue circle: hand
for i=6:2000
    % New hand transformation matrix
    T1_hand=GetTransformationMatrix(Group1_Rxyz(i,:), Group1_Txyz(i,:));
    T2_hand=GetTransformationMatrix(Group2_Rxyz(i,:), Group2_Txyz(i,:));
    T3_hand=GetTransformationMatrix(Group3_Rxyz(i,:), Group3_Txyz(i,:));
    % New hand action
    g1=Group1_Txyz(i,:);
    g2=Group2_Txyz(i,:);
    g3=Group3_Txyz(i,:);
    hand=vertcat(g1,g2,g3);
    plot3(hand(:,1),hand(:,2),hand(:,3),'o-','color','blue')
    hold on; grid on;
    xlim([-1000,1000])
    ylim([-1000,1000])
    zlim([-1000,1000])
    
    % Get T_target_hand
    % T_target_hand:
    %
    % _____ target        ______ target   ______ o
    %   |           ==      |               |   
    %   |   hand            |    0          |   hand
    %
    T1_target_o=[R1_target' -R1_target*P1_target; 0 0 0 1];
    T1_target_hand=T1_target_o*T1_hand;
    
    T2_target_o=[R2_target' -R2_target*P2_target; 0 0 0 1];
    T2_target_hand=T2_target_o*T2_hand;
    
    T3_target_o=[R3_target' -R3_target*P3_target; 0 0 0 1];
    T3_target_hand=T3_target_o*T3_hand;
   

    % Update T_target
    % T_target:
    %
    % _____ 0            ______  0       ______ hand
    %   |           ==      |               |   
    %   |   target          |    hand       |   target
    T1_hand_target=[T1_target_hand(1:3,1:3)' -T1_target_hand(1:3,1:3)*T1_target_hand(1:3,4); 0 0 0 1];
    T1_target=T1_hand*T1_hand_target;
    
    T2_hand_target=[T2_target_hand(1:3,1:3)' -T2_target_hand(1:3,1:3)*T2_target_hand(1:3,4); 0 0 0 1];
    T2_target=T2_hand*T2_hand_target;
    
    T3_hand_target=[T3_target_hand(1:3,1:3)' -T3_target_hand(1:3,1:3)*T3_target_hand(1:3,4); 0 0 0 1];
    T3_target=T3_hand*T3_hand_target;
    
    % New target action
    target=vertcat(T1_target(1:3,4)',T2_target(1:3,4)',T3_target(1:3,4)');
    plot3(target(:,1),target(:,2),target(:,3),'o-','color','r')
    pause(0.01);
    hold off;

    % Calculate angles
    G12=g1-g2;
    G32=g3-g2;
    angle = atan2d(norm(cross(G12,G32)), dot(G12,G32));
    handang=[handang;angle];
    fprintf("hand_angle: %f\n",angle)

    T12=target(1,:)-target(2,:);
    T32=target(3,:)-target(2,:);
    a = atan2d(norm(cross(T12,T32)), dot(T12,T32));
    tarang=[tarang;a];
    fprintf("target_angle: %f\n\n",angle)
    
    % Publish 
    HandAng_msg.Data = angle;
    send(HandAng_pub, HandAng_msg);
    TransMatrix_msg.Data = T2_hand;
    send(TransMatrix_pub, TransMatrix_msg);
end



