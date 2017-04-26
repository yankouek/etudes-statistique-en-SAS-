/*Tehe Bommanin Yannick Stephane */
/*09/04/2017*/
libname partie_1 "/folders/myfolders/Partie_1/"



data work.libdep;
set partie_1.libdep;
run;

data work.liste_ze;
set partie_1.liste_ze;
run;

data work.pauv12dep;
set partie_1.pauv12dep;
run;

data work.pauv12zetypmen1;
set partie_1.pauv12zetypmen1;
run;
data work.pauv12zetypmen2;
set partie_1.pauv12zetypmen2;
run;

data work.pauv12zetypmen3;
set partie_1.pauv12zetypmen3;
run;

data work.pauv12zetypmen4;
set partie_1.pauv12zetypmen4;
run;

data work.pauv12zetypmen5;
set partie_1.pauv12zetypmen5;
run;
data work.pauv12zetypmen6;
set partie_1.pauv12zetypmen6;
run;

data work.rp12_d35;
set partie_1.rp12_d35;
run;


/*Exercice 5*/

/*Question 1*/



/*modifions les d'abord en prévision du tableau final */

DATA work.new_pauv12zetypmen1 (keep= codgeo type_menage med12  );
SET pauv12zetypmen1 ;
codgeo=codgeo;
type_menage=1;
RUN;

DATA work.new_pauv12zetypmen2 (keep= codgeo type_menage med12  );
SET pauv12zetypmen2 ;
codgeo=codgeo;
type_menage=2;
RUN;


DATA work.new_pauv12zetypmen3 (keep= codgeo type_menage med12  );
SET pauv12zetypmen3 ;
codgeo=codgeo;
type_menage=3;
RUN;


DATA work.new_pauv12zetypmen4 (keep= codgeo type_menage med12  );
SET pauv12zetypmen4 ;
codgeo=codgeo;
type_menage=4;
RUN;


DATA work.new_pauv12zetypmen5 (keep= codgeo type_menage  med12 );
SET pauv12zetypmen5 ;
codgeo=codgeo;
type_menage=5;
RUN;

DATA work.new_pauv12zetypmen6 (keep= codgeo type_menage med12  );
SET pauv12zetypmen6 ;
codgeo=codgeo;
type_menage=6;
RUN;



/*proc print data=work.new_pauv12zetypmen3;
run;*/


data work.emploi  /*emploi toute zone confondue*/;
set work.new_pauv12zetypmen1(rename=(med12=Mediane)) work.new_pauv12zetypmen2 (rename=(med12=Mediane))
work.new_pauv12zetypmen3(rename=(med12=Mediane)) work.new_pauv12zetypmen4(rename=(med12=Mediane))
work.new_pauv12zetypmen5(rename=(med12=Mediane)) work.new_pauv12zetypmen6(rename=(med12=Mediane)) ;

run;


/*pour vérifier*/
proc print data= work.emploi;
run;
/*l'ordre ne nous convie t pas ici une modifiaction s'impose */


proc sql;
  create table work.emploi_bis as
  select codgeo,type_menage, mediane
  from work.emploi;
quit;


/*verifions que cette fois l'ordre est bon */
proc print data= work.emploi_bis;
run;
/*ok nickel*/ 

/*Et enfin pour répondre à la question */

proc sort  data=work.emploi_bis;
by codgeo;
run;
data work.emploi_complet;
set work.emploi_bis(rename=(codgeo=zone_demploi));
run; 


proc print data= work.emploi_complet;
run;
/*on a ainsi répondu à a la question 1*/

/*Question 2*/

proc transpose data=work.emploi_complet out=work.essai PREFIX = mediane_pour_letype_de_menage_ ;

by zone_demploi;/* Comme son nom l'indique ! */
var  mediane;
run;
data work.mediane_par_ze;
set work.essai(DROP= _NAME_ _LABEL_);
run;

proc print data=work.mediane_par_ze noobs;
run;
/*on a bien obtenu ce qu'on voulait*/



/*Question 3*/

/*en observant le tableau obtenu à la question précédente il semble que ce soit le type de menage 3(les familles monoparentales)  qui ait les revnuis les plus faibles vérifions le*/

DATA work.verification;

SET work.mediane_par_ze;

var_verif= mediane_pour_letype_de_menage_3 < min(mediane_pour_letype_de_menage_1,
 mediane_pour_letype_de_menage_2, mediane_pour_letype_de_menage_4,
mediane_pour_letype_de_menage_5, mediane_pour_letype_de_menage_6);

RUN;

proc print data=work.verification;
run;
/*il suffit maintenat de comparer le nombre de 1 au nombre d'oservations on a 304 zones */


proc sql;
select sum(var_verif) 
from work.verification;
quit;
/* loin des 304 escomptés 
le menage 3 n'est donc pas toujours celui qui a la mediane de revenu la moins élevé dans toutes les zones 
on voi à l'oeil que les autres types de menaes ne le sont pas donc on a bien verifié 
que ce n'est pas le même type de menage qui a le renu médian le plus bas dans toutes les zones


/*Question 4 */


proc sql;
create table emploi_lze as
select * from liste_ze inner join  emploi_bis 
on liste_ze.codgeo = emploi_bis.codgeo ;/*table emploi_bis il s'agit de la liste qui aviat été triée */
quit;

data work.emploi_restreint;
set work.emploi_lze(rename = (CODGEO=zone_demploi));
run;

proc print data=work.emploi_restreint;
run;
/*on obtient bien le résultat escompté */

/*Question 5)*/

proc sql ;
         create table complement as
         select *
         from work.emploi_bis
         except
         select *
         from work.emploi_lze;
         quit;
/*reste a renommer codegeo dans les 2 tables */



data work.complementaire;
set complement(rename= (CODGEO= zone_demploi));
run;

proc print data=work.complementaire;
run;
