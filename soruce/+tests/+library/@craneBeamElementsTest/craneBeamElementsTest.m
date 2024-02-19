classdef craneBeamElementsTest < matlab.unittest.TestCase
    %CRANETRUSSELEMENTSTest is a unit test to run the crane model
    %consisting only truss elements
    
    properties (TestParameter)
        nodeNum = {32};
        scaleFactor = {5};
        
        %Available options are : undeformedDeformed, axisDisplacements
        % strains, stresses, visualizeAll
        visualizeOption = {"visualizeAll"};  
    end
    

    methods (Test, ParameterCombination = 'sequential')
        function testWithDifferentNodeNumbers(testCase, nodeNum, ...
                scaleFactor, visualizeOption)
            % Call the external baseline test function for each node number
            testCase.baseline(nodeNum, scaleFactor, visualizeOption);
            
        end
    end
    
    
end