

libname partie_2 "/folders/myfolders/Partie_2/"

data work.apnee;
set partie_2.apnee;
run;

proc format;
   value sex
      0 ="Homme"
      1 ="Femme";
run;
proc format;
value fumeur
0="non-fumeur"
1="fumeur";
run;
proc format;
value malade
0="non"
1="oui";
run;

data work.apnee;
set work.apnee;
format SEXE sex.;
format TABAC fumeur.;
format APNEE malade.;
run;

proc print data=work.apnee;
run;

proc univariate data=work.apnee;
run;


/*partie2-2*/




/*MODEL 1* modele Global */
/*Nous allons utiliser le model fit statistics pour comprare les différents modèles */
proc logistic data=work.apnee ;
  model Apnee= AGE
POIDS
TAILLE
SEXE
ALCOOL
TABAC ;
run;



/*faisons une selection de variables stepwise en faisant rentrer pas à pas les vaiables dans le modèle 
elles entrent si leur coéfficient dans l'équation globale  est au dessus 0.3 et reste si
elles ont un coefficient dans le modèle latent supérieur a 0.4 on a pas été très sévère vu les coéfficients 
observés  dans le modèle complet auparavant */

title 'Stepwise elimination';
   proc logistic data=work.apnee ;
      model apnee(event='oui')=AGE POIDS TAILLE SEXE ALCOOL TABAC
                   / selection=stepwise
                     slentry=0.4
                     slstay=0.3
                     details
                     lackfit;
      output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
   run;
   
   /*en analysant les indicateurs disponibles pour ce modèle on peut dire que l'alcool reste 
   /*la variable(la plus significative ) qui explique le mieux la presence d'apnée du sommeil*/
   

title 'backward elimination';

proc logistic data=work.apnee ;
      model apnee(event='oui')=AGE POIDS TAILLE SEXE ALCOOL TABAC
                   / selection=backward
                     slentry=0.4
                     slstay=0.4
                     details
                     lackfit;
      output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
   run;

title 'backward elimination';

proc logistic data=work.apnee ;
      model apnee(event='oui')=AGE POIDS TAILLE SEXE ALCOOL TABAC
                   / selection=backward
                     slentry=0.3
                     slstay=0.3
                     details
                     lackfit;
      output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
   run;

title 'forward elimination';

proc logistic data=work.apnee ;
      model apnee(event='oui')=AGE POIDS TAILLE SEXE ALCOOL TABAC
                   / selection=forward
                     slentry=0.3
                     slstay=0.3
                     details
                     lackfit;
      output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
   run;

/*comparons le modèle retenu aux modèles complet et celui avec que la variable tabac*/
/*Model 1 modele retenu*/
proc logistic data=work.apnee PLOT =EFECTS ;
  model Apnee= AGE
ALCOOL
TABAC ;
run;


/*comme dans le cours on va comparer principalement les "Model Fit Statistics"*/
/*plus ils sont faibles plus ils sont meilleurs  et "testing global hyspothesys null"*/


/*model 2 model complet */
ods graphics on;
proc logistic data=work.apnee PLOTS=EFFECT;

  model Apnee= AGE
POIDS
TAILLE
SEXE
ALCOOL
TABAC ;

run;
/*au niveau du test de nullité les différetes proba des différents test sont plus élevés pour le modèle complet
il comporte donc sans surprise plus de variable moins significatives 
Mais au niveau des indicateurs en rapport avec la vraissemblance du modèle complet a un logiquement un AIC plus élevé
(l'AIC est un critère de selection de variable c'est logique) que
le modèle retenu mais les deux modèle ont une vraissemblance proche )
il n'en demeure pas moins que globalement et à beaucoup d'égards le modèle sélectionné c'est à dire avec comme 
varible explicatives le tabac , l'alcool et l'age reste le meilleur */

/*model3 model avec juste la variable tabac*/
proc logistic data=work.apnee PLOTS=EFFECT  ;
  model Apnee=
TABAC ;
run;
/*ce modèle est particulierement mauvais par rapport au modèle retenu :
d'une le test de nullité des coéfficients renvoie des probabilités 10 fois supérieurs 
pour lui par rapport à celui du modèle retenu

de deux par rapport aux critères en rapport avec la vraissemblance c'est à dire l'AIC  et -2*logvrassemblance ils sont beaucoup
plus hauts que ceux du modèle retenu*/


