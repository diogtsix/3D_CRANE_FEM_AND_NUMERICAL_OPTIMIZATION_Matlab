function obj = structuralCalculations(obj)
%STRUCTURALCALCULATIONS Summary of this function goes here
%   Detailed explanation goes here


[obj, C] = applyBoundaryConditions(obj);

%Load Calculation

obj = assembleGlobalForceVector(obj);
obj = calculateDisplacements(obj);

obj =  reactionMatrix(obj, C);

% obj.strainMatrix = [];
% obj.stressMatrix = [];


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

obj.reactionMatrix = C * obj.globalDsiplacementVector; 

U = reshape(obj.globalDsiplacementVector,3,[]);
obj.globalDsiplacementVector = U';
end
