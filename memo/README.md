#  todo list con centralizzazione dello stato

Questa cartella di progetto contiene il codice sorgente di un'applicazione [ToDo List](https://gitlab.com/divino.marchese/flutter/-/tree/master/am032_todo_list) scritta in Flutter, che utilizza il pattern `provider` per centralizzare lo stato dell'applicazione. 

Il **provider** consente di gestire le modifiche allo stato dell'applicazione in un solo luogo e di comunicare queste modifiche a tutti i widget che ne hanno bisogno.


## Dettagli implementativi
La classe principale dell'applicazione è `MyApp`, che utilizza `ChangeNotifierProvider` per fornire un'istanza di `TodoProvider` a tutti i widget figli. Il widget `MyHomePage` rappresenta la pagina principale dell'applicazione e utilizza il provider per accedere all'elenco di to-do. Quando viene effettuata una modifica allo stato, come l'aggiunta di un nuovo elemento, il provider invia una notifica a tutti i widget che dipendono da esso, in modo che possano essere aggiornati in tempo reale.

La classe `TodoProvider` estende `ChangeNotifier` e contiene la logica per gestire l'elenco di to-do. Troviamo i metodi per aggiungere, modificare e eliminare gli elementi dall'elenco, e notifica i widget interessati quando lo stato cambia.

## Codice significativo

Come detto in precedenza il codice significativo si può trovare nella classe `TodoProvider`, dove grazie andiamo ad agire sulla logica (mostrato metodo per aggiungere) e andiamo a notificare tutti i widget in ascolto del cambiamento
```dart
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }
  ....
}  
```

oppure all'interno del widget `MyHomePage` dove, nei vari metodi per gestire le note (**_handleTodoChange**, **_handleTodoDelete**, **_addTodoItem**), accediamo al provider nell'ambito del contesto corrente. Interessante notare come con l'attributo  `listen` impostato a *false* non è necessario aggiornare l'interfaccia utente quando lo stato del provider cambia.

```dart
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo); //_handleTodoDelete
    Provider.of<TodoProvider>(context, listen: false).toggleTodo(todo); // _handleTodoChange
    Provider.of<TodoProvider>(context, listen: false).addTodo(Todo(name: name, checked: false)); //_addTodoItem

```

## Scelte personali

La centralizzazione dello sato poteva avvenire in diverse maniere grazie ai vari *patter* che ci vengono in aiuto. Ho deciso di usare il pattern del *provider* perchè oltre a essere risultato il più facile da applicare, è quello con cui si riesce ad avere una più chiara visione del codice grazie alla sua non complicata implementazione

## Riferimenti

[Applicazione preimpostata](https://gitlab.com/divino.marchese/flutter/-/tree/master/am032_todo_list)

[Provider](https://www.youtube.com/watch?v=L_QMsE2v6dw&ab_channel=BenjaminCarlson)
