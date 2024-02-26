function Weight = objectiveFunction(surfaces)

crane = dataobject.library.preprocessor.define();



crane.elements_matrix = arrayfun(@(element, surface) setSurface(element, surface), ...
    crane.elements_matrix, surfaces', ...
    'UniformOutput', true);

%Call solver to solve
solveCrane = dataobject.library.solver.define("preprocessor", crane);

%Calculate new weight
Weight = solveCrane.preprocessor.craneWeight;

% Set Surfaces function

    function element = setSurface(element, surface)
        element.surface = surface;
    end

end

