/*Tehe Bommanin Yannick*
/*07/04/2017*/

libname partie_1 "/folders/myfolders/Partie_1/"

/*Exercice 3*/

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


/*proc print data= work.rp12_d35;
run;*/



/*Question 1)*/

proc format;
   value $sex
      1 ="Homme"
      2="Femme";
run;

data work.new_rp12;
set work.rp12_d35;
format SEXE $sex.;
run;

/*Question 2 )
#attention cette question porte sur l'ile et vilaine et non sur Paris */

proc freq data = work.new_rp12 ;
table SEXE;
weight IPONDI;
run;
/*on a 48.84% d'homme donc 51.16% de femmes  en ile et vilaine */

proc freq data = work.new_rp12;
tables SEXE*TP;
weight IPONDI;
run;
/* en tenat compte de la variable on peut dire que :
58.97% des personnes à temps complet sont hommes contre  41,03% pour les femmes 
Alors que 21,4% des personnes à temps partiel sont des hommes contre 78,6 %  pour les femmes  */ 

/*EXERCCICE 4)*/


/*question 1 )*/

proc univariate data=work.new_rp12;
var age;
weight IPONDI;
run;
/* l'age médian pondéré est de 38 ans */

proc sort data= rp12_d35 out= work.new_bis_rp12;
by SEXE;
run;

proc univariate data=work.new_bis_rp12;
var age;
weight IPONDI;
by SEXE ;
format SEXE $sex.;
run;


/*
l'age median pondéré des hommes est de 37 ans et celui des femmes est de  40 ans */


/*Question 2)*/

%let splits = %str(output out=work.deciles pctlpre=quantile_
pctlpts=10 to 100 by 10);
proc univariate data=work.new_bis_rp12;
var age;
&splits;
weight IPONDI;
by SEXE ;
format SEXE $sex.;
run;
proc print data=work.deciles;
run;
/* on obtient bien les déciles voulus */
/* /*mettre le tableau dans la rédaction* */

/*question3*/

proc univariate data=work.rp12_d35 ;
var age;
weight IPONDI;
output out=work.indicateurs;
run;
/* la table contenat tous ces indicateurs est work.indicateurs*/
/*car il n'y que la proc univariate qui peut renvoyer tous ces indicateurs*/
