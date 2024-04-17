function baseline(testCase, nodeNum, scaleFactor, visualizeOption)
%BASELINE In the baseline we solve the problem
close all
clc

%% Creaete the Crane 
%For better understanding we create all the objects but in fact it is not
%necessary
elementProperties = dataobject.library.element_properties.define();
crane = dataobject.library.preprocessor.define("element_properties", elementProperties, ...
    "number_of_nodes", nodeNum, "type_of_elements", "frame"); 
%% Add Force
crane.inputForce();
%% Solve the Crane Static Problem
craneSolver = dataobject.library.solver.define("preprocessor", crane); 
%% PostProcessor
craneResults = dataobject.library.postProcessor.define(...
    "solver", craneSolver, ...
    "scaleFactor", scaleFactor) ;

%% visualize specific result
% close all
craneResults.(visualizeOption); 

end

