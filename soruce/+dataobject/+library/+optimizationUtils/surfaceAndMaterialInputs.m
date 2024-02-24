function [xo, lb, ub] = surfaceAndMaterialInputs(obj, materialCatalog)


%% Construct Initial Point for : Surface - Density - Elasticity
surface = arrayfun(@(x) x.surface, obj.structure.elements_matrix);
surface = surface' ;

% Extract density and elesticity values
densities = arrayfun(@(m) m.density_in_kg_m3, materialCatalog.material);
elasticities = arrayfun(@(m) m.YoungModulus_in_GPa, materialCatalog.material);

% Create a vector of random indices
randomIndicesDensity = randi(length(densities), obj.structure.number_of_elements, 1);
randomIndicesElasticity = randi(length(elasticities), obj.structure.number_of_elements, 1);

% Create the vector of random densities
density = densities(randomIndicesDensity);
elasticity = elasticities(randomIndicesElasticity);

%Normalize InitialPoint
surface0 = surface/ max(surface);
density0 = density/ max(density);
elasticity0 = elasticity/ max(elasticity);

xo = [surface0 density0 elasticity0];

%% Create Lower And Upper Bound

lb1=min(surface)*ones(obj.structure.number_of_elements,1)';
lb2=min(density)*ones(obj.structure.number_of_elements,1)';
lb3=min(elasticity)*ones(obj.structure.number_of_elements,1)';

ub1=max(surface)*ones(obj.structure.number_of_elements,1)';
ub2=max(density)*ones(obj.structure.number_of_elements,1)';
ub3=max(elasticity)*ones(obj.structure.number_of_elements,1)';

% Normalize Bounds with the same factors as initial Point

lb1=lb1/ max(surface);
ub1=ub1/ max(surface);
lb2=lb2/max(density);
ub2=ub2/max(density);
lb3=lb3/max(elasticity);
ub3=ub3/max(elasticity);

lb=[lb1 lb2 lb3];
ub=[ub1 ub2 ub3];
end

