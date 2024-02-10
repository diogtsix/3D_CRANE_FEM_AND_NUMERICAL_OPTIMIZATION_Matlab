function elementMatrix = createElementMatrix(obj)
%CREATEELEMENTMATRIX Summary of this function goes here
%   Detailed explanation goes here

%% Initialize the node matrix with empty nodes
elementArray = repmat(dataobject.library.element.define(), obj.number_of_elements, 1);

%% Initialize steady value properties
length = obj.element_properties.rod_length;
phi = obj.element_properties.crane_angle;
surface = obj.element_properties.non_diagonal_rods_surface ; 
surfaceDigonal = obj.element_properties.diagonal_rods_surface ; 
elasticityModulus = obj.element_properties.Young_modulus_E;

%% Elements Base

% Base element
elementArray(1) = dataobject.library.element.define(...
    'element_id', 1, ...
    'nodes', [obj.node_matrix(1), obj.node_matrix(2)], ...
    'surface_in_mm2', surface, ...
    'elastic_module_in_N_mm2', elasticityModulus);


% Additional Base elements
D = [3 4 5 6];
for a = 1:2
    for i = 2:5
        element_id = i + (a - 1) * 4;
        elementArray(element_id) = dataobject.library.element.define(...
            'element_id', element_id, ...
            'nodes', [obj.node_matrix(a), obj.node_matrix(D(1))], ...
            'surface_in_mm2', surface, ...
            'elastic_module_in_N_mm2', elasticityModulus);
        D = circshift(D, -1);
    end
end

%% BODY Elements 
%-------------Horizontal ELements XY Plane 
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
D = [3 4 5 6];

for i = currentElementID:(currentElementID + 3)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(1)), obj.node_matrix(D(2))], ...
        'surface_in_mm2', surface, ...
        'elastic_module_in_N_mm2', elasticityModulus);
    D = circshift(D, -1);
end

%-------------Diagonal ELements XY Plane 
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 1)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 3))], ...
        'surface_in_mm2', surfaceDigonal, ... % Assuming Ad is defined
        'elastic_module_in_N_mm2', elasticityModulus);
end
%-------------Vertical ELements Z Axis
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 3)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 1) + 4)], ...
        'surface_in_mm2', surface, ...
        'elastic_module_in_N_mm2', elasticityModulus);
end
%-------------Diagonal Elements Sides

currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 7)
    if i <= currentElementID + 3
        secondNodeIndex = D(mod(i - currentElementID, 4) + 1) + 5;
    else
        secondNodeIndex = D(mod(i - currentElementID - 4, 4) + 1) + 3;
    end
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(mod(i - currentElementID, 4) + 1)), obj.node_matrix(secondNodeIndex)], ...
        'surface_in_mm2', surfaceDigonal, ...
        'elastic_module_in_N_mm2', elasticityModulus);
end
D = D + 4;

%% Elements in the last top plane
%---------------------Horizontal
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;

for i = currentElementID:(currentElementID + 3)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(1)), obj.node_matrix(D(2))], ...
        'surface_in_mm2', surface, ...
        'elastic_module_in_N_mm2', elasticityModulus );
    D = circshift(D, -1);
end
% ------------- Diagonal
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 1)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 3))], ...
        'surface_in_mm2', surfaceDigonal, ... % Assuming Ad is defined
        'elastic_module_in_N_mm2', elasticityModulus);
end
%% HEAD
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 3)
    
    if i == currentElementID || i == currentElementID + 3
        s = surface;
    else
        s = surfaceDigonal; 
    end
    
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(1)), obj.node_matrix(obj.number_of_nodes - 5)], ...
        'surface_in_mm2', s, ...
        'elastic_module_in_N_mm2', elasticityModulus);
    D = circshift(D, -1);
end

currentElementID = numel(nonzeros([elementArray.element_id])) + 1;

for i = currentElementID:(currentElementID + 3)
    
        
    if i == currentElementID || i == currentElementID + 3 
        s = surfaceDigonal;
    else
        s = surface; 
    end
    
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(1)), obj.node_matrix(obj.number_of_nodes - 4)], ...
        'surface_in_mm2', s, ...
        'elastic_module_in_N_mm2', elasticityModulus);
    D = circshift(D, -1);
end

currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
elementArray(currentElementID) = dataobject.library.element.define(...
    'element_id', currentElementID, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes - 5), obj.node_matrix(obj.number_of_nodes - 4)], ...
    'surface_in_mm2', surface, ...
    'elastic_module_in_N_mm2', elasticityModulus);

%% Ropes
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;

% First rope element
elementArray(currentElementID) = dataobject.library.element.define(...
    'element_id', currentElementID, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes - 2), obj.node_matrix(13)], ...
    'surface_in_mm2', surfaceDigonal, ...
    'elastic_module_in_N_mm2', elasticityModulus);

% Second rope element
elementArray(currentElementID + 1) = dataobject.library.element.define(...
    'element_id', currentElementID + 1, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes), obj.node_matrix(14)], ...
    'surface_in_mm2', surfaceDigonal, ...
    'elastic_module_in_N_mm2', elasticityModulus);

% Third and fourth rope elements
for i = currentElementID + 2:currentElementID + 3
    
    secondNodeIndex = 26 * (i == (currentElementID + 2)) + 25 * (i ~= (currentElementID + 2));

    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(obj.number_of_nodes - 1), obj.node_matrix(secondNodeIndex)], ...
        'surface_in_mm2', surfaceDigonal, ...
        'elastic_module_in_N_mm2', elasticityModulus);
end

elementMatrix = elementArray; 
end

