% Ask the user which problem to run

choice = questdlg('Choose Model to run:', 'Model', ...
    'Crane with Truss only', 'Crane with Truss & Beams', 'trussBeams');

switch choice
    case 'Crane with Truss only'
        % User-defined forces
        suite = matlab.unittest.TestSuite.fromClass( ...
            ?tests.library.craneTrussElementsTest);
    case 'Crane with Truss & Beams'
        % Default force settings
        suite = matlab.unittest.TestSuite.fromClass( ...
            ?tests.library.craneBeamElementsTest);
    otherwise
        % Handle no choice or cancellation
        disp('Invalid choice. Exiting.');
end

% Run the tests
results = run(suite);
