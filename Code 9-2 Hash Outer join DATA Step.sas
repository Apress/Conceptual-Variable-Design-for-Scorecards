data ABT (DROP=_F _RC)  ;

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
                hh.replace();
                output;
                _f = .;
           end;
           else output;               
     end;

     do _rc = hi.first() by 0 while (_rc = 0);
           if _f ne 1 then do;
           end;
           _rc = hi.next();
     end;

stop;
run;

