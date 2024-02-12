function obj = inputForce(obj)
%INPUTFORCE Summary of this function goes here
%   Detailed explanation goes here


% Let the user insert force or use default force settings

choice = questdlg('Choose force setting:', 'Force Input', ...
    'Insert Force', 'Default Setting', 'Default Setting');
switch choice
    case 'Insert Force'
        % User-defined forces
        obj = defineForcesManually(obj);
    case 'Default Setting'
        % Default force settings
        obj= defaultForces(obj);
    otherwise
        % Handle no choice or cancellation
        error('Force Choice is required.');
end
end

function obj = defineForcesManually(obj)
% Let the user define forces manually

% Ask the user for the number of forces to apply
numForces = numberOfForces();

% Loop over each force to get user input
for i = 1:numForces
    obj = applyForceToNode(obj);
end



end


function obj = defaultForces(obj)
% Define the default forces applied to the nodes
% Implement the logic for default force settings here
obj.node_matrix(obj.number_of_nodes - 3).force(3) = - 1000;
visualizeForces(obj.node_matrix(29).cordinates , - 1000, 3);
end

function numForces = numberOfForces()
numForces = 0;
while numForces < 1
    answer = inputdlg('Number of Forces Applied', 'Number of Forces');
    numForces = str2double(answer);
    if isnan(numForces) || numForces < 1
        waitfor(msgbox('Please enter a valid number of forces.'));
        numForces = 0;
    end
end
end


function obj = applyForceToNode(obj)
shg; % Bring the current figure to the front
waitfor(msgbox('Choose a Node and press Space'));
dcm_obj = datacursormode(gcf);
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'on', 'Enable', 'on');
pause; % Wait for the user to click a point
info = getCursorInfo(dcm_obj);
forceInput = promptForForceValues();

% Extract the coordinates from the node_matrix into a numeric matrix
nodeCoordinatesMatrix = arrayfun(@(n) n.cordinates, obj.node_matrix, 'UniformOutput', false);
nodeCoordinatesMatrix = vertcat(nodeCoordinatesMatrix{:});

% Use ismember to find the index of the node with the given coordinates
[~, nodeIndex] = ismember(info.Position, nodeCoordinatesMatrix, 'rows');

% Apply the force to the corresponding node
obj.node_matrix(nodeIndex).force(forceInput(2)) = forceInput(1);


visualizeForces(obj.node_matrix(nodeIndex).cordinates, forceInput(1), forceInput(2));

end


function forceInput = promptForForceValues()
forceInput = [];
while isempty(forceInput)
    answer = inputdlg({'Load Value', 'Direction: x=1,y=2,z=3'}, 'Input Force');
    forceInput = str2double(answer);
    if any(isnan(forceInput)) || isempty(forceInput)
        waitfor(msgbox('Please enter valid force values.'));
        forceInput = [];
    end
end
end

function visualizeForces(nodeCoords, forceValue, forceDirection)

f1 = nodeCoords;
f2 = nodeCoords;
f2(forceDirection) = f2(forceDirection) - 3000;
if forceValue > 0
    df = f1 - f2;
    quiver3(f2(1),f2(2),f2(3),df(1),df(2),df(3),0,'LineWidth' ,3,'MaxHeadSize',20,'color','k');
else
    df = f2 - f1;
    quiver3(f1(1),f1(2),f1(3),df(1),df(2),df(3),0,'LineWidth' ,3,'MaxHeadSize',20,'AutoScale','on','color','k');
end

end

