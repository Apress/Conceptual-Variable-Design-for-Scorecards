data TARGET_DATA_SOURCE (COMPRESS=no DROP=FLG);

	 dcl hash hh (hashexp: 16,ordered: 'a') ;
	       hh.definekey ('SUBJECT_ID', '_n_') ;
	       HH.DEFINEDATA ('FLG') ;
	       hh.definedone () ;
	 dcl hash hs (hashexp: 16,ordered: 'a') ;
	       hs.definekey ('SUBJECT_ID') ;
	       hs.definedata ('_n_') ;
	       hs.definedone () ;

	 DO UNTIL ( END_LOOKUP ) ;
	       set TARGET_POPULATION (KEEP=SUBJECT_ID) end = end_lookup ;
	       FLG=1;
	       if hs.find() ne 0 then _n_ = 0 ;
	       _n_ ++ 1 ;
	       hs.replace() ;
	       hh.add() ;
	 end ;

	 do until ( end_driver ) ;
	       set DATA_SOURCE ( WHERE=(START_PERIOD<=PERIOD<=END_PERIOD))  end = end_driver ;
	       if hs.find() = 0 then
	       do _n_ = 1 to _n_ ;        
	            hh.find() ;
	            output ;
	       end ;           
	 end ;

	 stop ;
run ;


