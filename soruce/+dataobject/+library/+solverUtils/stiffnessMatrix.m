function K = stiffnessMatrix(obj)
%STIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here

nodeMatrix = obj.preprocessor.node_matrix;
elementMatrix = obj.preprocessor.elements_matrix;
elementNum = obj.preprocessor.number_of_elements;
nodesNum = obj.preprocessor.number_of_nodes;
dofs = length(nodeMatrix(1).cordinates);
K = zeros(nodesNum * dofs);
v = obj.preprocessor.element_properties.poissonRatio;
for ii  = 1: elementNum
    
    Le = elementMatrix(ii).length;
    E = elementMatrix(ii).elastic_module;
    A = elementMatrix(ii).surface;
    
    if obj.preprocessor.elements_matrix(ii).element_type == "truss"
        
        firstNode = elementMatrix(ii).nodes(1);
        secondNode = elementMatrix(ii).nodes(2);
        
        
        if obj.preprocessor.type_of_elements == "truss"
            % Create FEA Trasnform for truss elements
            directionCosines = (firstNode.cordinates - secondNode.cordinates) / Le;
            
            T=[directionCosines 0 0 0;
                0 0 0 directionCosines];
            
            
            
            %if we have only truss crane
            % Truss Element Stiiffness matrix
            ke = (A*E/Le)*[1 -1;-1 1];
            
            % Transform ke to global coordinates ke=6x6 matrix
            ke = T'*ke*T;
            
        elseif obj.preprocessor.type_of_elements == "frame"
            % if we have both truss and beams
            directionCosines = (secondNode.cordinates - firstNode.cordinates) / Le;
            lx = directionCosines(1);
            mx = directionCosines(2);
            nx = directionCosines(3);
            
            ke=(E*A/Le)*[lx^2 lx*mx lx*nx 0 0 0 -lx^2 -lx*mx -lx*nx 0 0 0 ;
                lx*mx mx^2 mx*nx 0 0 0 -lx*mx -mx^2 -mx*nx 0 0 0 ;
                lx*nx mx*nx nx^2 0 0 0 -lx*nx -mx*nx -nx^2 0 0 0 ;
                0 0 0 1 0 0 0 0 0 0 0 0;
                0 0 0 0 1 0 0 0 0 0 0 0;
                0 0 0 0 0 1 0 0 0 0 0 0;
                -lx^2 -lx*mx -lx*nx 0 0 0 lx^2 lx*mx lx*nx 0 0 0;
                -lx*mx -mx^2 -mx*nx 0 0 0 lx*mx mx^2 mx*nx 0 0 0;
                -lx*nx -mx*nx -nx^2 0 0 0 lx*nx mx*nx nx^2 0 0 0;
                0 0 0 0 0 0 0 0 0 1 0 0;
                0 0 0 0 0 0 0 0 0 0 1 0;
                0 0 0 0 0 0 0 0 0 0 0 1];
            
        end
        
    elseif obj.preprocessor.elements_matrix(ii).element_type == "beam"
        
        firstNode = elementMatrix(ii).nodes(1);
        secondNode = elementMatrix(ii).nodes(2);
        thirdNode = obj.preprocessor.freeNode;
        
        X1 = firstNode.cordinates(1);
        Y1 =  firstNode.cordinates(2);
        Z1 =  firstNode.cordinates(3);
        X2 = secondNode.cordinates(1);
        Y2 =  secondNode.cordinates(2);
        Z2 =  secondNode.cordinates(3);
        X3 = thirdNode.cordinates(1);
        Y3 =  thirdNode.cordinates(2);
        Z3 =  thirdNode.cordinates(3);
        
        Y21=Y2-Y1;
        Z31=Z3-Z1;
        Y31=Y3-Y1;
        Z21=Z2-Z1;
        X31=X3-X1;
        X21=X2-X1;
        
        
        A123=sqrt((Y21*Z31-Y31*Z21)^2+(Z21*X31-Z31*X21)^2+(X21*Y31-X31*Y21)^2);
        
        
        lx=(X2-X1)/Le;
        mx=(Y2-Y1)/Le;
        nx=(Z2-Z1)/Le;
        
        lz=(Y21*Z31-Y31*Z21)/A123;
        mz=(Z21*X31-Z31*X21)/A123;
        nz=(X21*Y31-X31*Y21)/A123;
        
        ly=mz*nx-nz*mx;
        my=nz*lx-lz*nx;
        ny=lz*mx-mz*lx;
        
        
        T=[lx mx nx; ly my ny; lz mz nz];
        
        T=blkdiag(T,T,T,T);
        
        Iy=(pi*(sqrt(A/pi))^4)/4;
        Iz=Iy;
        J=2*Iy;
        G=E/(2*(1+v));
        
        %constants
        V1=(A*E)/(2*Le);
        V2=(3*E*Iz)/(2*Le^3);
        V3=(3*E*Iz)/(2*Le^2);
        V4=(3*E*Iy)/(2*Le^3);
        V5=(3*E*Iy)/(2*Le^2);
        V6=(G*J)/(2*Le);
        V7=(E*Iy)/Le;
        V8=(E*Iz)/Le;
        
        %stiffnes matrix for one element
        ke=[V1 0 0 0 0 0 -V1 0 0 0 0 0;
            0 V2 0 0 0 V3 0 -V2 0 0 0 V3;
            0 0 V4 0 -V5 0 0 0 -V4 0 -V5 0;
            0 0 0 V6 0 0 0 0 0 -V6 0 0;
            0 0 -V5 0 2*V7 0 0 0 V5 0 V7 0;
            0 V3 0 0 0 2*V8 0 -V3 0 0 0 V8;
            -V1 0 0 0 0 0 V1 0 0 0 0 0;
            0 -V2 0 0 0 -V3 0 V2 0 0 0 -V3;
            0 0 -V4 0 V5 0 0 0 V4 0 V5 0;
            0 0 0 -V6 0 0 0 0 0 V6 0 0;
            0 0 -V5 0 V7 0 0 0 V5 0 2*V7 0;
            0 V3 0 0 0 V8 0 -V3 0 0 0 2*V8];
        
        ke=T'*ke*T;
        
        
    end
    
    w = dofs * (firstNode.id_global - 1) + 1;
    h = dofs * (secondNode.id_global - 1) + 1;
    b = dofs;
    
    K(w:w+(b-1),w:w+(b-1))= K(w:w+(b-1),w:w+(b-1))+ke(1:b,1:b);
    K(w:w+(b-1),h:h+(b-1))= K(w:w+(b-1),h:h+(b-1))+ke(1:b,b+1:2*b);
    K(h:h+(b-1),w:w+(b-1))= K(h:h+(b-1),w:w+(b-1))+ke(b+1:2*b,1:b);
    K(h:h+(b-1),h:h+(b-1))= K(h:h+(b-1),h:h+(b-1))+ke(b+1:2*b,b+1:2*b);
    
end
end

