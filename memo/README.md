#  todo list con centralizzazione dello stato

Questa cartella di progetto contiene il codice sorgente di un'applicazione [ToDo List](https://gitlab.com/divino.marchese/flutter/-/tree/master/am023_todo_list_floor) scritta in Flutter, che utilizza il pattern `provider` per centralizzare lo stato dell'applicazione. 

Il **provider** consente di gestire le modifiche allo stato dell'applicazione in un solo luogo e di comunicare queste modifiche a tutti i widget che ne hanno bisogno.

In particolare, il codice crea tre provider:

 - Provider<AppDatabase> per fornire l'istanza del database dell'applicazione a tutti i widget che ne hanno bisogno
 - ProxyProvider<AppDatabase, TodoDao> per fornire l'istanza del DAO (Data Access Object) per la tabella delle attività, utilizzando l'istanza del database fornita dal provider precedente.
- ChangeNotifierProvider<TodoModel> per fornire un oggetto TodoModel che gestisce lo stato delle attività dell'applicazione e notifica i widget che lo usano quando cambia lo stato.


## Dettagli implementativi
La classe principale dell'applicazione è `MyApp`, che utilizza `ChangeNotifierProvider` per fornire un'istanza di `TodoModel` a tutti i widget figli. Il widget `MyHomePage` rappresenta la pagina principale dell'applicazione e utilizza il provider per accedere all'elenco di to-do. Quando viene effettuata una modifica allo stato, come l'aggiunta di un nuovo elemento, il provider invia una notifica a tutti i widget che dipendono da esso, in modo che possano essere aggiornati in tempo reale.

La classe `TodoModel` estende `ChangeNotifier` e contiene la logica per gestire l'elenco di to-do. Troviamo i metodi per aggiungere, modificare e eliminare gli elementi dall'elenco, e notifica i widget interessati quando lo stato cambia. Inoltre si trova anche il metodo per inizializzare la connessione con il *dao*

Per consentire l'invio delle **notifiche** ho utilizzato il pacchetto *flutter_local_notifications* che consente di creare e inviare notifiche ad un momento preciso.
## Codice significativo

Come detto in precedenza il codice significativo si può trovare nella classe `TodoModel`, dove andiamo ad agire sulla logica (mostrato metodo di inizializzazione) e a notificare tutti i widget in ascolto del cambiamento
```dart
class TodoModel extends ChangeNotifier {
  late final TodoDao _dao;
  late List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> initialize(BuildContext context) async {
    _dao = Provider.of<TodoDao>(context, listen: false);
    _todos = await _dao.getTodos();
  }
  ....
}  
```

all'interno del widget `MyHomePage` dove, nei vari metodi per gestire le note (**_handleTodoChange**, **_handleTodoDelete**, **_addTodoItem**), accediamo al provider nell'ambito del contesto corrente. Interessante notare come con l'attributo  `listen` impostato a *false* non è necessario aggiornare l'interfaccia utente quando lo stato del provider cambia.

```dart
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo); //_handleTodoDelete
    Provider.of<TodoProvider>(context, listen: false).toggleTodo(todo); // _handleTodoChange
    Provider.of<TodoProvider>(context, listen: false).addTodo(Todo(name: name, checked: false)); //_addTodoItem

```

oppure dove creiamo le notifiche, nella classe `NotificationHelper`, nel suo metodo **scheduleNotification**:

All'interno del metodo, viene creato un oggetto *AndroidNotificationDetails*, che contiene i dettagli della notifica per la piattaforma Android, come il canale di notifica, la descrizione, l'importanza e il suono. Successivamente, viene creato un oggetto NotificationDetails che contiene i dettagli della notifica per tutte le piattaforme.
```dart
  Future<void> scheduleNotification({ .... }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'spesa_channel',
      'Notifiche Lista della spesa',
      channelDescription: 'Canale notifiche per la lista della spesa',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(sound),
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var now = DateTime.now();
    var scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    // Aggiunge la notifica alla lista delle notifiche programmate
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'It could be anything you pass',
    );
  }

```
Viene creato un oggetto *scheduledTime* che rappresenta l'ora e i minuti in cui la notifica verrà programmata utilizzando la libreria *timezone*. L'ora viene convertita in un formato tz.TZDateTime che tiene conto del fuso orario locale del dispositivo.

Infine, viene utilizzato il metodo *zonedSchedule* della libreria Flutter Local Notifications per aggiungere la notifica alla lista delle notifiche programmate, specificando l'ID univoco, il titolo, il corpo, l'ora programmata, i dettagli della notifica e il payload (un'informazione personalizzata che può essere passata con la notifica).
## Scelte personali

La centralizzazione dello sato poteva avvenire in diverse maniere grazie ai vari *patter* che ci vengono in aiuto. Ho deciso di usare il pattern del *provider* perchè oltre a essere risultato il più facile da applicare, è quello con cui si riesce ad avere una più chiara visione del codice grazie alla sua non complicata implementazione

## Riferimenti

[Applicazione preimpostata](https://gitlab.com/divino.marchese/flutter/-/tree/master/am032_todo_list)

[Provider](https://www.youtube.com/watch?v=L_QMsE2v6dw&ab_channel=BenjaminCarlson)

[Notifiche](https://pub.dev/packages/flutter_local_notifications/example)

