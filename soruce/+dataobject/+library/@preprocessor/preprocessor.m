classdef preprocessor
    %PREPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number_of_nodes
        nodes
        elements
    end
    
    methods
        function obj = preprocessor(inputArg1,inputArg2)
            %PREPROCESSOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

