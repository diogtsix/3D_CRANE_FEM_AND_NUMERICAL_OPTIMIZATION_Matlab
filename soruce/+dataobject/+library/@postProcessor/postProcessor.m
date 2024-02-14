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
        end
        
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.solver dataobject.library.solver = ...
                    dataobject.library.solver.define();
                options.scaleFactor (1,1) {mustBePositive} = 32;
            end
            obj = feval(mfilename('class'),...
                options.scaleFactor);
        end
    end
    
end

