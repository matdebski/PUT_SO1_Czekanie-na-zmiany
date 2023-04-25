#!/bin/bash
#Mateusz Debski nr indeksu: 148216
#projekt: 9. Czekanie na zmiany

time=600
browser=firefox

function helpop {
  echo
echo --------------------------Instrukcja---------------------------
echo przelanczniki:
echo "-t <wartosc w sekundach> |czasu miedzy sprawdzaniem"
echo "-b <nazwa przegladarki> |wybor przeglandarki"
echo "-f <sciezka do pliku>| wczytaj adresy  stron z pliku"
echo "-l <gdzie zapisac (folder)> |zapisuje do log nie otwiera przeglarki"
echo "-e | zakoncz przy wykryciu pierwszej zmiany"
echo "przyklad uzycia: ./projekt.sh -t 60 -b firefox www.google.com"
echo
}

while [[ -n "$1" ]]; do
case $1 in
  -t)
    time="$2"
    shift 2
    ;;
  -h)
    helpop
    exit 0
    ;;
  -b)
    browser="$2"
   shift 2
    ;;
  -f)
    file="$2"
   shift 2
   if [[ ! -a "$file" ]]; then
    echo "Nie znaleziono pliku o zadanej sciezce \"$file\""
    exit 1
   fi
    ;;
  -l)
    log="$2"
    if [[ ! -d "$log" ]]; then
      echo "Nie ma takiego folderu o zadanej sciezce \"$log\""
      exit 1
    fi
    log="$log"/logi
    touch "$log"
    shift 2
    ;;
  -e)
    e=1 # zakoncz jesli zmiana
    shift
    ;;
  -*)
    echo "Nieznany przelancznik  \"$1\""
    echo "Uzyj przelancznika \"-h\" aby zobaczyc instrukcje"
    exit 1
    ;;
  *)
    break
    ;;
esac
done


if [[ -n $file ]]; then
  #strony z pliku
  websites=$( cat "$file" | tr "\n" " ")
elif [[ -z $1 ]]; then
  echo "Nie podano argumentow,uzyj \"-h\" aby zobaczyc instrukcje"
  exit 1
else
  #strony jako argumenty
  websites="$*"
fi

path=/tmp/pobrane_strony
mkdir $path 2>/dev/null # folder na strony

#pobiera strony
for i in $websites; do
  #nazwa pliku nie moze zawierac "/"
  name=$( echo $i | tr "/" "_" )

wget -q -O "$path"/"$name" $i

if (( $? != 0 )); then
  echo "Strona \"$i\" jest niedostepna!Upewnij sie czy prawidlowo wpisales strone i czy masz polaczenie internetowe"
  rm -r $path
  exit 1
fi

done

#zaczyna sprawdzanie
while true; do
  
for i in $websites ; do
  
  name=$( echo $i | tr "/" "_" )
  
  if [[ ! -a "$path"/"$name" ]] ; then
    continue
  fi
  echo "[sprawdzam strone \"$i\"]!"  
  #pobiera strone do tmp w celu porownania
  wget -q -O "$path"/tmp $i

  if (( $? != 0 )) ; then
    echo "Strona \"$i\" jest niedostepna! Upewnij sie czy prawidlowo wpisales strone i czy masz polaczenie internetowe."
    rm -r $path
    exit 1
  fi
 
  #porownuje w przypadku roznic "diff" daje output dlatego przekierowanie
  diff -q "$path"/tmp "$path"/"$name" >/dev/null

  #status 0 brak zmian, !=0 zmiana
  if (( $? != 0)) ; then
    echo "Zmiana na stronie \"$i\"!"
    
    #jesli istieje zmianna log zapisuje do log
    if [[ -n $log ]] ; then
      date=$( date )
      echo "[$date] Zmiana na stronie \"$i\"!" >>"$log"
    else
      #jesli nie otwiera w wybranej przeglandarce
      "$browser" "$i" 2>/dev/null
      fi
    
      # jesli przelancznik -e wychodzi konczy prace
    if [[ -n $e ]] ; then
      rm -r "$path"
      exit 0
      fi
    
    #usuwa plik ze strona 
    rm "$path"/"$name"
  
    test=$( ls "$path" | wc -l )
    #sprawdza czy sa jeszcze jakies strony do sprawdzenia
    #takie na ktorych nie zaszla zmiana
    #jesli test==1 to w folderze jest tylko plik "tmp"
    if (( "$test" == 1 )); then
      echo "Na kazdej stronie zaszla zmiana"
      rm -r "$path"
      exit 0
    fi
  fi
done
sleep $time
done
