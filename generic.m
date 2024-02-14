classdef (Abstract) generic < matlab.mixin.SetGet
    %GENERIC Abstract class
    
    methods
        function obj = generic()
            %Generic Construct an instance
        end
        
        function value = createStructure(obj)
            %converts the dataobj into a structure
            props = properties(obj);
            for i = 1:length(props)
                myprop = props{i};
                myvalue = obj.(myprop);
                switch class(myvalue)
                    case {"double", "cell", "logical", "char", "struct"}
                        value.(myprop) = myvalue;
                    case "table"
                        value.(myprop) = table2struct(myvalue, "ToScalar", true);
                    otherwise
                        value.(myprop) = myvalue.createStructure();
                end
            end
        end
    end
end


