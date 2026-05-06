# PlanEat — Meal Planner & Smart Pantry App

Progetto sviluppato per il corso di **Mobile Programming**.

L'applicazione è una soluzione mobile realizzata in **Flutter** per aiutare l'utente a gestire ricette, dispensa, pianificazione dei pasti e lista della spesa in modo integrato.

---

## Gruppo 5

| Ruolo | Nome |
|---|---|
| Portavoce | Mattia Letteriello |
| Membro | Jonathan Punzo |
| Membro | Valentino Potapchuk |
| Membro | Antonia Lamberti |

---

## Descrizione del progetto

**PlanEat** è un'applicazione di tipo **Meal Planner & Smart Pantry**.

L'obiettivo dell'app è permettere all'utente di:

- salvare e consultare ricette;
- gestire i prodotti disponibili in dispensa;
- pianificare i pasti della settimana;
- creare e aggiornare una lista della spesa;
- ricevere suggerimenti in base agli ingredienti disponibili;
- monitorare prodotti in esaurimento o vicini alla scadenza;
- visualizzare riepiloghi e statistiche sulle proprie abitudini alimentari.

L'app è pensata per funzionare anche senza backend remoto, usando dati locali e persistenti.

---

## Tecnologie utilizzate

- **Flutter**
- **Dart**
- **Provider** per la gestione dello stato globale
- **SQLite / sqflite** per la persistenza locale
- **path** per la gestione del percorso del database
- **intl** per la gestione e formattazione delle date
- **fl_chart** per grafici e statistiche
- **google_fonts** per la personalizzazione tipografica
- **Material Design 3** per l'interfaccia grafica

---

## Funzionalità principali

### Gestione ricette

L'app consente di:

- visualizzare l'elenco delle ricette;
- consultare il dettaglio di una ricetta;
- aggiungere nuove ricette;
- modificare ricette esistenti;
- eliminare ricette;
- associare ingredienti, quantità e unità di misura a ogni ricetta;
- filtrare o cercare ricette per nome, categoria e caratteristiche principali.

---

### Gestione dispensa

La sezione dispensa permette di:

- visualizzare i prodotti disponibili in casa;
- aggiungere nuovi ingredienti o prodotti;
- modificare quantità, categoria, unità di misura e data di scadenza;
- rimuovere prodotti;
- individuare prodotti in esaurimento;
- individuare prodotti scaduti o vicini alla scadenza.

---

### Pianificazione pasti

La sezione planner permette di organizzare i pasti della settimana.

Per ogni giorno è possibile associare:

- colazione;
- pranzo;
- cena;
- spuntino;
- ricette salvate;
- pasti personalizzati.

L'utente può aggiungere, modificare o rimuovere i pasti pianificati.

---

### Lista della spesa

La lista della spesa può essere gestita manualmente oppure generata automaticamente.

L'utente può:

- visualizzare gli elementi della lista;
- aggiungere prodotti manualmente;
- modificare quantità e unità di misura;
- eliminare elementi;
- segnare un prodotto come acquistato;
- generare la lista a partire dalle ricette pianificate.

---

## Feature avanzate implementate

### 1. Generazione automatica della lista della spesa

L'app analizza le ricette inserite nel meal plan e confronta gli ingredienti richiesti con quelli presenti in dispensa.

Se un ingrediente manca o la quantità disponibile è insufficiente, viene aggiunto automaticamente alla lista della spesa.

---

### 2. Suggerimento ricette in base alla dispensa

L'app valuta gli ingredienti disponibili e suggerisce le ricette più compatibili con la dispensa corrente.

Ogni ricetta può essere classificata, ad esempio, come:

- cucinabile subito;
- quasi pronta;
- mancante di alcuni ingredienti.

---

### 3. Gestione scadenze e prodotti in esaurimento

I prodotti della dispensa vengono controllati in base alla data di scadenza e alla soglia minima impostata.

L'app evidenzia:

- prodotti scaduti;
- prodotti vicini alla scadenza;
- prodotti da consumare presto;
- prodotti in esaurimento.

---

## Statistiche e riepiloghi

L'app include una sezione di riepilogo con informazioni utili, tra cui:

- numero totale di ricette salvate;
- numero di pasti pianificati nella settimana;
- prodotti vicini alla scadenza;
- prodotti in esaurimento;
- distribuzione delle ricette per categoria;
- tempo medio di preparazione delle ricette;
- prodotti mancanti rispetto alle ricette pianificate.

---

## Architettura del progetto

Il progetto è organizzato secondo una struttura modulare:

```text
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── app_constants.dart
│   ├── app_theme.dart
│   ├── date_utils.dart
│   ├── validators.dart
│   └── enums.dart
│
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── database_tables.dart
│   ├── repositories/
│   │   └── app_repository.dart
│   └── seed/
│       └── seed_data.dart
│
├── models/
│   ├── recipe.dart
│   ├── recipe_ingredient.dart
│   ├── pantry_item.dart
│   ├── meal_plan_entry.dart
│   ├── shopping_item.dart
│   └── dashboard_summary.dart
│
├── state/
│   └── app_state.dart
│
└── ui/
    ├── screens/
    │   ├── dashboard/
    │   ├── recipes/
    │   ├── pantry/
    │   ├── planner/
    │   ├── shopping/
    │   └── stats/
    │
    └── widgets/
