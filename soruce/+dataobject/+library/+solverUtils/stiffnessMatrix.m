function K = stiffnessMatrix(obj)
%STIFFNESSMATRIX Summary of this function goes here
%   Detailed explanation goes here

nodeMatrix = obj.preprocessor.node_matrix;
elementMatrix = obj.preprocessor.elements_matrix;
elementNum = obj.preprocessor.number_of_elements;

for ii  = 1: elementNum
    
firstElement = 
% Truss Element Stiiffness matrix
ke = (A*E/Le)*[1 -1;-1 1];


end

end

