#  Journey
Questa cartella di progetto contiene il codice sorgente dell'applicazione Journey.
L'applicazione consente di efettuare le seguenti azioni:
 -  Creare dei trip, ossia degli insiemi di stop.
 -  Aggiungere stop, ossia dei luoghi in una mappa, ai trip.
 -  Visualizzare tutti i trip con il relativo meteo di ogni stop.
 -  Visualizzare la strada del trip, ossia il collegato tra i suoi stop.

Journey è stata implementata utilizzando **SQLite** e **floor**, e con la centralizzazione dello stato del *dao*

## Analisi database
Dal momento che ogni Trip può essere popolato da più Stop e uno Stop può avere più Trip tra questi due elementi vi è un legame molti a molti.
Per risolvere questo problema introduciamo una tabella di supporto(TripStop) che fa da il collegamento tra i due.

Uno **Stop** viene identificato dalla posizione sulla mappa (latitudine e longitudine), id (PK), nome e delle informazioni aggiuntive opzionali

Attraverso l'id dello Stop ci colleghiamo alla tabella **TripStop**, che contiene i riferimenti alle entità *Trip* e *Stop* (definite come ForeignKey), un id e un intero che indica la posizione all'interno del Trip. Infatti ogni Stop può assumere posizioni diverse in Trip diversi e può essere spostato a descrizione dell'utente.
```dart
@Entity(
  tableName: 'TripStop',
  foreignKeys: [
    ForeignKey(
      childColumns: ['trip_id'],
      parentColumns: ['id'],
      entity: Trip,
    ),
    ForeignKey(
      childColumns: ['stop_id'],
      parentColumns: ['id'],
      entity: Stop,
    )
  ],
)
class TripStop {
  TripStop(this.id, {required this.tripId, required this.stopId, required this.position});

  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'trip_id')
  final int tripId;

  @ColumnInfo(name: 'stop_id')
  final int stopId;

  int position;
}

```

Infine vi è l'entià **Trip** che è contraddistinta da un id, da un nome e dalla data dell'ultima modifica.
Quest'ultimo dato viene salvato come stringa poichè non vi è la possibilatà di salvarlo come tipo DataTime.

## Centralizzazione dello stato

La centralizzazione dello stato è efettuata sul dao attraverso l'utilizzo del pattern Provider, che consente di gestire lo stato dell'applicazione in modo centralizzato e condiviso tra tutti i widget.

Il provider viene creato nel metodo build della classe MyApp, passando come parametro il database.

```dart
    return ChangeNotifierProvider(
        create: (_) => TripStopProvider(database),
        child: MaterialApp(
          title: 'Journey',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: MyHomePage(
            title: 'Journey',
          ),
        ));
```

La classe `TripStopProvider` fornisce un'interfaccia per accedere ai metodi per ottenere, inserire, aggiornare e eliminare i dati sui viaggi e le fermate dal database utilizzando i *DAO* corrispondenti. 
```dart
class TripStopProvider extends ChangeNotifier {
  late TripDao _tripDao;
  late StopDao _stopDao;
  late TripStopDao _tripStopDao;

  TripStopProvider(AppDatabase database) {
    _tripDao = database.tripDao;
    _stopDao = database.stopDao;
    _tripStopDao = database.tripStopDao;
  }

// TripDao
  Future<List<Trip>> getAllTrips() async {
    return _tripDao.getAllTrips();
  }
.....
}
```

## GoogleMaps
Google maps è stato implementato nell'applicazione per gestire l'interazione utente-trip.
Utilizzo la libreria *google_maps_flutter* per visualizzare la mappa e la libreria *flutter_polyline_points* per disegnare le linee di percorso tra le diverse tappe del viaggio.

Il widget crea una mappa di e una serie di marker per ogni tappa del viaggio. 
I marker sono delle icone sulla mappa che identificano gli stop, ognuna di queste icone ha associato un nome e delle info aggiuntive(quelle dello stop)
```dart
  Future<void> _loadPoints() async {
    List<Stop> stops = await tripStopProvider.getStopsByTripId(widget.trip.id!);
    for (int i = 0; i < stops.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position:
            LatLng(stops.elementAt(i).latitude, stops.elementAt(i).longitude),
        infoWindow: InfoWindow(
            title: stops.elementAt(i).name,
            snippet: "info: ${stops.elementAt(i).info}"),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      ....
    }
    points =
        stops.map((stop) => LatLng(stop.latitude, stop.longitude)).toList();
  }

```


