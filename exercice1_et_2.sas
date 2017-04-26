/*Tehe Bommanin Yannick Stephane */
/*09/04/2017*/

libname partie_1 "/folders/myfolders/Partie_1/"

/*EXERCICE 1*/

/*Question 1*/

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



/*pour la dernière table suite à un problème d'encodage j'ai décidé de la convertir au format csv réencodre des caractères   et de l'importer sous SAS*/

PROC IMPORT DATAFILE="/folders/myfolders/Partie_1/tabfcs.csv"
  OUT=work.tabfcs
  DBMS=csv
  REPLACE;
  GETNAMES=Yes;
RUN;



/*verification */
proc print data=work.tabfcs;
run;


/*Question 2 */
/* les informations sur les Tables */

proc contents data=work.libdep ;
run;

proc contents data=work.liste_ze;
run;

proc contents data=work.pauv12dep;
run;

proc contents data=work.pauv12zetypmen1;
run;

proc contents data=work.pauv12zetypmen2;
run;

proc contents data=work.pauv12zetypmen3;
run;

proc contents data=work.pauv12zetypmen4;
run;

proc contents data=work.pauv12zetypmen5;
run;

proc contents data=work.pauv12zetypmen6;
run;

proc contents data=work.pauv12zetypmen6;
run;

proc contents data=work.rp12_d35;
run;

proc contents data=work.tabfcs;
run;


proc print data =work.pauv12dep;
run;

/*Exercice 2*/

/*Question 1)*/

proc sort data = work.pauv12dep out = work.output1 NODUPKEY;
by CODGEO;
run;

proc print data=work.output1;
run;



/*on remarque que rangé dans l'ordre en évitant les doublons sur la clé identifiant le déparetement on a le même nombre champ dans la table en sortie que danns pauv112dep  96 .
Chaque département de France métrolitaine estd onc présent une seule fois dans cette table .*/




proc sql ; 
select CODGEO,MED12
from work.pauv12dep
order by MED12 ;
quit;


/*Question 2 */

proc sql; 
select CODGEO,MED12
from work.pauv12dep
where CODGEO in ("75","77","78","91","92","93","94","95")
order by MED12 ;
quit;
/*C'est le 93 le département avec le revenu moyen le plus bas */


proc sql; 
select CODGEO,MED12
from work.pauv12dep
where CODGEO in ("75","77","78","91","92","93","94","95")
order by MED12 desc;
quit;
/* et le 75 a le revenu median le plus élevé*/

/*Création du format*/
proc format;
   value situ
      0-19785.5    =0
      19785.5-high =1;
run;

data work.new_pauv;
set work.pauv12dep;
format MED12 situ.;
run;

/* affichons le tableau voir :*/

proc print data = work.new_pauv;
run;

proc sort data=work.new_pauv out= work.tri;
by MED12;
run;

proc print data=work.tri n; 
by MED12;
run;

/*on obtient 68 départements en dessous de la médiane nationnale et 28 départelment en dessous de celle ci*/

proc sql; 
select sum(nbperspv12)
from work.pauv12dep
where CODGEO in ("75","77","78","91","92","93","94","95");
quit;

/*on trouve qu'il y a 1765613 personnes sous le seuil de pauvreté en ile de France */
