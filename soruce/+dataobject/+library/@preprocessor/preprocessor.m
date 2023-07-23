classdef preprocessor
    %PREPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number_of_nodes
        nodes
        elements
    end
    
    methods
        function obj = preprocessor(number_of_nodes,nodes,elements)
            %PREPROCESSOR Construct an instance of this class
            %   Detailed explanation goes here
            obj.number_of_nodes = number_of_nodes;
                        obj.nodes = nodes;

                                    obj.elements = elements;

        end
    end
    
        methods (Static)
        function obj = define(options)
            arguments
                options.number_of_nodes (1,1){mustBeReal} = 0;
                options.nodes  dataobject.library.node = [dataobject.library.node.define() dataobject.library.node.define()];
                options.elements (1,1) {mustBeReal} = 1000 ;               
            end
            obj = feval(mfilename('class'),...
                options.number_of_nodes, ...
                options.nodes, ...
                options.elements);
        end
    end
end

