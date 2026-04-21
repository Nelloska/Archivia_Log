*** INTRODUZIONE ***
Il seguente tool permette, data una lista di applicativi presenti nel file "list_APP.txt", di archiviare i logs in un file .zip per ogni giorno e per ogni applicativo secondo la nomenclatura "[DataLog]_Applicazione_n.zip",
generando al termine un report sull'esito dell'archiviazione.
!!! IMPORTANTE !!!  - I nomi presenti in "list_APP.txt" devono coincidere ocn i nomi presenti nella propria cartella di log che si vuole archiviare -
Il tool permette di customizzare delle variabili quali la data di creazione dei zip e conservazione degli stessi, 
inoltre permette sia la gestione in automatico, previa messo nei task schedulati di windows, sia in modalità manuale da invocare all'occorrenza


*** MODALITA' AUTOMATICA *** 
(da mettere nei task schedulati di windows il bat 
	Archive_Log.bat
in base all'orario più opportuno, si consiglia di notte in fasce orarie scariche)

aprire con editor di testo il file 
	Archive_Log.bat 
e settare opportunamento le variabili :
	set ArchiveAge=60						//è il tempo, in giorni, in cui conservi i log zippati sul disco, es. i log di 61 giorni fa vengono eliminati
	set LogfileAge=1						//è il tempo, in giorni, in cui i log in memoria senza zipparli, es. i log di due giorni fa vengono zippati
	set Workpath=C:\Support\Archive_Log		//è il path dove si trova il tool "Archive_Log"
	set LogPath=C:\APP\LOG					//è il path dove gli applicativi scrivono il log
	mkdir %Workpath%\Report					//è il path dove Archive_Log scrive il report di esecuzione, il tool storicizza tutti i report


*** MODALITA' MANUALE *** 
da lanciare in manuale da prompt nella sua cartella con comando (es. da 12 giorni a 2 giorni fa) :

for /L %N IN (12,-1,2) DO Archive_Log_manuale.bat %N