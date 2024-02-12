classdef element < generic
    %TRUSSELEMENT CLass
    
    properties
        element_id
        nodes
        surface
        elastic_module
        element_type % Type = Beam or Rod or Rope(ropes are modelled as elements)
        
    end
    
    properties (Dependent)
        length          % Length of the element, dynamically calculated
    end
    
    methods
        function obj = element(element_id,nodes, ...
                surface,elastic_module,element_type)
            %Constructor
            obj.element_id = element_id;
            obj.nodes = nodes;
            obj.surface = surface;
            obj.elastic_module = elastic_module;
            obj.element_type = element_type;
            
        end
        
        function length = get.length(obj)
            % Getter method for length property
            if size(obj.nodes,2) == 2 && ~isempty(obj.nodes(1).cordinates) && ~isempty(obj.nodes(2).cordinates)
                node1Coords = obj.nodes(1).cordinates;
                node2Coords = obj.nodes(2).cordinates;
                length = norm(node1Coords - node2Coords);
            else
                length = NaN; % Return NaN if the nodes are not properly defined
            end
        end
        
    end
    
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.element_id (1,1){mustBeReal} = 0;
                options.nodes  dataobject.library.node = [dataobject.library.node.define() dataobject.library.node.define()];
                options.surface_in_mm2 (1,1) {mustBeReal} = 1000 ;
                options.elastic_module_in_N_mm2 (1,1) {mustBeReal} = 210000; %N/(mm^2)
                options.element_type  = "Truss" ;
                
                
            end
            obj = feval(mfilename('class'),...
                options.element_id, ...
                options.nodes, ...
                options.surface_in_mm2, ...
                options.elastic_module_in_N_mm2, ...
                options.element_type);
        end
        
    end
end
