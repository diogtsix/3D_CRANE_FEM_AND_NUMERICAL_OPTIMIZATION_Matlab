classdef element < generic
    %TRUSSELEMENT CLass
    
    properties
        element_id
        nodes
        surface
        elastic_module
        element_type % Type = Beam or Rod or Rope(ropes are modelled as elements)
        materialDensity
        
    end
    
    properties (Dependent)
        length          % Length of the element, dynamically calculated
        deformedLength  % deformedLength of the Deformed element, dynamically calculated
        elementWeight
    end
    
    methods
        function obj = element(element_id,nodes, ...
                surface,elastic_module,element_type, materialDensity)
            %Constructor
            obj.element_id = element_id;
            obj.nodes = nodes;
            obj.surface = surface;
            obj.elastic_module = elastic_module;
            obj.element_type = element_type;
            obj.materialDensity = materialDensity;
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
        
        function deformedLength = get.deformedLength(obj)
            % Getter method for length property
            if size(obj.nodes,2) == 2 && ~isempty(obj.nodes(1).displacedCoord) && ~isempty(obj.nodes(2).displacedCoord)
                node1Coords = obj.nodes(1).displacedCoord;
                node2Coords = obj.nodes(2).displacedCoord;
                deformedLength = norm(node1Coords - node2Coords);
            else
                deformedLength = NaN; % Return NaN if the nodes are not properly defined
            end
        end
        
        function elementWeight = get.elementWeight(obj)
            
             elementWeight = obj.materialDensity* obj.surface * obj.length*(1e-3)*(1e-6); 
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
                options.materialDensity_in_kg_m3 (1,1) {mustBeReal} = 8960;
                
            end
            obj = feval(mfilename('class'),...
                options.element_id, ...
                options.nodes, ...
                options.surface_in_mm2, ...
                options.elastic_module_in_N_mm2, ...
                options.element_type, ...
                options.materialDensity_in_kg_m3);
        end
        
    end
end
