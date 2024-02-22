classdef optimization < generic
    %OPTIMIZATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initialPoint
        linearConstMatA
        linearConstVecb
        linearConstMatAeq
        linearConstVecbeq
        lowerBound
        upperBound
        nonLinearConst %function of non linear const
        objectiveFunction % function of my objFunction
        optimizationOptions
        
    end
    
    methods
        function obj = optimization(initialPoint,linearConstMatA, ...
                linearConstVecb, linearConstMatAeq, linearConstVecbeq, ...
                lowerBound, upperBound, nonLinearConst, objectiveFunction, ...
                optimizationOptions)
            
            obj.initialPoint = initialPoint ;
            obj.linearConstMatA = linearConstMatA ;
            obj.linearConstVecb = linearConstVecb ;
            obj.linearConstMatAeq = linearConstMatAeq ;
            obj.linearConstVecbeq = linearConstVecbeq ;
            obj.lowerBound = lowerBound ;
            obj.upperBound = upperBound ;
            obj.nonLinearConst = nonLinearConst ;
            obj.objectiveFunction = objectiveFunction ;
            obj.optimizationOptions = optimizationOptions ;
            
        end
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.initialPoint = [];
                options.linearConstMatA = [];
                options.linearConstVecb  = [];
                options.linearConstMatAeq = [] ;
                options.linearConstVecbeq  = [];
                options.lowerBound  = [];
                options.upperBound  = [];
                options.nonLinearConst  = [];
                options.objectiveFunction  = [];
                options.optimizationOptions  = []; 
            end
            obj = feval(mfilename('class'),...
                options.initialPoint, ...
                options.linearConstMatA, ...
                options.linearConstVecb, ...
                options.linearConstMatAeq, ...
                options.linearConstVecbeq, ...
                options.lowerBound, ...
                options.upperBound, ...
                options.nonLinearConst, ...
                options.objectiveFunction, ...
                options.optimizationOptions);
        end
    end
    
end

