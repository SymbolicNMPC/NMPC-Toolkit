GetParam := proc(f::procedure)

   local fir;

   fir := ToInert(eval(f));

   return map(x->`if`(type(x,specfunc(anything,':-_Inert_DCOLON')),
                      convert(op([1,1], x),name),
                      convert(op(x),name)), [op(op([1],fir))]);

end proc;
