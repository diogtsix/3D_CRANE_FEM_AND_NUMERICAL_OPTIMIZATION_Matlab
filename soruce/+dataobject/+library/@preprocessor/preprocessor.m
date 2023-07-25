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
            nodeMatrix = dataobject.library.node.empty(obj.number_of_nodes, 0);
            %% Set Node iD
            for i = 1:obj.number_of_nodes
                
                nodeMatrix(i) = dataobject.library.node.define("id_global", i);
                
            end
            %% Initialize steady value properties
            L = obj.element_properties.rod_length;
            phi = obj.element_properties.crane_angle;
            
            %% Node Cordinates
            %% Crane Base
            nodeMatrix(1).cordinates = [0 -L/2 0];
            nodeMatrix(2).cordinates = [0 L/2 0];
            %% Crane Body
            Level = 0;
            for i = 1:(obj.number_of_nodes-8)/4 % i planes for the crane body
                rotating_vector = [1 2 3 4];
                nodeMatrix(rotating_vector(1)+2+Level).cordinates(1) = L/2;
                nodeMatrix(rotating_vector(2)+2+Level).cordinates(1) = L/2;
                
                nodeMatrix(rotating_vector(3)+2+Level).cordinates(1) = -L/2;
                nodeMatrix(rotating_vector(4)+2+Level).cordinates(1) = -L/2;
                
                nodeMatrix(2+2+Level).cordinates(2) = L/2;
                nodeMatrix(3+2+Level).cordinates(2) = L/2;
                
                nodeMatrix(1+2+Level).cordinates(2) = -L/2;
                nodeMatrix(4+2+Level).cordinates(2) = -L/2;
                
                nodeMatrix(rotating_vector(1)+2+Level).cordinates(3) = L*i;
                nodeMatrix(rotating_vector(2)+2+Level).cordinates(3) = L*i;
                nodeMatrix(rotating_vector(3)+2+Level).cordinates(3) = L*i;
                nodeMatrix(rotating_vector(4)+2+Level).cordinates(3) = L*i;

                Level = Level+4;
            end
            
            val = nodeMatrix;
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
                options.type_of_elements, ...
                options.element_properties);
        end
    end
    
end

