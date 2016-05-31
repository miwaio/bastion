#!/bin/bash
trap '' INT TSTP 0 1 2 5 15
let i=0 # define counting variable
W=() # define working array

Z=()
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$

while read  nom description commande; do # process file by file
    let i=$i+1
    W+=("$i $nom" "$description")
    Z+=("$i")
done < config

file="/root/tmp/config"
FILE=$(dialog   --backtitle "Netunicum Bastion Service"  --title "Vers quel host souhaitez-vous vous connecter?" --cancel-label "Quitter" --ok-label "Connexion" --menu "Valider votre choix" 24 80 17 "${W[@]}" 3>&2 2>$fichtemp 1>&3)
valret=$?
DIALOG_CANCEL=1
DIALOG_ESC=255
case $exit_status in
    $DIALOG_CANCEL)

      echo "Program terminated."

      ;;
    $DIALOG_ESC)

      echo "Program aborted." >&2

      ;;
  esac
choix=` awk '{ printf $1; }' $fichtemp`


if [[ $choix -gt 0 ]]; then
commande=`awk   'NR == st{print $3}' st="${choix}"  $file`
clear
/usr/local/bin/asciinema -q rec ~/logs/$USER.logfile.`date "+%F.%H-%M-%S"` -c "ssh $commande"
else
clear
echo "Connection finished"
fi
