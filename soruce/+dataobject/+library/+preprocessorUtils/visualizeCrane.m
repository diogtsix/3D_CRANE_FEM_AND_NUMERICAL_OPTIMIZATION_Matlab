function visualizeCrane(obj, coord)
%VISUALIZECRANE Summary of this function goes here
%   Detailed explanation goes here

nodeMatrix = obj.node_matrix;
elementArray = obj.elements_matrix;
Ay = obj.element_properties.non_diagonal_rods_surface;


% Visualization code
plot3(0, 0, 0, 'o')
title('Undeformed Structure')
xlabel('x [mm]')
ylabel('y [mm]')
zlabel('z [mm]')
hold on

% Circle the nodes
for i = 1:numel(nodeMatrix)
    scatter3(nodeMatrix(i).(coord)(1), nodeMatrix(i).(coord)(2), nodeMatrix(i).(coord)(3), 'filled', 'r')
end

% Visual creation of the crane
for i = 1:numel(elementArray)
    node1 = elementArray(i).nodes(1).(coord);
    node2 = elementArray(i).nodes(2).(coord);
    lineWidth = 2*(elementArray(i).surface == Ay) + 0.5*(elementArray(i).surface ~= Ay);
    line([node1(1), node2(1)], [node1(2), node2(2)], [node1(3), node2(3)], 'LineWidth', lineWidth)
end

axis auto
axis equal
% Add additional plot features or legend here

end

