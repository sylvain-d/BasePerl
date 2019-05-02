### Pas de tampon sur les entrées / sorties
$|=1;

######################
### Les includes...###
######################

# Pour etre plus rigoureux : toute variable doit être déclarée
use strict;
# Pour faire des requetes http
use LWP::UserAgent;
# Pour envoyer un mail
use Net::SMTP;
# Pour la gerstion du temps / dates
use Time::Local;
use Time::localtime;
# pour avoir une précision inferieur à la seconde
use Time::HiRes qw(gettimeofday);






######################
### Initialisation ###
######################

my $server="mailhost.axime.com";
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new;
my $response = $ua->request($req);

### A commenter si pas de proxy
$ua->proxy(['http', 'ftp'] => 'http://proxy:3128');










#####################
### Début         ###
#####################

Logger("Début du traitement à ".Get_Time());

### Récupération des
### arguments du perl
my $argument1 = $ARGV[0];

### Initialisation d'un tableau
my @tableau; # acces a un des éléments : $tableau[i]

### Initialisation d'une map
my %map; # acces a un des éléments : $map{"key"}
         # ajout d'un élément : $map{"key"}="objet";
         # récupérer le tableau des clés de la map : keys %map

### Parcourir les éléments d'un tableau
foreach my $element (@tableau) {
}
### Parcourir les éléments d'une map
foreach my $cle (keys %map) {
  ### contenu
  my $valeur = $map{$cle};
}

### Ouvrir un fichier en lecture
open (FIC_LECTURE, "D:/PST/Exemple.txt");

### On parcours les lignes du fichier ouvert
while (my $line=<FIC_LECTURE>) {
  ### On supprime le dernier caractère de la ligne (retour chariot)
  chomp ($line);

  ###################
  ### Hit sur la page
  print ("Hit sur la page $line.");
  my $timeDebut = getDateAsLong();
  my $page  = getContenuHTTP("$line");
  my $timeFin   = getDateAsLong();

  my $sec=int(($timeFin-$timeDebut)/1000);
  my $temps=sprintf("%d,%03d",$sec,($timeFin-$timeDebut)-$sec*1000);
  Logger(" Ok.");
}

### Ouvrir un fichier en écriture : attention au >
open (FIC_OUT, ">D:/PST/Retour.log");
print FIC_OUT "Ca c'est bien passé.\nL'argument de script était : $argument1.\n";
close FIC_OUT;

### Passer une expression régulière
### $argument1 =~ //;

### Exemple : supprimer tous les i pour les remplacer par des o
### s pour indiquer la suppression, /ce qu'il faut supprimer/à remplacer par ça/
### le g pour dire qu'il faut l'appliquer sur tous les éléments
 $argument1 =~ s/i/o/g;

EnvoyerMail("exp\@atosorigin.com","silvere.dusserre\@atosorigin.com", "Sujet",
             "Contenu : L'argument du script avec des o au lieu des i est : $argument1");






#####################
### Fin           ###
#####################

### On ferme le fichier ouvert
close (FIC_LECTURE);
Logger("Fin du traitement à ".Get_Time());










###############################################################
###############################################################
###                         METHODES                        ###
###############################################################
###############################################################

##############################
### Envoyer un mail          #
##############################
### Param 1 : expéditeur     #
### Param 1 : destiantaires  #
### Param 1 : sujet          #
### Param 1 : contenu        #
##############################
### Retourne rien :-)        #
##############################
sub EnvoyerMail
{
  my $expediteur   = $_[0];
  my $destinataire = $_[1];
  my $sujet   = $_[2];
  my $contenu = $_[3];
  my $mail = new Net::SMTP $server;
  $mail->mail("$expediteur");
  $mail->to("$destinataire");
  $mail->data;
  $mail->datasend("To: $destinataire\n");
  $mail->datasend("Subject: $sujet\n");
  $mail->datasend("Content-Type: text/html\n");
  $mail->datasend("\n");
  $mail->datasend("<HTML><BODY>\n<h1>MAIL DU TRAITEMENT PERL</h1><br>");
  $mail->datasend("$contenu");
  $mail->datasend("\n</HTML></BODY>\n");
  $mail->dataend;
  $mail->quit;
}

##############################
### Récupérer une page Web   #
##############################
### Param 1 : url désirée    #
##############################
### Return : La page         #
##############################
sub getContenuHTTP
{
  ### Récupère l'argument de la fonction
  my $url   = $_[0];
  
	my $requete = HTTP::Request->new('GET', $url);
	my $response = $ua->request($requete);
	my $contenu;
	if ($response->is_success == 1)
	{
	  $contenu = $response->content;
	}
	else
	{
	  Logger ("Probleme lors de la recuperation de l'URL : <$requete>, erreur : " . $response->code . "\n");
    $contenu = "";
	}
  return $contenu;
}

####################################
### Récupére l'heure/date courante #
####################################
### Return : la date au format     #
###       "16:25:00 le 18/11/2003" #
####################################
sub Get_Time
{
  my $today = localtime;
  ### L'année n'est pas codée correctement, il faut ajouter 1900
  my $year = $today->year + 1900;
  ### le mois est codé sur [0..11]
  my $month = $today->mon + 1;
  my $date = sprintf("%02d:%02d:%02d le %02d/%02d/%04d", $today->hour, $today->min, $today->sec, $today->mday, $month, $year);
  return $date;
}

####################################
### Récupére l'heure/date courante #
####################################
### Return : en millisecondes      #
####################################
sub getDateAsLong
{
  my ($seconds, $microseconds) = gettimeofday;
  ### On récupère les millisecondes sur 3 chiffres : 41ms --> 041
  my $millis = sprintf("%03d",int($microseconds/1000));
	return $seconds.$millis;
}

##############################
### Logger                   #
##############################
### Param 1 : texte à loguer #
##############################
sub Logger
{
  print $_[0]."\n";
}




