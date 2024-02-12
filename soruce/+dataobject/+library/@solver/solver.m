classdef solver < generic
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        preprocessor
        globalStiffnessMatrix
        globalForceVector
        globalDsiplacementVector
        displacedNodeMatrix
        strainMatrix
        stressMatrix
        reactionMatrix
    end
    
    methods
        function obj = solver(preprocessorObj)
            %SOLVER Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.preprocessor = preprocessorObj;
            
            obj.globalStiffnessMatrix = [];
            obj.globalForceVector = [];
            obj.globalDsiplacementVector = [];
            obj.displacedNodeMatrix = [];
            obj.strainMatrix = [];
            obj.stressMatrix = [];
            obj.reactionMatrix = [];
            
            obj.globalStiffnessMatrix = obj.stiffnessMatrix();
            
            obj.structuralCalculations();
            
            
        end
    end
    
    % Calculate globalStiffness Matrix
    
    methods
        function K = stiffnessMatrix(obj)
            K = dataobject.library.solverUtils.stiffnessMatrix(obj);
        end
        
        function obj = structuralCalculations(obj)
            % Calculate Displacement, Strains, Stresses, Reactions
            % Applu Boundary Conditions in the Stiffness Matrix
            obj.applyBoundaryConditions();
            
            %Load Calculation
            
            obj.globalForceVector = obj.assembleGlobalForceVector;
            obj.globalDsiplacementVector = obj.calculateDisplacements();
            obj.displacedNodeMatrix = [];
            obj.strainMatrix = [];
            obj.stressMatrix = [];
            obj.reactionMatrix = [];
        end
        
        function displacements = calculateDisplacements(obj)
            % Ensure global stiffness matrix is not singular
            if det(obj.globalStiffnessMatrix) == 0
                error('Global stiffness matrix is singular. Cannot solve for displacements.');
            end
            
            % Assemble global force vector if not already done
            if isempty(obj.globalForceVector)
                obj.assembleGlobalForceVector();
            end
            
            % Perform the calculation
            displacements = obj.globalStiffnessMatrix\obj.globalForceVector;
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
        
        function obj = applyBoundaryConditions(obj)
            %Boundary COnditions via the penalnty method
            w = max(max(obj.globalStiffnessMatrix));
            dof = length(obj.preprocessor.node_matrix(1).cordinates); % degrees of freedom per node
            
            for j = 1:dof
                for i = 1:numel(obj.preprocessor.node_matrix)
                    if obj.preprocessor.node_matrix(i).boundary_condition(j) == 1
                        index = dof * i - (dof - j);
                        obj.globalStiffnessMatrix(index, index) = obj.globalStiffnessMatrix(index, index) + w * 10^4;
                        
                    end
                end
            end
        end
        
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.preprocessor dataobject.library.preprocessor = ...
                    dataobject.library.preprocessor.define();
            end
            obj = feval(mfilename('class'),...
                options.preprocessor);
        end
    end
    
end

