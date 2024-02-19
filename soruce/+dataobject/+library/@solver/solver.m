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
        
        totalReactionForce
        totalReactionTorque
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
            obj.totalReactionForce = [];
            obj.totalReactionTorque = [];
            
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
            
            obj = dataobject.library.solverUtils.structuralCalculations(obj);
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

