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
    
    %% Element Surface Optimization by minimizing crane weight
    
    methods
        function [OptimizedValues,Weight,exitflag,output,lambda,grad,hessian] = ...
                optimizeSurfaceOnly(obj)
            
            %Initial Surfaces for the elements
            xo = arrayfun(@(x) x.surface, obj.structure.elements_matrix);
            xo = xo' ;
            
            % Set bound  based on the crane size
            obj.lowerBound = 300*ones(obj.structure.number_of_elements, 1) ;
            obj.upperBound = 1000*ones(obj.structure.number_of_elements, 1) ;
            
            lb = obj.lowerBound ; % lowerBound
            ub = obj.upperBound ; % UpperBound
            
            A = obj.linearConstMatA ;
            b= obj.linearConstVecb ;
            beq= obj.linearConstVecbeq ;
            Aeq= obj.linearConstMatAeq ;
            option = optimoptions('fmincon','Algorithm', ...
                obj.optimizationMethod ,'Display','iter', ...
                'FinDiffType','central', ...
                'MaxFunctionEvaluations',13000);
            
            % Adapt the objective function to the form expected by fmincon
            objFun = @(x0) obj.objectiveFunction(x0);
            
            % Adapt the objective function to the form expected by fmincon
            nonLinCon = @(x0) obj.nonLinCon(x0);
            
            [OptimizedValues,Weight,exitflag,output,lambda,grad,hessian]= ...
                fmincon(objFun,xo,A,b,Aeq,beq,lb,ub,nonLinCon,option);
            
            obj.replaceOptimizedValues(OptimizedValues)
        end
        
        %% Surface and Material optimization  by minimizing crane weight
        function [Surface,Weight,exitflag,output,lambda,grad,hessian] = ...
                optimizeSurfaceAndMaterial(obj)
            % Input Material Catalog
            materialCatalog = dataobject.library.optimizationUtils.materilaCatalog() ;
            
            [xo, lb, ub] = dataobject.library.optimizationUtils.surfaceAndMaterialInputs(obj, materialCatalog);
            
            A = obj.linearConstMatA ;
            b= obj.linearConstVecb ;
            beq= obj.linearConstVecbeq ;
            Aeq= obj.linearConstMatAeq ;
            option = optimoptions('fmincon','Algorithm', ...
                obj.optimizationMethod ,'Display','iter', ...
                'FinDiffType','central', ...
                'MaxFunctionEvaluations',13000);
            
            
            % Adapt the objective function to the form expected by fmincon
            objFun = @(surfaces) obj.objectiveFunction(surfaces);
            
            % Adapt the objective function to the form expected by fmincon
            nonLinCon = @(surfaces) obj.nonLinCon(surfaces);
            
            [Surface,Weight,exitflag,output,lambda,grad,hessian]= ...
                fmincon(objFun,xo,A,b,Aeq,beq,lb,ub,nonLinCon,option);
            
            obj.replaceOptimizedValues(Surface)
        end
    end
    %% Method for Surface Optimization Only
    methods
        function Weight = objectiveFunction( obj, x0)
            
            if length(x0) == obj.structure.number_of_elements
                Weight = dataobject.library.optimizationUtils.objectiveFunction(x0);
            elseif length(x0) > obj.structure.number_of_elements
                Weight = dataobject.library.optimizationUtils.objectiveFunction2(x0, obj);  
            end
            
        end
        function [c,ceq] = nonLinCon(obj, x0)
            
            [c,ceq] = dataobject.library.optimizationUtils.nonLinCon(obj, x0);
        end
    end
    
    %% Reokace Optimized Values
    methods
        function obj = replaceOptimizedValues(obj, surfaces)
            % Ask User
            choice = questdlg('Do you want to replace the optimized surface values into the preprocessor object?', ...
                'Replace Surfaces', ...
                'Yes', 'No', 'No');
            
            % Handle response
            switch choice
                case 'Yes'
                    
                    obj.structure.elements_matrix = arrayfun(@(element, surface) setSurface(element, surface), ...
                        obj.structure.elements_matrix, surfaces', ...
                        'UniformOutput', true);
                    
                    
                case 'No'
                    disp('No changes made to the preprocessor object.');
            end
            
            % Nested function to replace Surfaces
            function element = setSurface(element, surface)
                element.surface = surface;
            end
            
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

