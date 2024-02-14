function  [Min, Max] =  elementColor(obj, scale)
ColorMap = colormap(jet(256));
range = linspace(0, 1, 256);

Max = max(scale);
Min = min(scale);

% Preallocate arrays for vertices and colors
vertices = zeros(obj.number_of_elements * 2, 3);
vertexColors = zeros(obj.number_of_elements * 2, 3);

for i = 1:obj.number_of_elements
    node1 = obj.elements_matrix(i).nodes(1).id_global;
    node2 = obj.elements_matrix(i).nodes(2).id_global;
    
    % Interpolated color for each node
    ColorMin = (scale(node1) - Min) / (Max - Min);
    ColorMax = (scale(node2) - Min) / (Max - Min);
    
    % Coordinates
    vertices(2*i-1, :) = obj.node_matrix(node1).displacedCoord;
    vertices(2*i, :) = obj.node_matrix(node2).displacedCoord;
    
    % Colors
    vertexColors(2*i-1, :) = interp1(range, ColorMap, ColorMin);
    vertexColors(2*i, :) = interp1(range, ColorMap, ColorMax);
end

% Draw all elements with patch
patch('Vertices', vertices, 'Faces', reshape(1:2*obj.number_of_elements, 2, [])', ...
    'FaceVertexCData', vertexColors, 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 1);
end


