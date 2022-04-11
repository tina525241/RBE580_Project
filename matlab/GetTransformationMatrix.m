%======================================================
% Calculate the transformation Matrix from Vicon data
%======================================================
function T=GetTransformationMatrix(hand_Rxyz, hand_Txyz)
    n=norm(hand_Rxyz);
    unit_v=hand_Rxyz./n;
    R=axang2rotm([unit_v n]);
    P=hand_Txyz';
    T=[R P;0 0 0 1];
end