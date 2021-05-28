import 'package:aprendizagem/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:aprendizagem/helpers/database_helper.dart';

class ContactList extends StatefulWidget {
  ContactList({Key key, this.titulo}) : super(key: key);

  final String titulo;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _formkey = new GlobalKey<FormState>();

  static DatabaseHelper banco;

  int sizeList = 0;
  List<Contact> contactList;

  @override
  void initState() {
    super.initState();
    //intanciamos o banco
    banco = new DatabaseHelper();

    //chamamos o metodo para inicilalizar o nosso banco
    banco.inicializaBanco();

    //chamamos a função para retornar a lista de contato do banco
    getContactList();
  }

  Future<void> getContactList() async {
    Future<List<Contact>> contactList = banco.getListContact();

    contactList.then((newContactList) {
      //chamamos o setState para alterar o estado da lista com os novos valores
      setState(() {
        this.contactList =
            newContactList; //aqui pegamos os resultados do banco e atribuir os a nossa variavel local
        this.sizeList = newContactList
            .length; // aqui passamos o tamanho da nossa lista a nossa variavel local
      });
    });
  }

  //uma função para carregar a nossalista de contato
  _carregarList() {
    //criamos um objeto do banco novamente
    banco = new DatabaseHelper();

    //inicializamos o banco novamente
    banco.inicializaBanco();
    //pego os novos regitros do nosso banco, caso haja
    Future<List<Contact>> noteListFuture = banco.getListContact();

    noteListFuture.then((newContactList) {
      //com o setState estamos atualizando o estado da nossa lista
      setState(() {
        this.contactList =
            newContactList; //aqui atribuo os novos valores para a nossa variavel local

        this.sizeList = newContactList
            .length; //aqui atribuo o tamanho da lista para a nossa variavel local
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: _contactList(), //Não foi implementado ainda
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addContact(); //Não foi implementado ainda
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _removeContact(Contact contact, int index) {
    setState(() {
      contactList = List.from(contactList)..removeAt(index);

      banco.apagar(contact.id);

      sizeList = sizeList - 1;
    });
  }

  void _addContact() {
    _email.text = '';
    _name.text = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('New contact'),
            content: new Container(
              child: new Form(
                key: _formkey,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    campoDeNome(),
                    Divider(
                      color: Colors.transparent,
                      height: 20.0,
                    ),
                    campoDeEmail(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new TextButton(
                  child: new Text("Save"),
                  onPressed: () {
                    Contact _contact;
                    if (_formkey.currentState.validate()) {
                      _contact = new Contact(_name.text, _email.text);

                      banco.inserirContact(_contact);

                      _carregarList();
                      _formkey..currentState.reset();

                      Navigator.of(context).pop();
                    }
                  })
            ],
          );
        });
  }

  void _atualizaContact(Contact contact) {
    _email.text = contact.email;
    _name.text = contact.name;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Atualizar contato'),
            content: new Container(
              child: new Form(
                  key: _formkey,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      campoDeNome(), //para implementar
                      Divider(
                        color: Colors.transparent,
                        height: 20.0,
                      ),
                      campoDeEmail()
                    ],
                  )),
            ),
            actions: <Widget>[
              TextButton(
                  child: new Text("Atualizar"),
                  onPressed: () {
                    Contact _contact;

                    if (_formkey.currentState.validate()) {
                      _contact = new Contact(_name.text, _email.text);

                      banco.atualizarContact(_contact, _contact.id);

                      _carregarList();

                      _formkey.currentState.reset();

                      Navigator.of(context).pop();
                    }
                  })
            ],
          );
        });
  }

  Widget campoDeNome() {
    return TextFormField(
      controller: _name,
      keyboardType: TextInputType.text,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return 'Campo Obrigatório';
        }
      },
      decoration: new InputDecoration(
        hintText: 'Name',
        labelText: 'Nome Completo',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget campoDeEmail() {
    return TextFormField(
      controller: _email,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return 'Campo Obrigatório';
        }
      },
      decoration: new InputDecoration(
        hintText: 'Email',
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _contactList() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sizeList,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              title: Text(contactList[index].name),
              subtitle: Text(contactList[index].email),
              leading: CircleAvatar(
                child: Text(contactList[index].name[0]),
              ),
            ),
            onLongPress: () => _atualizaContact(contactList[index]),
            onTap: () => _removeContact(contactList[index], index),
          );
        });
  }
}
