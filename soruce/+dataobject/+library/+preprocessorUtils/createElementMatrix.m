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

%% Set Element Type
if obj.type_of_elements == "truss"
    typeOfElement = "truss";
elseif obj.type_of_elements == "frame"
    typeOfElement = "beam";
end
%% Elements Base

% Base element
elementArray(1) = dataobject.library.element.define(...
    'element_id', 1, ...
    'nodes', [obj.node_matrix(1), obj.node_matrix(2)], ...
    'surface_in_mm2', surface, ...
    'elastic_module_in_N_mm2', elasticityModulus, ...
    'element_type', typeOfElement);


% Additional Base elements
D = [3 4 5 6];
for a = 1:2
    for i = 2:5
        
        element_id = i + (a - 1) * 4;
        
        if sum(element_id ==[3 4 6 9])
            s = surfaceDigonal;
        else
            s = surface ;
        end
        
        elementArray(element_id) = dataobject.library.element.define(...
            'element_id', element_id, ...
            'nodes', [obj.node_matrix(a), obj.node_matrix(D(1))], ...
            'surface_in_mm2', s, ...
            'elastic_module_in_N_mm2', elasticityModulus, ...
            'element_type', typeOfElement);
        D = circshift(D, -1);
    end
end

%% BODY Elements
%-------------Horizontal ELements XY Plane
D = [3 4 5 6];
for ii = 1:(obj.number_of_nodes -8)/4 - 1
    currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
    
    
    for i = currentElementID:(currentElementID + 3)
        elementArray(i) = dataobject.library.element.define(...
            'element_id', i, ...
            'nodes', [obj.node_matrix(D(1)), obj.node_matrix(D(2))], ...
            'surface_in_mm2', surface, ...
            'elastic_module_in_N_mm2', elasticityModulus, ...
            'element_type', typeOfElement);
        D = circshift(D, -1);
    end
    
    %-------------Diagonal ELements XY Plane
    currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
    for i = currentElementID:(currentElementID + 1)
        elementArray(i) = dataobject.library.element.define(...
            'element_id', i, ...
            'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 3))], ...
            'surface_in_mm2', surfaceDigonal, ...
            'elastic_module_in_N_mm2', elasticityModulus, ...
            'element_type', typeOfElement);
    end
    %-------------Vertical ELements Z Axis
    currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
    for i = currentElementID:(currentElementID + 3)
        elementArray(i) = dataobject.library.element.define(...
            'element_id', i, ...
            'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 1) + 4)], ...
            'surface_in_mm2', surface, ...
            'elastic_module_in_N_mm2', elasticityModulus, ...
            'element_type', typeOfElement);
    end
    %-------------Diagonal Elements Sides
    
    currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
    
    j = 1;
    
    for i = currentElementID:(currentElementID + 7)
        if i <= currentElementID + 3
            node1Indexes = D ;
            node2Indexes = circshift(D,-1)+4 ;
        else
            node1Indexes = D ;
            node2Indexes = circshift(D,1)+4 ;
        end
        elementArray(i) = dataobject.library.element.define(...
            'element_id', i, ...
            'nodes', [obj.node_matrix(node1Indexes(j)), obj.node_matrix(node2Indexes(j))], ...
            'surface_in_mm2', surfaceDigonal, ...
            'elastic_module_in_N_mm2', elasticityModulus, ...
            'element_type', typeOfElement);
        j = j+1;
        if j > 4
            j = 1;
        end
    end
    D = D + 4;
end
%% Elements in the last top plane
%---------------------Horizontal
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;

for i = currentElementID:(currentElementID + 3)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(1)), obj.node_matrix(D(2))], ...
        'surface_in_mm2', surface, ...
        'elastic_module_in_N_mm2', elasticityModulus , ...
        'element_type', typeOfElement);
    D = circshift(D, -1);
end
% ------------- Diagonal
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 1)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(D(i - currentElementID + 1)), obj.node_matrix(D(i - currentElementID + 3))], ...
        'surface_in_mm2', surfaceDigonal, ...
        'elastic_module_in_N_mm2', elasticityModulus, ...
        'element_type', typeOfElement);
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
        'elastic_module_in_N_mm2', elasticityModulus, ...
        'element_type', typeOfElement);
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
        'elastic_module_in_N_mm2', elasticityModulus, ...
        'element_type', typeOfElement);
    D = circshift(D, -1);
end

currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
elementArray(currentElementID) = dataobject.library.element.define(...
    'element_id', currentElementID, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes - 5), obj.node_matrix(obj.number_of_nodes - 4)], ...
    'surface_in_mm2', surface, ...
    'elastic_module_in_N_mm2', elasticityModulus, ...
    'element_type', typeOfElement);

tipNode = obj.number_of_nodes - 3;
nodesToTip = [ ...
    D(1), ...
    D(2), ...
    obj.number_of_nodes - 5, ...
    obj.number_of_nodes - 4];

% ------------- Tip Node
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;
for i = currentElementID:(currentElementID + 3)
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(nodesToTip(1)), obj.node_matrix(tipNode)], ...
        'surface_in_mm2', surface, ... % Assuming Ad is defined
        'elastic_module_in_N_mm2', elasticityModulus, ...
        'element_type', typeOfElement);
    nodesToTip = circshift(nodesToTip, -1) ;
end

%% Ropes
currentElementID = numel(nonzeros([elementArray.element_id])) + 1;

% First rope element
elementArray(currentElementID) = dataobject.library.element.define(...
    'element_id', currentElementID, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes - 2), obj.node_matrix(13)], ...
    'surface_in_mm2', surfaceDigonal, ...
    'elastic_module_in_N_mm2', elasticityModulus, ...
    'element_type', "truss");

% Second rope element
elementArray(currentElementID + 1) = dataobject.library.element.define(...
    'element_id', currentElementID + 1, ...
    'nodes', [obj.node_matrix(obj.number_of_nodes), obj.node_matrix(14)], ...
    'surface_in_mm2', surfaceDigonal, ...
    'elastic_module_in_N_mm2', elasticityModulus, ...
    'element_type', "truss");

% Third and fourth rope elements
for i = currentElementID + 2:currentElementID + 3
    
    secondNodeIndex = 26 * (i == (currentElementID + 2)) + 25 * (i ~= (currentElementID + 2));
    
    elementArray(i) = dataobject.library.element.define(...
        'element_id', i, ...
        'nodes', [obj.node_matrix(obj.number_of_nodes - 1), obj.node_matrix(secondNodeIndex)], ...
        'surface_in_mm2', surfaceDigonal, ...
        'elastic_module_in_N_mm2', elasticityModulus, ...
        'element_type', "truss");
end


%% Remove all diagonal elements if brome is frame


if obj.type_of_elements == "frame"
    
    elementMatrix = repmat(dataobject.library.element.define(),obj.number_of_elements, 1);
    
    for ii = 1: numel(nonzeros([elementArray.element_id]))
        
        if elementArray(ii).surface == surface || sum(ii == (numel(nonzeros([elementArray.element_id]))-3):numel(nonzeros([elementArray.element_id])))
            elementArray(ii).surface = obj.surfaceForEqualWeight;
            elementMatrix(numel(nonzeros([elementMatrix.element_id])) + 1) = elementArray(ii);
        end
    end
    
else
    elementMatrix = elementArray;
    
end


end

