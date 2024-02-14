function axisDisplacements(obj)


fig = figure;

nexttile
Ux = obj.solver.displacedNodeMatrix(:,1);

visualizeCrane(obj.solver.preprocessor,"displacedCoord", "Ux", Ux)

nexttile
Uy = obj.solver.displacedNodeMatrix(:,2);

visualizeCrane(obj.solver.preprocessor,"displacedCoord", "Uy",Uy)

nexttile
Uz = obj.solver.displacedNodeMatrix(:,3);

visualizeCrane(obj.solver.preprocessor,"displacedCoord", "Uz",Uz)


nexttile
Utotal = sqrt(Ux.^2+Uy.^2+Uz.^2);

visualizeCrane(obj.solver.preprocessor,"displacedCoord", "U_{total}" ,Utotal)

fig.Children.Title.String = 'Ux - Uy - Uz Displacements';
end



function visualizeCrane(obj, coord, FigName,  scale)
%VISUALIZECRANE Summary of this function goes here
%   Detailed explanation goes here

nodeMatrix = obj.node_matrix;
elementArray = obj.elements_matrix;
Ay = obj.element_properties.non_diagonal_rods_surface;


% Visualization code
plot3(0, 0, 0, 'o')
title(FigName)
xlabel('x [mm]')
ylabel('y [mm]')
zlabel('z [mm]')
hold on

% Circle the nodes
for i = 1:numel(nodeMatrix)
    scatter3(nodeMatrix(i).(coord)(1), nodeMatrix(i).(coord)(2), nodeMatrix(i).(coord)(3), 'filled', 'r')
end

% Visual creation of the crane
if FigName == "Undeformed"
    for i = 1:numel(elementArray)
        node1 = elementArray(i).nodes(1).(coord);
        node2 = elementArray(i).nodes(2).(coord);
        lineWidth = 2*(elementArray(i).surface == Ay) + 0.5*(elementArray(i).surface ~= Ay);
        
        line([node1(1), node2(1)], [node1(2), node2(2)], [node1(3), node2(3)], 'LineWidth', lineWidth)
    end
else
    
    [Min, Max] = dataobject.library.postProcessorUtils.elementColor(obj, scale);
    
    caxis([Min Max]);
    D = colorbar;
    ylabel(D, FigName + ' [mm] Dsiplacement')
    camproj('orthographic')
end



axis auto
axis equal

end