Inoltre, permette all'utente di selezionare una modalità di trasporto (in auto, a piedi o con i mezzi pubblici) tramite un menu a tendina. Il cambio della modalità di trasporto viene gestita nel metodo 
```dart
  Future<void> _onTransportModeChanged(Icon? mode) async {
    if (mode != null) {
      final int index = transportIcons.indexOf(mode);
      print(index);
      print(transportModes[index]);
      String transport = transportModes[index];
      setState(() {
        selectedTransportMode = TravelMode.values
            .firstWhere((element) => element.toString() == transport);
        _loadPoints();
      });
    }
  }

```

### Polylines

Come detto in precedenza per visualizzare il percorso tra i vari stop utilizziamo la libreria *flutter_polyline_points* che ci permette di creare varie polyline.

Di seguito possiamo vedere il metodo di creazione delle **polyline**.
```dart
  addPolyLine(List<LatLng> polylineCoordinates, polylineIdVal) {
    PolylineId id = PolylineId(polylineIdVal);
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 116, 167, 255),
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    if (mounted) {
      setState(() {});
    }
  }

```

## PlacePicker
Per la selezione degli stop viene utilizzato il widget *PlacePicker* che consente all'utente di selezionare un luogo sulla mappa utilizzando l'API Google Places. 

In particolare, il *PlacePicker* permette all'utente di cercare una posizione specifica o semplicemente di selezionare un punto sulla mappa. Quando l'utente seleziona un luogo, il PlacePicker restituisce un oggetto Place, che contiene informazioni come il nome, l'indirizzo e le coordinate geografiche del luogo selezionato.

```dart
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("API-KEY-GOOGLE")));

    var existingStop = await tripStopProvider.getStopByName(result.name!);

    if (existingStop == null) {
      var newStop = Stop(
        null,
        latitude: result.latLng!.latitude,
        longitude: result.latLng!.longitude,
        name: result.name!,
        info: null,
      );
      ..... 
    } else {
      ..... 
    }
  }

```

Nel metodo `showPlacePicker()` utilizziamo il *PlacePicker*. Possiamo notare ome il risultato ritornato è subito applicabile al nostro stop senza molti cambiamenti del dato rendendo molto fluida l'operazione. 

## Open weather map
Per fornire una maggiore usabilità dell'applicazione è stata inserita un'indicazione sulle "condizioni metereologiche" in ogni stop.

Per fare ciò sono state usate le API di `OpenWeatherMap` e ogni volta viene inviata una richiesta HTTP GET all'API con le coordinate geografiche specificate. La risposta viene quindi decodificata dal formato JSON e le informazioni relative all'icona del tempo e alla sensazione termica vengono estratte. 

```dart
  static Future<String?> getStopWeather(
      double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=API-KEY';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (....) {
      return "${data['weather'][0]["icon"]}:${data['main']["feels_like"]}";
    } else {
      return null;
    }
  }

```
Una volta estratte le informazioni possiamo già mostrare la temperatura percepita ma per ottenere l'icona dobbiamo ricavarla attraverso l'url ricavato dalla risposta precedente.

```dart
iconUrl != null ? Image.network("http://openweathermap.org/img/wn/$iconUrl@2x.png",height: 24): Container(),

```

## Schermate
![home](https://i.ibb.co/jMw6HdC/imageedit-4-4513365385.jpg)![show trip](https://i.ibb.co/0rvzsLC/imageedit-6-2818824815.jpg)
## Riferimenti

[Place Picker](https://github.com/blackmann/locationpicker/blob/master/example/example.dart)

[Open Weather Map](https://openweathermap.org/)

[Polylines](https://www.fluttercampus.com/guide/247/draw-route-direction-polylines-google-map/)

