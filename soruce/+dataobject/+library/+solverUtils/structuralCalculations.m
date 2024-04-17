function obj = structuralCalculations(obj)
%STRUCTURALCALCULATIONS Summary of this function goes here
%   Detailed explanation goes here

[obj, C] = applyBoundaryConditions(obj);
%Load Calculation
obj = assembleGlobalForceVector(obj);
obj = calculateDisplacements(obj);
obj =  reactionMatrix(obj, C);
obj = newCoords(obj);
obj = strainStressCalc(obj);
end


function obj = calculateDisplacements(obj)
% Ensure global stiffness matrix is not singular
if det(obj.globalStiffnessMatrix) == 0 || isnan(det(obj.globalStiffnessMatrix))
    error('Global stiffness matrix is singular. Cannot solve for displacements.');
end

% Assemble global force vector if not already done
if isempty(obj.globalForceVector)
    obj.assembleGlobalForceVector();
end

% Perform the calculation
obj.globalDsiplacementVector = obj.globalStiffnessMatrix\obj.globalForceVector;
end

function obj = assembleGlobalForceVector(obj)
dofsPerNode = size(obj.preprocessor.node_matrix(1).cordinates, 2); % Assuming equal DOFs for all nodes
totalDofs = numel(obj.preprocessor.node_matrix) * dofsPerNode;
obj.globalForceVector = zeros(totalDofs, 1);

for i = 1:numel(obj.preprocessor.node_matrix)
    startIdx = (i - 1) * dofsPerNode + 1;
    endIdx = startIdx + dofsPerNode - 1;
    obj.globalForceVector(startIdx:endIdx) = obj.preprocessor.node_matrix(i).force; % Assuming 'forces' is a vector of DOFs per node
end
end

function [obj, C] = applyBoundaryConditions(obj)
%Boundary COnditions via the penalnty method
w = max(max(obj.globalStiffnessMatrix));
dof = length(obj.preprocessor.node_matrix(1).cordinates); % degrees of freedom per node
C = obj.globalStiffnessMatrix;

for j = 1:dof
    for i = 1:numel(obj.preprocessor.node_matrix)
        if obj.preprocessor.node_matrix(i).boundary_condition(j) == 1
            index = dof * i - (dof - j);
            obj.globalStiffnessMatrix(index, index) = obj.globalStiffnessMatrix(index, index) + w * 10^4;
        end
    end
end
end

function obj = reactionMatrix(obj, C)
dofs = numel(obj.preprocessor.node_matrix(1).cordinates);


obj.reactionMatrix = C * obj.globalDsiplacementVector;

reactions = reshape(obj.reactionMatrix, dofs,[])';

obj.totalReactionForce = sqrt(reactions(:,1).^2+reactions(:,2).^2+reactions(:,3).^2);

if obj.preprocessor.type_of_elements == "frame"
    obj.totalReactionTorque = sqrt(reactions(:,4).^2+reactions(:,5).^2+reactions(:,6).^2);  
end

U = reshape(obj.globalDsiplacementVector,dofs,[]);
obj.displacedNodeMatrix = U';
end

function obj = newCoords(obj)
dofs = numel(obj.preprocessor.node_matrix(1).cordinates);

for ii = 1:obj.preprocessor.number_of_nodes
    % Vectorized operation for updating displaced coordinates
    obj.preprocessor.node_matrix(ii).displacedCoord = ...
        obj.preprocessor.node_matrix(ii).cordinates + obj.displacedNodeMatrix(ii, 1:dofs);
end

end

function obj = strainStressCalc(obj)

elementMatrix = obj.preprocessor.elements_matrix;
% Preallocate arrays for strain and stress
strains = zeros(obj.preprocessor.number_of_elements, 1);
stresses = zeros(obj.preprocessor.number_of_elements, 1);

% Extract relevant properties for vectorized operations (if feasible)
deformedLengths = arrayfun(@(x) x.deformedLength, elementMatrix);
originalLengths = arrayfun(@(x) x.length, elementMatrix);
elasticModules = arrayfun(@(x) x.elastic_module, elementMatrix);

% Calculate strains and stresses
deltaL = deformedLengths - originalLengths;
strains = deltaL ./ originalLengths;
stresses = elasticModules .* strains;

% Assign results back to object properties
obj.strainMatrix = strains;
obj.stressMatrix = stresses;

end

