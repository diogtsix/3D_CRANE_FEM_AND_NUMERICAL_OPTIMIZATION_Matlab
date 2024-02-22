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
        optimizationMethod
        structure % For our case it's the crane
    end
    
    methods
        function obj = optimization(initialPoint,linearConstMatA, ...
                linearConstVecb, linearConstMatAeq, linearConstVecbeq, ...
                lowerBound, upperBound, nonLinearConst, ...
                optimizationMethod, structure)
            
            obj.initialPoint = initialPoint ;
            obj.linearConstMatA = linearConstMatA ;
            obj.linearConstVecb = linearConstVecb ;
            obj.linearConstMatAeq = linearConstMatAeq ;
            obj.linearConstVecbeq = linearConstVecbeq ;
            obj.lowerBound = lowerBound ;
            obj.upperBound = upperBound ;
            obj.nonLinearConst = nonLinearConst ;
            obj.optimizationAlgorithm = optimizationMethod ;
            obj.structure = structure;
            
        end
    end
    
    methods
        function [Surface,Weight,exitflag,output,lambda,grad,hessian] = ...
                optimizationAlgorithm(obj)
            
            lb = obj.lowerBound ; % lowerBound
            ub = obj.upperBound ; % UpperBound
            xo = obj.initialPoint; %Initial Surfaces for the elements
            A = obj.linearConstMatA ;
            b= obj.linearConstVecb ;
            beq= obj.linearConstVecbeq ;
            Aeq= obj.linearConstMatAeq ;
            
            [Surface,Weight,exitflag,output,lambda,grad,hessian]= ...
                fmincon(@objectiveFunction,xo,A,b,Aeq,beq,lb,ub,@const,options1);
            
        end
        
    end
    methods
        function Weight = objectiveFunction(surfaces, obj)
            
            
        end
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.initialPoint = 6*(1e-04)*ones(1,122);
                options.linearConstMatA = [];
                options.linearConstVecb  = [];
                options.linearConstMatAeq = [] ;
                options.linearConstVecbeq  = [];
                options.lowerBound  = 1*(7*1e-3)*ones(122,1);
                options.upperBound  = (6.6*1e-6)*ones(122,1);
                options.nonLinearConst  = [];
                options.optimizationMethod  = 'interior-point';
                options.structure dataobject.library.preprocessor = ...
                    dataobject.library.preprocessor.define();
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
                options.optimizationMethod, ...
                optios.structure);
        end
    end
    
end

