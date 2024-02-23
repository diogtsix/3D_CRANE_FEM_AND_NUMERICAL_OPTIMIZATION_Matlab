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
        staticSolution % Solution of static crane
        
        initialDisplacementMat
        initialStressMat
        initialStrainMat
    end
    
    methods
        function obj = optimization(initialPoint,linearConstMatA, ...
                linearConstVecb, linearConstMatAeq, linearConstVecbeq, ...
                lowerBound, upperBound, nonLinearConst, ...
                optimizationMethod, structure, staticSolution)
            
            obj.initialPoint = initialPoint ;
            obj.linearConstMatA = linearConstMatA ;
            obj.linearConstVecb = linearConstVecb ;
            obj.linearConstMatAeq = linearConstMatAeq ;
            obj.linearConstVecbeq = linearConstVecbeq ;
            obj.lowerBound = lowerBound ;
            obj.upperBound = upperBound ;
            obj.nonLinearConst = nonLinearConst ;
            obj.optimizationMethod = optimizationMethod ;
            obj.structure = structure;
            obj.staticSolution = staticSolution;
            
            % Initial structural values to insert in the nonLinCOnst
            obj.initialDisplacementMat = obj.staticSolution.displacedNodeMatrix ;
            obj.initialStressMat = obj.staticSolution.stressMatrix;
            obj.initialStrainMat = obj.staticSolution.strainMatrix;
        end
    end
    
    methods
        function [Surface,Weight,exitflag,output,lambda,grad,hessian] = ...
                optimizeSurfaceOnly(obj)
            
            %Initial Surfaces for the elements
            xo = arrayfun(@(x) x.surface, obj.structure.elements_matrix);
            xo = xo' ;
            
            lb = obj.lowerBound ; % lowerBound
            ub = obj.upperBound ; % UpperBound
            
            A = obj.linearConstMatA ;
            b= obj.linearConstVecb ;
            beq= obj.linearConstVecbeq ;
            Aeq= obj.linearConstMatAeq ;
            option = optimoptions('fmincon','Algorithm', ...
                obj.optimizationMethod ,'Display','iter');
            
            % Adapt the objective function to the form expected by fmincon
            objFun = @(surfaces) obj.objectiveFunction(surfaces);
            
            % Adapt the objective function to the form expected by fmincon
            nonLinCon = @(surfaces) obj.nonLinCon(surfaces);
            
            [Surface,Weight,exitflag,output,lambda,grad,hessian]= ...
                fmincon(objFun,xo,A,b,Aeq,beq,lb,ub,nonLinCon,option);
            
        end
        
        
        function [Surface,Weight,exitflag,output,lambda,grad,hessian] = ...
                optimizeSurfaceAndMaterial(obj)
            
        end
    end
    methods
        function Weight = objectiveFunction( obj, surfaces)
            
            
            Weight = dataobject.library.optimizationUtils.objectiveFunction(surfaces);
        end
        
        function [c,ceq] = nonLinCon(obj, surfaces)
            
            
            [c,ceq] = dataobject.library.optimizationUtils.nonLinCon(obj, surfaces);
        end
        
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.initialPoint = 600*ones(1,122);
                options.linearConstMatA = [];
                options.linearConstVecb  = [];
                options.linearConstMatAeq = [] ;
                options.linearConstVecbeq  = [];
                options.lowerBound  = 300*ones(122,1);
                options.upperBound  = 1000*ones(122,1);
                options.nonLinearConst  = [];
                options.optimizationMethod  = 'interior-point';
                options.structure dataobject.library.preprocessor = ...
                    dataobject.library.preprocessor.define();
                options.staticSolution dataobject.library.solver = ...
                    dataobject.library.solver.define("preprocessor", ...
                    dataobject.library.preprocessor.define());
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
                options.structure, ...
                options.staticSolution);
        end
    end
    
end

