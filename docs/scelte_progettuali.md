# Scelte progettuali

## Stato applicativo

E stato usato Provider con ChangeNotifier per mantenere il progetto semplice, leggibile e coerente con un esame universitario di Mobile Programming. AppState rappresenta lo stato globale e centralizza operazioni CRUD e logiche derivate.

## Persistenza locale

SQLite con sqflite e stato scelto perche permette dati persistenti senza backend. La struttura repository evita SQL dentro le schermate e rende il flusso piu facile da spiegare.

## Navigazione

La navigazione principale usa `NavigationBar` Material 3. Le schermate secondarie usano `Navigator.push`, `Navigator.pop` e `MaterialPageRoute`, come richiesto.

## Generazione lista spesa

La generazione automatica lavora sulla settimana corrente e confronta ingredienti con nome normalizzato e stessa unita. Non sono state implementate conversioni kg/g o l/ml per mantenere una logica affidabile e spiegabile.

## UI

Il tema e centralizzato in `core/app_theme.dart`, con palette verde salvia, crema, verde scuro e ambra soft. Card, chip, badge e grafici mantengono un linguaggio visivo coerente con il tema alimentare.

## Seed data

Il database viene popolato al primo avvio con ricette, prodotti, meal plan e lista spesa. Questo evita una demo vuota e permette di mostrare subito le feature principali.
