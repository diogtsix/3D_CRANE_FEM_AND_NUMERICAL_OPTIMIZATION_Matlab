classdef preprocessor < generic
    %PREPROCESSOR Class for preprocessing a 3D Crane model in FEM Analysis
    % This class handles input data, crane geometry generation, and preparation for analysis.
    
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
            obj.node_matrix =  node_matrix ;
            obj.elements_matrix = elements_matrix ;
            obj.type_of_elements = type_of_elements;
            
            obj.element_properties = element_properties;
            
            obj.node_matrix = obj.createNodeMatrix();
            obj.elements_matrix = obj.createElementMatrix();
        end
        
    end
    methods
        function nodeMatrix = createNodeMatrix(obj)
            nodeMatrix = dataobject.library.utilities.createNodeMatrix(obj);
%             nodeMatrix = 0;
        end
        
        function elemenMatrix = createElementMatrix(obj)
            elemenMatrix = dataobject.library.utilities.createElementMatrix(obj);
        end
        
    end
    
%     methods
%         
%         
%         function create_crane_base(obj)
%             % Method to generate the crane base
%             % Placeholder for implementation
%         end
%         
%         function create_crane_head(obj)
%             % Method to generate the crane head
%             % Placeholder for implementation
%         end
%     end
    methods (Static)
        function obj = define(options)
            arguments
                options.number_of_nodes (1,1) {mustBePositive} = 32 ;
                options.node_matrix = [];
                options.elements_matrix = [] ;
                options.type_of_elements string  = "truss only"
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

