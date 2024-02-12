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
        function obj = solver(preprocessorObj,globalStiffnessMatrix, ...
                globalForceVector, globalDsiplacementVector, ...
                displacedNodeMatrix, strainMatrix, stressMatrix, ...
                reactionMatrix)
            %SOLVER Construct an instance of this class
            %   Detailed explanation goes here
            obj.preprocessor = preprocessorObj;
%             obj.globalStiffnessMatrix =globalStiffnessMatrix;
%             obj.globalForceVector = globalForceVector;
%             obj.globalDsiplacementVector = globalDsiplacementVector;
%             obj.displacedNodeMatrix = displacedNodeMatrix;
%             obj.strainMatrix = strainMatrix;
%             obj.stressMatrix = stressMatrix;
%             obj.reactionMatrix = reactionMatrix;
            
            obj.globalStiffnessMatrix = obj.stiffnessMatrix(); 
            
        end
    end
    
    % Calculate globalStiffness Matrix
    
    methods
        function K = stiffnessMatrix(obj)
            K = dataobject.library.solverUtils.stiffnessMatrix(obj);
            
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

