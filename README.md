# PUT_SO1_Czekanie-na-zmiany

Skrypt obserwuje stronę internetową i informuje kiedy pojawią się na niej zmiany.

Użytkownik podaje listę stron internetowych przez argumenty, lub zapisuje je w pliku (każda strona w osobnej lini) i podaje przez parametr. Skrypt ściąga na dysk każdą z tych stron. Następnie skrypt odczekuje 10 minut, ściąga każdą ze stron kolejny raz i porównuje nową wersję ze starą. Jeśli między wersjami stron są różnice to strona jest pokazywana użytkownikowi w przeglądarce, a skrypt znowu odczekuje 10 minut, poczem znowu sprawdza strony itp.

Użytkownik może poprzez parametry zmienić czas między sprawdzaniem stron. Może także przez parametry zmienić przeglądarkę używaną do otwarcia strony i wyspecyfikować, żeby skrypt został zakończony przy wykryciu pierwszej zmiany. Użytkownik może także wyspecyfikowac przez parametry żeby zamiast wyśiwetlać stronę w przeglądarce informacja o znalezieniu zmian została zapisana do pliku logu (dziennika) lub na ekran.

Skrypt wyświetla pomoc (wszystkie parametry i ich objaśnienia) jeśli użytkownik poda parametr -h.


