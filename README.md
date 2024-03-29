# Crane Finite Element Method (FEM) and Optimization Project
# Overview
This repository contains two interrelated projects focused on the structural analysis and optimization of a 3D crane model using Finite Element Method (FEM) and optimization techniques. The first part, the Crane FEM project, involves building a comprehensive simulation environment to analyze the structural behavior of the crane under various load conditions. The second part, the Crane Optimization project, leverages optimization algorithms to enhance the design and performance of the crane structure. The whole project is written with Object - Oriented - Programming principals (OOP).

# Crane Finite Element Method (FEM) Project
The Crane FEM project is designed to perform detailed structural analysis of a 3D crane. It encompasses the following key components:

Preprocessor: Generates the finite element model of the crane, including node and element matrices. This module defines the geometry, material properties, and boundary conditions of the crane structure. Currently there are 2 option regarding the crane : Truss  or both Truss and Beams elements. 

Solver: Handles the core FEM calculations, such as stiffness matrix formulation, load vector computation, and displacement analysis. The solver integrates with the preprocessor to obtain model definitions and performs linear static analysis to evaluate the structural response.

Postprocessor: Provides visualization and interpretation of the results, including deformation, stress distribution, and potential failure points. It offers various visualization options, including deformed and undeformed structure overlays. There are multiple option for visualization.

# Crane Optimization Project
Building on the FEM project, the Crane Optimization project aims to optimize specific aspects of the crane design, such as material usage and structural efficiency. Key features include:

Material and Geometry Optimization: Utilizes optimization algorithms (like fmincon) to minimize weight while adhering to stress constraints and other design limitations. Currently there are 4 different types of elements, 2 different ways to optimize (either Cross -Sections only or Cross - Section and Materials). You can choose any type of optimization method (IPOPT, SQP etc.)

User Interface (UI): An interactive UI allows users to select design parameters, element types, and load conditions. The UI simplifies user interaction and enhances the usability of the optimization process.

Automated Testing Suite: Includes a comprehensive set of unit tests for validating the functionality and integrity of the FEM and optimization algorithms. This suite ensures the reliability and accuracy of the simulation and optimization outcomes.

# Technologies Used
MATLAB: The primary environment for developing and executing FEM analysis and optimization algorithms.
MATLAB GUI Development: For creating user-friendly interfaces.
MATLAB Unit Testing Framework: For implementing and executing unit tests.

# How to Use
Clone the Repository: Clone this repository to your local machine to get started with the projects.
Run the FEM Analysis: Navigate to the FEM project directory and execute the main.m script inside the "run" folder. Options will appear and guide you through all the projects.
Testing: To run a specific test, navigate to the +tests folder.

Contributions and Feedback
Contributions to this project are welcome! Feel free to fork the repository and submit pull requests. For bugs, questions, or comments, please open an issue in this repository.
