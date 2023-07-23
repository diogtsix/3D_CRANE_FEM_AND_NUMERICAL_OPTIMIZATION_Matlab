classdef node
    %NODE Class for each node
    
    properties
        id_local
        id_global
        cordinates
        boundary_condition
        force
    end
    
    methods
        %Constructor
        function obj = node(id_local,id_global, cordinates, ...
                boundary_condition,force)
            
            obj.id_local = id_local ;
            obj.id_global = id_global ;
            obj.cordinates = cordinates ;
            obj.boundary_condition = boundary_condition ;
            obj.force = force ;
        end
    end
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.id_local (1,1){mustBeReal} = 0;
                options.id_global (1,1){mustBeReal} = 0;
                options.cordinates_in_mm (1,3) {mustBeReal} = [0 0 0];
                options.boundary_condition (1,1) {mustBeReal} = 0;
                options.force_in_N (1,1) {mustBeReal} = 0;
                
            end
            obj = feval(mfilename('class'),...
                options.id_local, ...
                options.id_global, ...
                options.cordinates_in_mm, ...
                options.boundary_condition, ...
                options.force_in_N);
        end
        
    end
end
