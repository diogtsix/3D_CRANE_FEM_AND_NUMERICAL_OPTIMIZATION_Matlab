function K = stiffnessMatrix(obj)
%STIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here

nodeMatrix = obj.preprocessor.node_matrix;
elementMatrix = obj.preprocessor.elements_matrix;
elementNum = obj.preprocessor.number_of_elements;
nodesNum = obj.preprocessor.number_of_nodes;
dofs = length(nodeMatrix(1).cordinates);
K = zeros(nodesNum * dofs); 

for ii  = 1: elementNum
    
    firstNode = elementMatrix(ii).nodes(1);
    secondNode = elementMatrix(ii).nodes(2);
    Le = elementMatrix(ii).length;
    E = elementMatrix(ii).elastic_module;
    A = elementMatrix(ii).surface;
    
    
    % Create FEA Trasnform for truss elements
        directionCosines = (firstNode.cordinates - secondNode.cordinates) / Le;
    
    T=[directionCosines 0 0 0;
        0 0 0 directionCosines];
    
    
    % Truss Element Stiiffness matrix
    ke = (A*E/Le)*[1 -1;-1 1];
    
    % Transform ke to global coordinates ke=6x6 matrix
    ke = T'*ke*T;
    
    w = dofs * (firstNode.id_global - 1) + 1;
    h = dofs * (secondNode.id_global - 1) + 1;
    b = dofs;
    
    K(w:w+(b-1),w:w+(b-1))= K(w:w+(b-1),w:w+(b-1))+ke(1:b,1:b);
    K(w:w+(b-1),h:h+(b-1))= K(w:w+(b-1),h:h+(b-1))+ke(1:b,b+1:2*b);
    K(h:h+(b-1),w:w+(b-1))= K(h:h+(b-1),w:w+(b-1))+ke(b+1:2*b,1:b);
    K(h:h+(b-1),h:h+(b-1))= K(h:h+(b-1),h:h+(b-1))+ke(b+1:2*b,b+1:2*b);
end

end

