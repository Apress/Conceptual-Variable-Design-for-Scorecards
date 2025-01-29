data ABT (DROP=_F _RC)  ;

     retain timestart;
     timestart=datetime();

	 IF 0 THEN 	SET INPUT_TABLE;

     dcl hash hh (hashexp: 16, ordered: 'a');
     dcl hiter hi ('hh');
     hh.definekey ('SUBJECT_ID');
     hh.definedata ('NEW_VARIABLE','_f');
     hh.definedone () ;

     do until (eof2);
           set INPUT_TABLE (KEEP=SUBJECT_ID NEW_VARIABLE) end = eof2;
           _f = .;
           hh.add();
     end;

     do until(eof);
           set ABT end = eof;
           call missing(NEW_VARIABLE);
           if hh.find() = 0 then do;
                _f = 1;
				HITS+1;
                hh.replace();
                output;
                _f = .;
           end;
           else output;   
        /*____________________________________START_COUNTER___________________________________________________*/           
                 K+1;
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