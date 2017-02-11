%Conclusive_Legal_Useage_Of_Structs
clear all
inobj=struct('a',200);

mystruct=struct('CallFunctionAndAssignOutputExternalWithPass',eval('@(in) mytestfun(in)')...
            ,'CallFunctionAndAssignOutputExternalNoPass',eval('@() mytestfun(struct(''a'',30))')...
            ,'CallFunctionAndAssignOutputInternalWithPass',@(in) assignin('caller','result_3',eval('mytestfun2(in)'))...    
            ,'CallFunctionAndAssignOutputInternalNoPass',@() assignin('caller','result_4',eval('mytestfun(struct(''a'',30))'))...
            ,'CallFunctionAndAssignHandleInternalWithPass',@(in) assignin('caller','handle_3',eval('@(in) mytestfun2(in)'))...    
            ,'CallFunctionAndAssignHandleInternalNoPass',@() assignin('caller','handle_4',eval('@() mytestfun(struct(''a'',30))'))...
            ,'CallContainedAnanonamousFunctionWithPass',@(x) [x.a sprintf('%i',x.a)]...
            ,'CallContainedAnanonamousFunctionNoPass',@() sprintf('%s','my local anon fun'));

%The contents of mytestfun.m

% function obj=mytestfun(obj)
%    obj.a=obj.a;
%    obj.b=obj.a;
%    I_Only_Exist_In_This_Function_Unless_Passed_out=obj.b;
% end

%The contents of mytestfun2.m

% function outobj=mytestfun2(inobj)
%    outobj.a=inobj.a;
% end
%         

inobj

result_1=mystruct.CallFunctionAndAssignOutputExternalWithPass(inobj)            

inobj

result_2=mystruct.CallFunctionAndAssignOutputExternalNoPass()   

inobj

mystruct.CallFunctionAndAssignOutputInternalWithPass(inobj)   

inobj

mystruct.CallFunctionAndAssignOutputInternalNoPass()   

inobj

mystruct.CallFunctionAndAssignHandleInternalWithPass()   

handle_3(inobj)

mystruct.CallFunctionAndAssignHandleInternalNoPass()   

handle_4()

inobj

result_5=mystruct.CallContainedAnanonamousFunctionWithPass(inobj)            

inobj

result_6=mystruct.CallContainedAnanonamousFunctionNoPass()   