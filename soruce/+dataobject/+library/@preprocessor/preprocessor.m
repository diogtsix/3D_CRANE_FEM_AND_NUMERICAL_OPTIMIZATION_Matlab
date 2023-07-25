classdef preprocessor < generic
    %PREPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number_of_nodes
        node_matrix
        elements_matrix
        type_of_elements
    end
    properties
    %class property
    element_properties
    end
    
    
    methods
        function obj = preprocessor(number_of_nodes,node_matrix,elements_matrix, type_of_elements, ...
                element_properties)
            %PREPROCESSOR Constructor
            obj.number_of_nodes = number_of_nodes;
            obj.node_matrix = node_matrix ;
            obj.elements_matrix = elements_matrix ;
            obj.type_of_elements = type_of_elements;
            
            obj.element_properties = element_properties;
        end
    end
    
    methods
        function obj = create_crane(obj)
            
            obj.node_matrix = obj.create_node_matrix();
            
            %             obj.create_element_matrix();
            %             obj.create_crane_base();
            %             obj.create_crane_head();
        end
    end
    methods
        function val = create_node_matrix(obj)
            % Getter method to access the 'nodes_matrix' property
            
            
            
            
            val = obj.number_of_nodes;
        end
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.number_of_nodes (1,1) {mustBePositive} = 32 ;
                options.node_matrix = [];
                options.elements_matrix = [] ;
                options.type_of_elements string  = "truss_only"
                options.element_properties dataobject.library.element_properties = ...
                    dataobject.library.element_properties.define();
            end
            obj = feval(mfilename('class'),...
                options.number_of_nodes, ...
                options.node_matrix, ...
                options.elements_matrix, ...
                options.type_of_elements);
        end
    end
    
end

