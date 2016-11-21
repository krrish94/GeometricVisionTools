%% Script to test the rigid transformation estimation between two 3D point sets

% Ground truth Rotation (R), translation (t) to be applied to the points

% Angles of rotation about each axis (assume X-Y-Z euler angles)
ax = pi;
ay = pi/2;
az = pi/6;

% Corresponding rotation matrices
Rx = [1, 0, 0; ...
    0, cos(ax), -sin(ax); ...
    0, sin(ax), cos(ax)];
Ry = [cos(ay), 0, sin(ay); ...
    0, 1, 0; ...
    -sin(ay), 0, cos(ay)];
Rz = [cos(az), -sin(az), 0; ...
    sin(az), cos(az), 0; ...
    0, 0, 1];
R = Rx*Ry*Rz;
t = [1.2; 3.3; 2.4];
% R = eye(3);
% t = [1; 0; 0];

% Point set 1
p = [1, 0, 0; ...
    0, 1, 0; ...
    0, 0, 1; ...
    1, 1, 1; ...
    -1, 0, 0; ...
    0, -1, 0; ...
    0, 0, -1; ...
    -1, -1, -1]';

% Point set 2
q = R*p + repmat(t, 1, size(p,2));

% % Plot
% scatter3(p(1,:), p(2,:), p(3,:));
% hold on;
% scatter3(q(1,:), q(2,:), q(3,:));
% xlabel('X');
% ylabel('Y');
% zlabel('Z');

% Center the data points
p_ = p - repmat(mean(p,2), 1, size(p,2));
q_ = q - repmat(mean(q,2), 1, size(q,2));

% Compute the H matrix (whose SVD we need)
H = zeros(3);
for i = 1:size(p_,2)
    H = H + p_(:,i)*q_(:,i)';
end
% Compute the SVD of H
[U, D, V] = svd(H);

% Compute the estimated rotation
R_hat = V*U';
% Estimated translation
t_hat = mean(q,2) - R_hat*mean(p,2);
