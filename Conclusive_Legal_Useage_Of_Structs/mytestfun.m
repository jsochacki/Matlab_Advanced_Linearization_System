function obj=mytestfun(obj)
    obj.a=obj.a;
    obj.b=obj.a;
    I_Only_Exist_In_This_Function_Unless_Passed_out=obj.b;
end