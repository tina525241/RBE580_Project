%======================================================
% Calculate the transformation Matrix from Vicon data
%======================================================

% Function Input: Hand rotation in terms of x, y, and z
% Function Output: Hand Trnaslation in terms of x, y, and z

function T=GetTransformationMatrix(hand_Rxyz, hand_Txyz)
    % Takes the magnitude of the vector hand_Rxyz
    n=norm(hand_Rxyz);
    % Takes the vector and divide it by the magnitude to get a unit vector
    unit_v=hand_Rxyz./n;
    % Converts to rotation 
    R=axang2rotm([unit_v n]);
    % Taking transpose of the translation
    P=hand_Txyz';
    % Get transformation.
    T=[R P;0 0 0 1];
end
