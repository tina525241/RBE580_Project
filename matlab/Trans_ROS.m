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
handang=[];
% %--------ROS---------
% rosshutdown
% setenv('ROS_MASTER_URI','http://192.168.1.19:11311') %%%%%%%%%% change this 
% rosinit
% % % define publisher
% TransMatrix_pub = rospublisher('TransMatrix', 'std_msgs/Float64MultiArray');
% HandAng_pub = rospublisher('HandAng', 'std_msgs/Float64');
% TransMatrix_msg = rosmessage(TransMatrix_pub);
% HandAng_msg = rosmessage(HandAng_pub);
% %-----------------------


%% plot hand motion
%--------hand-----
% T_hand:
%
% _____ 0
%   |
%   |   hand      
%
for i=5:1000
  
    %hand transformation matrix
    T1_hand=GetTransformationMatrix(Group1_Rxyz(i,:), Group1_Txyz(i,:));
    T2_hand=GetTransformationMatrix(Group2_Rxyz(i,:), Group2_Txyz(i,:));
    T3_hand=GetTransformationMatrix(Group3_Rxyz(i,:), Group3_Txyz(i,:));
    %new hand action
    g1=Group1_Txyz(i,:);
    g2=Group2_Txyz(i,:);
    g3=Group3_Txyz(i,:);
    hand=vertcat(g1,g2,g3);
    plot3(hand(:,1),hand(:,2),hand(:,3),'o-','color','blue')
    hold on; grid on;
    xlim([-500,500])
    ylim([-500,500])
    zlim([500,1000])
    pause(0.01);
    hold off
   
   
    %calculate angles
    G12=g1-g2;
    G32=g3-g2;
    angle = atan2d(norm(cross(G12,G32)), dot(G12,G32));
    handang=[handang;angle];
    fprintf("hand_angle: %f\n",angle)
   
    %publish 
%     HandAng_msg.Data = angle;
%     send(HandAng_pub, HandAng_msg);
%     TransMatrix_msg.Data = T2_hand;
%     send(TransMatrix_pub, TransMatrix_msg);
end



