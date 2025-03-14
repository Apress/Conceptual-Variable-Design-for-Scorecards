/*Code 10 1. NLIST code and example.*/
%macro nlist(list,delimiter=);
 %let nlist_i=0;
 %if %quote(&delimiter)= %then %do;
  %do %while(%quote(%scan(&list,%eval(&nlist_i+1)))~=);
   %let nlist_i=%eval(&nlist_i+1); 
  %end;
 %end;
 %else %do;
  %do %while(%quote(%scan(&list,%eval(&nlist_i+1),&delimiter))~=);
   %let nlist_i=%eval(&nlist_i+1);
  %end;
 %end;
 &nlist_i 
%mend; 

/*Code 10 2. PREFIXLIST code and example.*/
%macro prefixlist(list,prefix=r_);
 %do prefixlist_i=1 %to %nlist(&list);
 %substr(&prefix%scan(&list,&prefixlist_i),1,
         %sysfunc(min(32,%length(&prefix%scan(&list,&prefixlist_i)))))
 %end;
%mend;

/*Code 10 3. ENQUOTE code and example.*/
%macro enquote(list,separator=%str(,),type=D);
	%let nlist=%nlist(&list);
	%if %upcase(&type)=S %then %do;
	%do enquote_i=1 %to %eval(&nlist-1);
	%str(%')%scan(&list,&enquote_i)%str(%')&separator
	%end;
	%str(%')%scan(&list,&nlist)%str(%')
	%end;
	%else %do;
	%do enquote_i=1 %to %eval(&nlist-1);
	"%scan(&list,&enquote_i)"&separator
	%end;
	"%scan(&list,&nlist)"
	%end;
%mend; 

/*Code 10 4. REMOVE code and example.*/
%macro remove(list1,from=);
%do remove_i=1 %to %nlist(&from);
%if %index(%upcase(&list1),%scan(%upcase(&from),&remove_i))=0 %then %do;
%scan(&from,&remove_i)
%end;
%end;
%mend;

/*Code 10 5. RECODE code.*/
%macro recode(data=,input=INPUT,start=START,end=END,value=VALUE,
               prefix=r_,freq=1,file=PRINT,action=);

proc sort data=&data;
  by &input &start;
run;

data _null_;
  attrib s length=$200;
  attrib recode length=$32;
  retain n_tot weighted_sum;

  file &file &action;

  set &data;
  by &input;

  recode="&prefix"||substr(&input,1,min(length(&input),32-%length(&prefix)));

  if first.&input then do;
	n_tot=0;
	weighted_sum=0;
	put ;
	put ;
	s="*** Recode input "||strip(&input)||" to &VALUE values;";
	put s;
	put ;
	s="select;";
	put s;
  end;

  s="when (";

  if &start = &end then do;
    s=strip(s)||strip(&input)||" = '"||trimn(&start)||"'";
  end;
  else do;
    if &start>-constant('BIG') then s=strip(s)||strip(&start)||" <="; 
    s=strip(s)||strip(&input);
    if &end<constant('BIG') then s=strip(s)||" < "||strip(&END);
  end;

  s=strip(s)||") "||strip(recode)||"="||strip(&value)||";";
  put @3 s;

  n_tot + &freq;
  weighted_sum + (&freq*&value);

  if last.&input then do;
 	s="otherwise "||strip(recode)||"="||strip(weighted_sum/n_tot)||";";
	put @3 s;
	s="end;";
	put s;
  end;
run;
%mend;

/*Code 10 6. METADATA code and example.*/
%macro metadata(newlevel=,newrole=,where=1,append=N);
	%let newlevel = %upcase(&newlevel);
	%let newrole = %upcase(&newrole);
	%if &append=Y %then %let mode=A;
	%else %let mode=O;

	%let filrf=X;
	%let rc=%sysfunc(filename(filrf,&EM_FILE_CDELTA_TRAIN));
	%let fid=%sysfunc(fopen(&filrf,&mode));
	%if &fid > 0 %then %do;
	 	%let s= if &where then do%str(;);
		 %do metadata_i=1 %to %nlist(%bquote(&s),delimiter=%str( )) %by 3;
		  %let t=%scan(&s,&metadata_i,%str( )) 
		%scan(&s,%eval(&metadata_i+1),%str( )) 
		%scan(&s,%eval(&metadata_i+2),%str( ));
		  %let rc=%sysfunc(fput(&fid,%bquote(&t)));
		  %let rc=%sysfunc(fwrite(&fid));
	%end;
	%if &newlevel~= %then %do;
	  %let s=  LEVEL=%str(%')&newlevel%str(%')%str(;);
	  %let rc=%sysfunc(fput(&fid,&s));
	  %let rc=%sysfunc(fwrite(&fid));
	%end;
	%if &newrole~= %then %do;
	  %let s=  ROLE=%str(%')&newrole%str(%')%str(;);
	  %let rc=%sysfunc(fput(&fid,&s));
	  %let rc=%sysfunc(fwrite(&fid));
	%end;

	%let s= end%str(;);
	%let rc=%sysfunc(fput(&fid,&s));
	%let rc=%sysfunc(fwrite(&fid));

	%let rc=%sysfunc(fclose(&fid));
	%end;
	%else %put %sysfunc(sysmsg());
	%let rc=%sysfunc(filename(filrf));

%mend;
