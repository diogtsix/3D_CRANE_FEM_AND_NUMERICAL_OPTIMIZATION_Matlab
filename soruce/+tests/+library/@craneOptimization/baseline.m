function baseline(testCase, nodeNum, scaleFactor, visualizeOption, ...
    method, forceVal)

close all
clc

%% Creaete the Crane
%For better understanding we create all the objects but in fact it is not
%necessary
elementProperties = dataobject.library.element_properties.define();
crane = dataobject.library.preprocessor.define("element_properties", elementProperties, ...
    "number_of_nodes", nodeNum, "type_of_elements", "truss");

%% Add Force

crane.node_matrix(crane.number_of_nodes-3).force(3) = forceVal;

%% Solve the Crane Static Problem
craneSolver = dataobject.library.solver.define("preprocessor", crane);

optimizedCrane = dataobject.library.optimization.define(...
    "structure", crane,  ...
    "staticSolution", craneSolver, ...
    "optimizationMethod", method);

% Ask User
choice = questdlg('What to Optimize ?', ...
    'Method', ...
    'Surface Only', 'Surface And Material', 'Surface And Material');

switch choice
    case 'Surface Only'
        optimizedCrane.optimizeSurfaceOnly();
    case 'Surface And Material'
        optimizedCrane.optimizeSurfaceAndMaterial();
end

optCrane = optimizedCrane.structure;
% Ask User
choice = questdlg('Want to visualize Optimized Crane ?', ...
    'Method', ...
    'Yes', 'No',  'No');

switch choice
    case 'Yes'
        solveOptCrane = dataobject.library.solver.define("preprocessor", optCrane);
        
        %% PostProcessor
        optCraneResults = dataobject.library.postProcessor.define(...
            "solver", solveOptCrane, ...
            "scaleFactor", scaleFactor) ;
        
        optCraneResults.(visualizeOption); 
    case 'No'
end


end


