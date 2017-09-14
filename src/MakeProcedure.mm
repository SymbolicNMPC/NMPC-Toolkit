MakeProcedure := proc(SLP         :: list,
                      states      :: list,
                      inputs      :: list,
                      extputs     :: list,
                      statesdot   :: list,
                      vectoroutput := false)
        local p, pir, locals, body, i, out;
        `tools/genglobal`(':-out',[],':-reset');
        out := `tools/genglobal`(':-out', SLP);
        if vectoroutput then
           pir := ToInert(codegen:-makeproc([seq(SLP),seq(out[i]=statesdot[i],i=1..numelems(statesdot)),out],[seq(states),seq(inputs),seq(extputs)]));
        else
           p := codegen:-makeproc([seq(SLP), out],[seq(states),seq(inputs),seq(extputs)]);
           p := subs(out=statesdot,eval(p));
        end if;

        if vectoroutput then
           locals := op(2,pir);
           pir := subsop(2=op(0,locals)(op(locals),_Inert_NAME(convert(out,string))), pir);

           body := op(5,pir);
           pir := subsop(5=op(0,body)(_Inert_ASSIGN(_Inert_LOCAL(nops(locals)+1),ToInert(Vector(numelems(statesdot)))),op(body)), pir);

           return FromInert(pir);
        else
           return eval(p);
        end if;


end proc;
