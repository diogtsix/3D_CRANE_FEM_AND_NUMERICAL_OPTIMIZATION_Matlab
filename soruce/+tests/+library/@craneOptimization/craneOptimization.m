classdef craneOptimization < matlab.unittest.TestCase
    %CRANEOPTIMIZATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (TestParameter)
        nodeNum = {32};
        scaleFactor = {150};
        method = {'interior-point'};
        forceVal = {-20e3}; 
        
        % if want also to visualize results
        visualizeOption = {"visualizeAll"};
    end
    
    methods (Test, ParameterCombination = 'sequential')
        function testWithDifferentNodeNumbers(testCase, nodeNum, ...
                scaleFactor, visualizeOption, ...
                method, forceVal)
            % Call the external baseline test function for each node number
            testCase.baseline(nodeNum, scaleFactor, visualizeOption, ...
                method, forceVal);
            
        end
    end
    
end

