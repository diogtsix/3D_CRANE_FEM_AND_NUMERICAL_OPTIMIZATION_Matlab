classdef preprocessor < generic
    %PREPROCESSOR Class for preprocessing a 3D Crane model in FEM Analysis
    % This class handles input data, crane geometry generation, and preparation for analysis.
    
    properties
        number_of_nodes
        node_matrix
        number_of_elements
        elements_matrix
        type_of_elements
        surfaceForEqualWeight
        freeNode
    end
    properties
        %class property
        element_properties
    end
    
    
    methods
        function obj = preprocessor(number_of_nodes,node_matrix, number_of_elements, ...
                elements_matrix, type_of_elements, ...
                surfaceForEqualWeight, freeNode , element_properties)
            %PREPROCESSOR Constructor
            obj.number_of_nodes = number_of_nodes;
            obj.node_matrix =  node_matrix ;
            obj.number_of_elements = number_of_elements;
            obj.elements_matrix = elements_matrix ;
            obj.type_of_elements = type_of_elements;
            obj.surfaceForEqualWeight = surfaceForEqualWeight;
            obj.freeNode = freeNode; 
            
            obj.element_properties = element_properties;
            
            obj.node_matrix = obj.createNodeMatrix();
            obj.elements_matrix = obj.createElementMatrix();
        end
        
    end
    %% Matrices consruction Methods 
    methods 
        function nodeMatrix = createNodeMatrix(obj)
            nodeMatrix = dataobject.library.preprocessorUtils.createNodeMatrix(obj);
        end
        
        function elemenMatrix = createElementMatrix(obj)
            
            elemenMatrix = dataobject.library.preprocessorUtils.createElementMatrix(obj);
        end
        
    end
    %% Visualize the crane after Matrix Construction 
    methods
        function visualizeCrane(obj, coord) % coord = "cordinates" or "displacedCoord"
            dataobject.library.preprocessorUtils.visualizeCrane(obj , coord )
        end
    end
    %% Add Force to the crane 
    methods 
        function obj = inputForce(obj)
            % Check if crane is open
            fig = findobj('Type', 'Figure');
            
            if isempty(fig)
                obj.visualizeCrane("cordinates")
            end
            % Force function
            dataobject.library.preprocessorUtils.inputForce(obj)
        end
    end
    
    methods (Static)
        function obj = define(options)
            arguments
                options.number_of_nodes (1,1) {mustBePositive} = 32;
                options.node_matrix = [];
                options.number_of_elements (1,1) {mustBeReal} = 122;
                options.elements_matrix = [] ;
                options.type_of_elements string  = "truss"
                options.surfaceForEqualWeight {mustBeReal}= 0
                options.freeNode dataobject.library.node = ...
                    dataobject.library.node.define();
                options.element_properties dataobject.library.element_properties = ...
                    dataobject.library.element_properties.define();
            end
            obj = feval(mfilename('class'),...
                options.number_of_nodes, ...
                options.node_matrix, ...
                options.number_of_elements, ...
                options.elements_matrix, ...
                options.type_of_elements, ...
                options.surfaceForEqualWeight, ...
                options.freeNode, ...
                options.element_properties);
        end
    end
    
end

