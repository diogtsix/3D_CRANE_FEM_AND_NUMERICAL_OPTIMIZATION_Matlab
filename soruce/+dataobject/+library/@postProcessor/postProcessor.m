classdef postProcessor < generic
    %POSTPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        solver
        scaleFactor
    end
    
    methods
        function obj = postProcessor(solverObj, scaleFactor)
            
            obj.solver = solverObj;
            obj.scaleFactor = scaleFactor;
            obj.scale(); 
        end  
    end
    
    methods
        function scale(obj)
            %% Apply Scale Factor 
            if obj.scaleFactor ~= 0
                dofs = numel(obj.solver.preprocessor.node_matrix(1).cordinates);
                
                for ii = 1:obj.solver.preprocessor.number_of_nodes
                    % Vectorized operation for updating displaced coordinates
                    obj.solver.preprocessor.node_matrix(ii).displacedCoord = ...
                        obj.solver.preprocessor.node_matrix(ii).cordinates + ...
                        obj.scaleFactor * obj.solver.displacedNodeMatrix(ii, 1:dofs);
                end
            end            
        end
        
        function visualizeAll(obj)
            
        end
        
        function undeformedDeformed(obj)
            dataobject.library.postProcessorUtils.undeformedDeformedCrane(obj)        
        end
            function axisDisplacements(obj)
            dataobject.library.postProcessorUtils.axisDisplacements(obj)        
        end    
    end
    
    
    methods (Static)
        function obj = define(options)
            arguments
                options.solver dataobject.library.solver = ...
                    dataobject.library.solver.define();
                options.scaleFactor (1,1) {mustBePositive} = 100;
            end
            obj = feval(mfilename('class'),...
                options.solver, ...
                options.scaleFactor);
        end
    end
    
end

