function nodeMatrix = createNodeMatrix(obj)
% CREATENODEMATRIX Generate a node matrix for the crane structure
%   This function initializes the node matrix with the appropriate
%   coordinates for the crane base, body, head, and ropes.
%   The Coordinates are in respect to the global Frame



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
for idx = [1 ropeIndices]
    nodeMatrix(idx).boundary_condition(:) = 1 ;
end
for idx = [1 3]
    nodeMatrix(2).boundary_condition(idx) = 1 ;
    
end

%% Force (I need to review it latter)
nodeMatrix(29).force(3) = 0;

%% Add elements to cordinates if frame
if obj.type_of_elements == "frame"
    for ii = 1:obj.number_of_nodes
        nodeMatrix(ii).cordinates = [nodeMatrix(ii).cordinates 0 0 0];
        nodeMatrix(ii).displacedCoord = [nodeMatrix(ii).displacedCoord 0 0 0];
        nodeMatrix(ii).boundary_condition = [nodeMatrix(ii).boundary_condition 0 0 0];
        nodeMatrix(ii).force = [nodeMatrix(ii).force 0 0 0];
    end
end

%% Crane Rotation

for idx = 3: obj.number_of_nodes-3
    
    xRotation = nodeMatrix(idx).cordinates(1)*cos(pi/2-phi) + nodeMatrix(idx).cordinates(3)*sin(pi/2-phi);
    zRotation = nodeMatrix(idx).cordinates(3)*cos(pi/2-phi) - nodeMatrix(idx).cordinates(1)*sin(pi/2-phi);
    nodeMatrix(idx).cordinates(1) = xRotation;
    nodeMatrix(idx).cordinates(3) = zRotation;
end

%% Crane Translation
for idx = 1: obj.number_of_nodes-3
    nodeMatrix(idx).cordinates(1) = nodeMatrix(idx).cordinates(1) + obj.element_properties.rope_rigid_point_x_pos;
end

%% Calculate Num of elements

cubes=(i-1)*12;
base=9;
ropes=4;
head=13;
numOfElementsTruss = i*6+cubes+base+head+ropes;
obj.number_of_elements = numOfElementsTruss ;
obj.surfaceForEqualWeight = 0;

if obj.type_of_elements == "frame"
    
    %Create a free node for the FRAME crane
    obj.freeNode = dataobject.library.node.define(...
        "boundary_condition",  zeros(1,6), ...
        "cordinates_in_mm",(obj.element_properties.rope_rigid_point_x_pos + 2*L)*ones(1,6), ...
        "displacedCoord_in_mm",  zeros(1,6) , ...
        "force_in_N", zeros(1,6) , ...
        "id_global",  obj.number_of_nodes +1);
    
    cubes=(i-1)*4;
    base=5;
    head=9;
    ropes=4;
    planes=i*4;
    obj.number_of_elements = cubes+ropes+head+base+planes;
    
    Ay = obj.element_properties.non_diagonal_rods_surface ;
    Ad = obj.element_properties.diagonal_rods_surface ;
    
    ny = obj.number_of_elements - 4;
    obj.surfaceForEqualWeight = ((numOfElementsTruss - ny)*Ad +ny*Ay) / (ny);
    
end


