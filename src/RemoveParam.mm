RemoveParam := proc(f::procedure, p::name, v::algebraic)
	local fir, i, parameters, n;

     fir := ToInert(eval(f));

     parameters := GetParam(f);

     n := numelems(parameters);

     if not member(p, parameters, i) then return f end if;

     if _params['v'] = NULL then
        fir:=subsindets(fir, specfunc(integer,_Inert_PARAM),
                             x->`if`(op(x)=i, NULL,x));
     else
        fir:=subsindets(fir, specfunc(integer,_Inert_PARAM),
                             x->`if`(op(x)=i, ToInert(v),x));
     end if;

     # Remove 'p' from the parameters (with type definition)
     fir:=subsindets(fir, specfunc(anything,_Inert_DCOLON),
                          x->`if`(convert(op([1,1],x),name)=p, NULL, x));

     # Remove 'p' from the parameters (without type definition)
     fir:=subsindets(fir, specfunc(identical(convert(p,':-string')),
                                   _Inert_NAME), x->NULL);

     # Updating the parameter tags
     fir:=subsindets(fir, specfunc(integer,_Inert_PARAM),
                         x->`if`(op(x)>i, _Inert_PARAM(op(x)-1),x));

     return FromInert(fir);

end proc:
