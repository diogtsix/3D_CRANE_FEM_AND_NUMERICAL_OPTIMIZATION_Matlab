function Weight = objectiveFunction2(x0, obj)

fA0 = obj.normalizationFactors.surface();
fd = obj.normalizationFactors.density();
fe = obj.normalizationFactors.elasticity();
%% Extract Vectors
surfaces = x0(1:obj.structure.number_of_elements);
densitys = x0(obj.structure.number_of_elements + 1: 2 *obj.structure.number_of_elements);
elasticities = x0(1 + obj.structure.number_of_elements*2: 3 * obj.structure.number_of_elements);
%% Remove Normalization
surfaces = surfaces * fA0; 
densitys = densitys * fd; 
elasticities = elasticities * fe; 

%% Replace Surface
obj.structure.elements_matrix = arrayfun(@(element, surface) setSurface(element, surface), ...
    obj.structure.elements_matrix, surfaces', ...
    'UniformOutput', true);

% Replace Density
obj.structure.elements_matrix = arrayfun(@(element, materialDensity) setDensity(element, materialDensity), ...
    obj.structure.elements_matrix, densitys', ...
    'UniformOutput', true);

% Replace Elasticity
obj.structure.elements_matrix = arrayfun(@(element, elastic_module) setElasticity(element, elastic_module), ...
    obj.structure.elements_matrix, elasticities', ...
    'UniformOutput', true);

%Call solver to solve
solveCrane = dataobject.library.solver.define("preprocessor", obj.structure);

%Calculate new weight
Weight = solveCrane.preprocessor.craneWeight;

% Set Values into the object functions

    function element = setSurface(element, surface)
        element.surface = surface;
    end


    function element = setDensity(element, density)
        element.materialDensity = density;
    end

    function element = setElasticity(element, elasticity)
        element.elastic_module = elasticity;
    end
end

