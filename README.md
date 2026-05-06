# PlanEat

**Meal Planner & Smart Pantry**

Progetto Flutter sviluppato per il corso di **Mobile Programming**.

PlanEat aiuta l'utente a organizzare ricette, dispensa, pasti settimanali e lista della spesa in un'unica app locale, senza backend remoto e senza login.

## Gruppo 5

| Ruolo | Nome |
|---|---|
| Portavoce | Mattia Letteriello |
| Membro | Jonathan Punzo |
| Membro | Valentino Potapchuk |
| Membro | Antonia Lamberti |

## Tecnologie

- Flutter e Dart
- Material Design 3
- Provider e ChangeNotifier
- SQLite locale con sqflite
- path per il percorso del database
- intl per date e formattazione
- fl_chart per grafici/statistiche
- google_fonts per la tipografia

## Funzionalita principali

- Dashboard con riepiloghi immediati su ricette, pasti, scadenze, low stock e lista spesa.
- CRUD ricette con ingredienti dinamici, filtri, ricerca e dettaglio.
- CRUD dispensa con scadenze, soglie minime, filtri rapidi e badge stato.
- Planner settimanale da lunedi a domenica con colazione, pranzo, cena e spuntino.
- Lista della spesa manuale e automatica.
- Suggerimento ricette in base agli ingredienti disponibili.
- Statistiche con grafici per categoria e ingredienti mancanti dal meal plan.

## Feature avanzate

### Lista spesa automatica

L'app analizza le ricette pianificate nella settimana corrente, somma gli ingredienti richiesti e li confronta con la dispensa. Se mancano ingredienti o la quantita disponibile e insufficiente, crea elementi automatici nella lista spesa con `source = "auto"`.

Gli elementi manuali non vengono cancellati. Prima di rigenerare, l'app sostituisce solo gli elementi automatici precedenti.

### Ricette suggerite

Ogni ricetta riceve un punteggio:

```text
availabilityScore = ingredienti disponibili / ingredienti totali
```

Classificazione:

- `1.0`: Cucinabile ora
- `>= 0.6`: Quasi pronta
- `< 0.6`: Mancano ingredienti

### Scadenze e low stock

La dispensa evidenzia prodotti:

- scaduti;
- in scadenza entro 3 giorni;
- da consumare entro 7 giorni;
- in esaurimento quando `quantity <= lowStockThreshold`.

## Installazione

```bash
flutter pub get
flutter run
```

Per controllo statico:

```bash
flutter analyze
```

## Architettura cartelle

```text
lib/
├── main.dart
├── app.dart
├── core/
├── data/
│   ├── database/
│   ├── repositories/
│   └── seed/
├── models/
├── state/
├── ui/
│   ├── screens/
│   └── widgets/
└── docs_helpers/

docs/
├── relazione_tecnica.md
├── slide_outline.md
├── diagramma_flusso.md
└── scelte_progettuali.md
```

## Demo flow consigliato

1. Aprire la Dashboard e mostrare dati seed gia presenti.
2. Mostrare prodotti in scadenza e ricette suggerite.
3. Aprire Ricette, cercare una ricetta, entrare nel dettaglio e mostrare disponibilita ingredienti.
4. Aggiungere o modificare una ricetta con ingredienti dinamici.
5. Aprire Dispensa, mostrare filtri scadenza/low stock e modificare una quantita.
6. Aprire Planner e aggiungere un pasto alla settimana corrente.
7. Aprire Spesa e premere "Genera da meal plan".
8. Aprire Statistiche dalla Dashboard.

## Limitazioni note

- Il confronto automatico degli ingredienti non converte unita diverse: funziona quando nome normalizzato e unita coincidono.
- Non sono presenti backend remoto, login o Firebase per scelta progettuale.
- I dati sono locali sul dispositivo tramite SQLite.
