data TLPYDAT.SAZ_CARTERA_TARGET (COMPRESS=no DROP=FLG);
     retain timestart;
     timestart=datetime();
     dcl hash hh (hashexp: 16,ordered: 'a') ;
           hh.definekey ('NUMERO_CUENTA', '_n_') ;
           HH.DEFINEDATA ('FLG') ;
           hh.definedone () ;
     dcl hash hs (hashexp: 16,ordered: 'a') ;
           hs.definekey ('NUMERO_CUENTA') ;
           hs.definedata ('_n_') ;
           hs.definedone () ;
     DO UNTIL ( END_LOOKUP ) ;
           set TLPYDAT.SAZ_CUENTAS_FILTRO (KEEP=NUMERO_CUENTA) end = end_lookup ;
           FLG=1;
           if hs.find() ne 0 then _n_ = 0 ;
           _n_ ++ 1 ;
           hs.replace() ;
           hh.add() ;
     end ;
     do until ( end_driver ) ;
           set TLPYDAT.SAZ_CARTERA3 ( WHERE=(PERIODO>=201910))  end = end_driver ;
           if hs.find() = 0 then
           do _n_ = 1 to _n_ ;
                HITS+1;
                call symputx('HITS_T', HITS);         
                hh.find() ;
                output ;
           end ;
/*____________________________________START_COUNTER___________________________________________________*/           
                     K+1;
                     call symputx('HCOUNTER_T', K);
                     IF MOD(K,200000)=0 THEN
                           DO;
                                timeEnd = Datetime();
                                timediff = Sum(timeend, -timestart);
                                Elapsed =  put(timediff, Time8.);
                                Start = put(timestart,datetime16.);
                                End = put(timeend,datetime16.);
                                Counter=put(K,comma24.);
                                Hitsf=put(Hits,comma24.);
                                RC02 = DOSUBL(CATX(' ','SYSECHO "R:',Counter,'H:',Hitsf,'E:',Elapsed,'";'));
                           END;
                     DROP TIMESTART TIMEEND TIMEDIFF ELAPSED START END K counter HITS HITSf RC02;  
/*____________________________________END_COUNTER___________________________________________________*/           
     end ;
     stop ;
run ;


data TLPYDAT.SAZ_UNIVERSO_ACTIVO_S02 (DROP=_F _RC Hitsf)  ;
     retain timestart;
     timestart=datetime();
     dcl hash hh (hashexp: 16, ordered: 'a');
     dcl hiter hi ('hh');
     hh.definekey ('PERIODO','NUMERO_CUENTA');
     hh.definedata ('fecha_activacion__c','_f');
     hh.definedone () ;
     do until (eof2);
           set
           TLPYDAT.SLF_CUENTA_FACT (KEEP=PERIODO NUMERO_CUENTA fecha_activacion__c where=(periodo>=201910))
           end = eof2;
           _f = .;
           hh.add();
     end;
     do until(eof);
           set
                TLPYDAT.SAZ_UNIVERSO_ACTIVO
           end = eof;
           call missing(fecha_activacion__c);
           if hh.find() = 0 then do;
                _f = 1;
                HITS+1;
                call symputx('HITS', HITS);
                hh.replace();
                output;
                _f = .;
           end;
           else output;
        /*____________________________________START_COUNTER___________________________________________________*/           
                 K+1;
                 call symputx('N1', K);
                 call symputx('HCOUNTER', K);
                 IF MOD(K,200000)=0 THEN
                       DO;
                            timeEnd = Datetime();
                            timediff = Sum(timeend, -timestart);
                            Elapsed =  put(timediff, Time8.);
                            Start = put(timestart,datetime16.);
                            End = put(timeend,datetime16.);
                            Counter=put(K,comma24.);
                            Hitsf=put(Hits,comma24.);
                            RC02 = DOSUBL(CATX(' ','SYSECHO "R:',Counter,' H:',Hitsf,' E:',Elapsed,'";'));
                       END;
                 DROP TIMESTART TIMEEND TIMEDIFF ELAPSED START END K counter HITS RC02;  
        /*____________________________________END_COUNTER___________________________________________________*/     
                
     end;
     do _rc = hi.first() by 0 while (_rc = 0);
           if _f ne 1 then do;
           end;
           _rc = hi.next();
     end;
stop;
run;

