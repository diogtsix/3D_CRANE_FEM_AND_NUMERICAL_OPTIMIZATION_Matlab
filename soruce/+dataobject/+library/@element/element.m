classdef element
    %TRUSSELEMENT CLass
    
    properties
        element_id
        nodes
        surface
        elastic_module
        element_type
        
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
    end
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.element_id (1,1){mustBeReal} = 0;
                options.nodes  dataobject.library.node = [dataobject.library.node.define() dataobject.library.node.define()];
                options.surface_in_mm2 (1,1) {mustBeReal} = 1000 ; %m^2
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
