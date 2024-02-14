classdef element_properties < generic
    %TRUSSELEMENT CLass
    
    properties
        Young_modulus_E
        diagonal_rods_surface
        non_diagonal_rods_surface
        rod_length
        crane_angle
        rope_rigid_point_z_pos
        rope_rigid_point_x_pos
        
    end
    
    methods
        function obj = element_properties(Young_modulus_E,diagonal_rods_surface, ...
                non_diagonal_rods_surface,rod_length,crane_angle, rope_rigid_point_z_pos, ...
                rope_rigid_point_x_pos )
            %Constructor
            obj.Young_modulus_E = Young_modulus_E;
            obj.diagonal_rods_surface = diagonal_rods_surface;
            obj.non_diagonal_rods_surface = non_diagonal_rods_surface;
            obj.rod_length = rod_length;
            obj.crane_angle = crane_angle;
            obj.rope_rigid_point_z_pos = rope_rigid_point_z_pos;
            obj.rope_rigid_point_x_pos = rope_rigid_point_x_pos;
            
        end
    end
    
    methods (Static)
        %Define attributes
        function obj = define(options)
            arguments
                options.Young_modulus_E_in_N_mm2 (1,1){mustBePositive} = 210000; %N/(mm^2)
                options.diagonal_rods_surface_in_mm2  (1,1){mustBePositive} = 333.0000;
                options.non_diagonal_rods_surface_in_mm2 (1,1){mustBePositive} =  999.0000;
                options.rod_length_in_mm (1,1){mustBePositive} = 2415 ;
                options.crane_angle_in_rad (1,1) {mustBeReal} = 1.0926
                options.rope_rigid_point_z_pos_in_mm (1,1){mustBePositive} = 1210 ;
                options.rope_rigid_point_x_pos_in_mm (1,1){mustBePositive} = 1944 ;
                
                
            end
            obj = feval(mfilename('class'),...
                options.Young_modulus_E_in_N_mm2, ...
                options.diagonal_rods_surface_in_mm2, ...
                options.non_diagonal_rods_surface_in_mm2, ...
                options.rod_length_in_mm, ...
                options.crane_angle_in_rad, ...
                options.rope_rigid_point_z_pos_in_mm, ...
                options.rope_rigid_point_x_pos_in_mm);
        end
    end
end

