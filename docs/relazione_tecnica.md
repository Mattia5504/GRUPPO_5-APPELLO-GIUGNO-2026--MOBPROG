# Relazione tecnica - PlanEat

## 1. Descrizione dell'app

PlanEat e una mobile app Flutter per gestire ricette, dispensa, pianificazione pasti e lista della spesa. L'obiettivo e aiutare studenti, famiglie o utenti singoli a ridurre sprechi, organizzare la settimana e capire cosa cucinare con gli ingredienti gia disponibili.

Gli scenari d'uso principali sono: consultare ricette salvate, controllare cosa sta per scadere, pianificare pasti settimanali, generare automaticamente la spesa e visualizzare statistiche sintetiche.

## 2. Requisiti

Funzionalita implementate:

- CRUD ricette con ingredienti dinamici.
- CRUD dispensa con scadenze e soglie low stock.
- Planner settimanale con quattro slot pasto.
- Lista spesa manuale e automatica.
- Suggerimento ricette in base alla dispensa.
- Dashboard e statistiche con grafici.
- Dati seed iniziali per demo.

Funzionalita considerate ma non implementate:

- Login utente.
- Sincronizzazione cloud.
- Barcode scanner.
- Conversioni automatiche tra unita di misura.
- API esterne per ricette.

Feature avanzate scelte:

- Generazione automatica della lista spesa dal meal plan.
- Ricette suggerite in base agli ingredienti disponibili.
- Monitoraggio scadenze e prodotti in esaurimento.
- Grafici statistici con fl_chart.

Limitazioni note:

- Il confronto ingredienti richiede stesso nome normalizzato e stessa unita.
- I dati sono locali al dispositivo.
- Non c'e gestione multiutente.

## 3. Progettazione dell'app

La struttura e modulare: `models` contiene gli oggetti dominio, `data` contiene database e repository, `state` contiene AppState, `ui` contiene schermate e widget riutilizzabili.

Schermate principali:

- Dashboard.
- Ricette.
- Dispensa.
- Planner.
- Lista spesa.
- Statistiche.

Flusso navigazione:

- `MainShell` usa `NavigationBar` Material 3.
- Schermate secondarie usano `Navigator.push`, `Navigator.pop` e `MaterialPageRoute`.
- Form e dettagli ricevono dati tramite costruttore.

Organizzazione dati:

- `recipes`: dati principali delle ricette.
- `recipe_ingredients`: ingredienti legati a una ricetta.
- `pantry_items`: prodotti disponibili.
- `meal_plan_entries`: pasti pianificati.
- `shopping_items`: elementi lista spesa.

Schema database testuale:

```text
recipes 1---N recipe_ingredients
recipes 1---N meal_plan_entries
pantry_items indipendente
shopping_items indipendente, generato o manuale
```

## 4. Scelte tecnologiche

Flutter consente un'app mobile multipiattaforma con UI moderna. Provider e ChangeNotifier sono stati scelti per una gestione stato semplice da spiegare all'orale. SQLite tramite sqflite garantisce persistenza locale senza backend. Material 3 fornisce componenti moderni e coerenti. intl gestisce date e formattazione. fl_chart permette grafici leggibili per la sezione statistiche.

## 5. Implementazione

Il codice e organizzato per responsabilita. Le schermate non contengono SQL: comunicano con `AppState`, che usa `AppRepository`, che usa `AppDatabase`.

Gestione stato:

- `AppState.initialize()` crea seed data se il database e vuoto.
- `loadAll()` ricarica ricette, ingredienti, dispensa, planner e spesa.
- Dopo ogni modifica persistente, il repository aggiorna SQLite, lo stato ricarica i dati e notifica la UI.

Persistenza:

- `AppDatabase` e un Singleton.
- Abilita `PRAGMA foreign_keys = ON`.
- Crea tabelle con vincoli `ON DELETE CASCADE` e `ON DELETE SET NULL`.

Generazione lista spesa:

- Considera solo pasti della settimana corrente.
- Somma gli ingredienti delle ricette pianificate.
- Confronta nome normalizzato e unita con la dispensa.
- Crea elementi automatici solo per quantita mancanti.
- Non rimuove elementi manuali.

Suggerimento ricette:

- Calcola il rapporto tra ingredienti disponibili e ingredienti totali.
- Ordina le ricette migliori e mostra badge comprensibili.

Gestione scadenze:

- Scaduto se data minore di oggi.
- In scadenza entro 3 giorni.
- Da consumare entro 7 giorni.
- OK oltre 7 giorni.
- Nessuna scadenza se data assente.

## 6. Conclusioni

PlanEat raggiunge l'obiettivo di essere una demo completa e coerente: mostra dati iniziali, CRUD reali, persistenza locale, navigazione, form validati e feature avanzate integrate. Sviluppi futuri possibili includono conversioni tra unita, notifiche locali, scanner barcode e sincronizzazione cloud opzionale.
