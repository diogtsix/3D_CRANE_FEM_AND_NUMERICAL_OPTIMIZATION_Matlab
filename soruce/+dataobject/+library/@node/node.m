classdef node
    %NODE Class for each node
    
    properties
        id
        x_position
        y_position
        z_position
    end
    
    methods
        %Constructor
        function obj = node(id, x_position, ...
                y_position,z_position)
            
            obj.id = id ;
            obj.x_position = x_position ;
            obj.y_position = y_position ;
            obj.z_position = z_position ;
        end
    end
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.id (1,1){mustBeReal} = 0;
                options.x_position (1,1) {mustBeReal} = 0.5;
                options.y_position (1,1) {mustBeReal} = 0.5;
                options.z_position (1,1) {mustBeReal} = 0.5;
                
            end
            obj = feval(...
                options.id, ...
                options.x_position, ...
                options.y_position, ...
                options.z_position);
        end
        
    end
end
