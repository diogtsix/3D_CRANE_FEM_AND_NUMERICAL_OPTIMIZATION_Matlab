function [c,ceq] = nonLinCon2(x0, obj)

materialCatalog = dataobject.library.optimizationUtils.materilaCatalog();

d = arrayfun(@(m) m.density_in_kg_m3, materialCatalog.material);
e = arrayfun(@(m) m.YoungModulus_in_GPa, materialCatalog.material);
A0 = obj.desiredCrossSections;
sigmaR = arrayfun(@(x) x.tension_factor_in_kp_mm2, materialCatalog.material);


fA0 = obj.normalizationFactors.surface();
fd = obj.normalizationFactors.density();
fe = obj.normalizationFactors.elasticity();

%% Extract Vectors
A = x0(1:obj.structure.number_of_elements);
den = x0(obj.structure.number_of_elements + 1: 2 *obj.structure.number_of_elements);
el = x0(1 + obj.structure.number_of_elements*2: 3 * obj.structure.number_of_elements);

%% Remove Normalization
densitys = den * fd;

%% Call solver to solve
solveCrane = dataobject.library.solver.define("preprocessor", obj.structure);


%% Create non Linear const vector so strees < SigmaR
C1 = zeros(length(solveCrane.stressMatrix), 1);

for elementId = 1:length(solveCrane.stressMatrix)
    for jj = 1:length(sigmaR)
        if abs(densitys(elementId)-d(jj)) <= (1e-3)
            
            SSS = abs(solveCrane.stressMatrix(elementId) / (1e6));
            SSS = SSS/9.81;
            C1(elementId) = SSS - 4*sigmaR(jj);
            
            break
        end
        
    end
end

C2 = abs(solveCrane.stressMatrix) - 1 * abs(obj.initialStressMat) ;

c = [C1 ; C2];
%% Equality constraints
ceq = integerProgrammingFunc(d/fd, e/fe, A0/fA0, ...
    den, el, A);

    function equalityConst = integerProgrammingFunc(d, e, A0, ...
            densitys, elasticities, surfaces)
        
        Ze = ones(length(densitys), 1) ;
        Ae = ones(length(densitys), 1) ;
        
        for kk = 1: length(Ze)
            for ii = 1:length(d)
                
                As = (densitys(kk) - d(ii))^2 +(elasticities(kk) - e(ii))^2;
                Ze(kk) = Ze(kk) * As;
            end
        end
        
        for kk = 1: length(Ze)
            for ii = 1:length(A0)
                
                Bs = (surfaces(kk) - A0(ii))^2;
                Ae(kk) = Ae(kk) * Bs;
            end
        end
        
        equalityConst = [Ze ; Ae]; 
    end


end