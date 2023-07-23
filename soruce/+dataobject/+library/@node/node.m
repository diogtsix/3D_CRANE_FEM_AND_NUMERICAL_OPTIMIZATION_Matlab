classdef node
    %NODE Class for each node
    
    properties
        id_local
        id_global
        x_position
        y_position
        z_position
    end
    
    methods
        %Constructor
        function obj = node(id_local,id_global, x_position, ...
                y_position,z_position)
            
            obj.id_local = id_local ;
            obj.id_global = id_global ;
            obj.x_position = x_position ;
            obj.y_position = y_position ;
            obj.z_position = z_position ;
        end
    end
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.id_local (1,1){mustBeReal} = 0;
                options.id_global (1,1){mustBeReal} = 0;
                options.x_position (1,1) {mustBeReal} = 0.5;
                options.y_position (1,1) {mustBeReal} = 0.5;
                options.z_position (1,1) {mustBeReal} = 0.5;
                
            end
            obj = feval(mfilename('class'),...
                options.id_local, ...
                options.id_global, ...
                options.x_position, ...
                options.y_position, ...
                options.z_position);
        end
        
    end
end
