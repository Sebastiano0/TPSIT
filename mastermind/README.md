# Mastermind

Questa cartella di progetto contiene il sorgente per il gioco [mastermind](https://it.wikipedia.org/wiki/Mastermind), un gioco di crittoanalisi nel quale bisogna indovinare una sequenza di colori data.

## Aggiunte personali

In aggiunta alle funzionalità base della [consegna](https://gitlab.com/zuclassroom2223/consegne/-/blob/main/flutter_01_mastermind.md) sono state aggiunte delle varianti:
 - Possibilità di creare una sequenza con un colore ripetuto più volte
 - Passare di avere la schermata in modalità bianca o nera


## Scelte implementative

Il codice appare suddiviso in: ``Appbar``, ``body`` e ``bottomNavigationBar``.

### bottomNavigationBar

In particolare viene utilizzata la ``bottomNavitationBar`` per ottenere animazioni già preimpostate, un'altro suo vantaggio è quello di ricevere di default l'indice dell'elemento del menù selezionato. Queste due funzionalità permettono di accorciare il codice e renderlo più pulito.

![Alt Text](https://github.com/Sebastiano0/TPSIT/blob/main/mastermind/assets/inserimento.gif)

Molto meno efficiente invece è la scelta di creare gli spazi nei quali inserire la combinazione come dei [checkbox](https://api.flutter.dev/flutter/material/Checkbox-class.html) perchè richiede molto più codice ed è lento, una scelta che sarebbe stata migliore era mettere dei [Icon Button](https://mui.com/material-ui/api/icon-button/).

### createArrays()

La funzione ``createArrays()`` genera le righe, quest'ultime vengono create dinamicamente quindi basta cambiare una variabile (rows) per avere più o meno possibilità di indovinare. Questa creazione dinamica, più inefficiente, è per garantire una aggiunta più facile di nuove features quali la possibilità di creare le righe a scelta dell’utente.
```dart
createArrays(rows) {
    checkboxValues.clear();
    resultVisibility.clear();
    enterVisibility.clear();
    borderContainerColor.clear();
    guessedSequence.clear();
    colorSequence.clear();
    for (int i = 0; i < rows; i++) {
      guessedSequence.add([
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      ]);
      colorSequence.add([
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      ]);
      for (int y = 0; y < 4; y++) {
        checkboxValues.add(false);
      }
      if (i != 0) {
        resultVisibility.add(false);
        borderContainerColor.add(Colors.transparent);
        enterVisibility.add(false);
      } else {
        resultVisibility.add(false);
        borderContainerColor.add(Colors.green);
        enterVisibility.add(true);
      }
    }
}
```
Tale funzione così dispendiosa viene invocata solo all'inizio del gioco, o nel caso di scelta di righe dell'utente, quando questo valore viene cambiato. **Non** viene chiamata ogni qual volta si rinizia una partita, per questo esiste la funzione che resetta le variabili:
```dart
resetVariables() {
    for (int i = 0; i < 40; i++) {
      checkboxValues[i] = false;
      if (i < 10) {
        if (i == 0) {
          enterVisibility[i] = true;
          borderContainerColor[i] = Colors.green;
        } else {
          enterVisibility[i] = false;
          borderContainerColor[i] = Colors.transparent;
        }
        resultVisibility[i] = false;
      }
    }
  }
 ```

### setState()


Essendo impossibile chiamare il metodo ``setState()`` all'interno della classe in cui viene chiamato il metodo ``resetVariables()`` per fare in modo che ci sia un aggiornamento dello stato senza interazione ad parte dell'utente passo a tale classe un metodo della classe padre che aggiorna appunto lo stato.

```dart
void reset() {
    setState(() {});
}
```
### Light mode
Per creare la light mode, e di conseguenza poi la dark mode esiste un metodo che cambia il colore principale e quello secondario da nero/bianco a bianco/nero e contrario, compresi quelli già inseriti di modo che rimangano visibili una volta che la modalità viene cambiata.
Il metodo ``lightMode()``, analogo a ``darkMode()`` tranne per il colore:

```dart
lightMode() {
    mainColor = Colors.white;
    secondaryColor = Colors.black;
    colors[5] = Colors.black;
    lightModeOn = true;
    lastBackgroundColorBottomNavigation = Colors.grey.shade900;
    changeColorAlreadySet(Colors.white, Colors.black);
 }
```

Con la classe ``AbsorbPointer()`` si impedisce di modificare le combinazioni già date, o future. 

## Riferimenti
[BottomNavigationBar](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html)

[Checkbox](https://api.flutter.dev/flutter/material/Checkbox-class.html)

[IconButton](https://api.flutter.dev/flutter/material/IconButton-class.html)

[AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html)

[setState](https://api.flutter.dev/flutter/widgets/State/setState.html)

[ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html)

[Row](https://api.flutter.dev/flutter/widgets/Row-class.html)

[Cookbook](https://docs.flutter.dev/cookbook)

[Basic widgets](https://docs.flutter.dev/development/ui/widgets/basics)

[Column](https://api.flutter.dev/flutter/widgets/Column-class.html)

[Add images/gif](https://docs.flutter.dev/development/ui/assets-and-images)

[AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)

[Visibility](https://api.flutter.dev/flutter/widgets/Visibility-class.html)

[AbsorbPointer](https://api.flutter.dev/flutter/widgets/AbsorbPointer-class.html)
