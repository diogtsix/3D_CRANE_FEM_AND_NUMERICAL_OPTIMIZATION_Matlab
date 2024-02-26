function [c,ceq] = nonLinCon(obj, surfaces)


crane = dataobject.library.preprocessor.define();

crane.elements_matrix = arrayfun(@(element, surface) setSurface(element, surface), ...
    crane.elements_matrix, surfaces', ...
    'UniformOutput', true);


%Call solver to solve
solveCrane = dataobject.library.solver.define("preprocessor", crane);

c1 = abs(solveCrane.displacedNodeMatrix) - 0.5 * abs(obj.initialDisplacementMat) ; 

c2 = abs(solveCrane.stressMatrix) - 1 * abs(obj.initialStressMat) ; 

c3 = abs(solveCrane.strainMatrix)- 1 * abs(obj.initialStrainMat) ; 

% c=[c1 ;c2 ;c3];
c= c1; 
%Equality constraints 
ceq=[];


% Set Surfaces function

    function element = setSurface(element, surface)
        element.surface = surface;
    end
end

