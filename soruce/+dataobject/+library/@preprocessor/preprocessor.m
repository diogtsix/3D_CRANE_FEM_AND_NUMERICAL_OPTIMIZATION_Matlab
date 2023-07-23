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
            %PREPROCESSOR Constructor
            obj.number_of_nodes = number_of_nodes;
            obj.nodes = nodes ;
            obj.elements = elements ;
            
        end
    end
    
    methods
        function obj = create_crane(obj)
            
            obj.nodes = obj.create_node_matrix();
            
            %             obj.create_element_matrix();
            %             obj.create_crane_base();
            %             obj.create_crane_head();
        end
    end
    methods
        function nodeValue = create_node_matrix(obj)
            % Getter method to access the 'nodes' property
            nodeValue = 1;
        end
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.number_of_nodes (1,1) {mustBePositive} = 32 ;
                options.nodes = [];
                options.elements = [] ;
            end
            obj = feval(mfilename('class'),...
                options.number_of_nodes, ...
                options.nodes, ...
                options.elements);
        end
    end
    
end

