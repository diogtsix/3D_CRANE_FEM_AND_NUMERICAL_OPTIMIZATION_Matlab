function nodeMatrix = createNodeMatrix(obj)
% CREATENODEMATRIX Generate a node matrix for the crane structure
%   This function initializes the node matrix with the appropriate
%   coordinates for the crane base, body, head, and ropes.



%% Initialize the node matrix with empty nodes
nodeMatrix = dataobject.library.node.empty(obj.number_of_nodes, 0);

%% Initialize steady value properties
L = obj.element_properties.rod_length;
phi = obj.element_properties.crane_angle;

%% Node Cordinates
%% Crane Base Nodes
baseCoords = [0, -L/2, 0; 0, L/2, 0];
for idx = 1:2
    nodeMatrix(idx) = dataobject.library.node.define("id_global", idx);
    nodeMatrix(idx).cordinates = baseCoords(idx, :);
end
%% Crane Body

for i = 1:(obj.number_of_nodes - 8) / 4
    planeIndices = 2 + (1:4) + (i - 1) * 4;  % Calculate indices for this level    
    xCoords = L/2 * [1; 1; -1; -1];
    yCoords = L/2 * [-1; 1; 1; -1];
    zCoords = L * ones(4, 1) * i;
    
    for j = 1:4
        nodeMatrix(planeIndices(j)) = dataobject.library.node.define("id_global", planeIndices(j));
        nodeMatrix(planeIndices(j)).cordinates = [xCoords(j), yCoords(j), zCoords(j)];
    end
end


%% Crane Head
headIndices = 2 + (obj.number_of_nodes - 8) + (1:3);

headCoords = [L/2, -L/2, (i+1)*L;
    L/2, L/2, (i+1)*L;
    3*L/2, 0, i*L + L/2];

for idx = 1:3
    nodeMatrix(headIndices(idx)) = dataobject.library.node.define("id_global", headIndices(idx));
    nodeMatrix(headIndices(idx)).cordinates = headCoords(idx, :);
end
%% Ropes

ropeIndices = obj.number_of_nodes - 2 : obj.number_of_nodes;
for idx = 1:numel(ropeIndices)
    nodeMatrix(ropeIndices(idx)) = dataobject.library.node.define("id_global", ropeIndices(idx));
    
    nodeMatrix(ropeIndices(idx)).cordinates(1) = -obj.element_properties.rope_rigid_point_x_pos;
    nodeMatrix(ropeIndices(idx)).cordinates(3) = obj.element_properties.rope_rigid_point_z_pos; 

    if ropeIndices(idx) == obj.number_of_nodes - 2
        nodeMatrix(ropeIndices(idx)).cordinates(2) = L/2; 
    elseif ropeIndices(idx) == obj.number_of_nodes - 1
        nodeMatrix(ropeIndices(idx)).cordinates(2) = 0;  
    elseif ropeIndices(idx) == obj.number_of_nodes
        nodeMatrix(ropeIndices(idx)).cordinates(2) = -L/2; 
    end
end

%% Boundary Conditions 
for idx = 1:numel(ropeIndices)
nodeMatrix(idx).boundary_condition(:) = 1 ; 
end
for idx = [1 3]
    nodeMatrix(idx).boundary_condition(2) = 1 ; 

end

%% Force (I need to review it latter) 
    nodeMatrix(29).force(3) = 0;

end

