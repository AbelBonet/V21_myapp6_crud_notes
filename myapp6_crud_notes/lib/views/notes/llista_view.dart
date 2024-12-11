import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';
import 'package:sqlite_flutter_crud/persistencia/dbhelper.dart';
import 'package:sqlite_flutter_crud/settings/constants_view.dart';
import 'package:sqlite_flutter_crud/Views/Notes/afegeix_view.dart';
import 'package:sqlite_flutter_crud/views/notes/common_controls_view.dart';

class Llista extends StatefulWidget {
  const Llista({super.key});

  @override
  State<Llista> createState() => _NotesState();
}

class _NotesState extends State<Llista> {
  late DatabaseHelper databaseHelper;
  late Future<List<NoteModel>> llistaNotes;

  final commonControlsView = CommonControlsView();
  final searchTextEditingController = TextEditingController();

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    llistaNotes = databaseHelper.getNotes();

    databaseHelper.initDB().whenComplete(() {
      llistaNotes = getAllNotes();
    });
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return databaseHelper.getNotes();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<NoteModel>> searchNote() {
    return databaseHelper.searchNotes(searchTextEditingController.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      llistaNotes = getAllNotes();
    });
  }

  AppBar _getAppBar(String pTitolAppBar) {
    return AppBar(
      title: Text(pTitolAppBar),
    );
  }

  FloatingActionButton _getAfegeixView() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Afegeix()))
            .then((value) {
          if (value) {
            _refresh();
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Container _getCercador() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: searchTextEditingController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              llistaNotes = searchNote();
            });
          } else {
            setState(() {
              llistaNotes = getAllNotes();
            });
          }
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: ConstantsView.LABEL_CERCAR),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(ConstantsView.LABEL_LLISTA_NOTES_TITOL),
        floatingActionButton: _getAfegeixView(),
        body: Column(
          children: [
            //Search Field here
            _getCercador(),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: llistaNotes,
                builder: (BuildContext context,
                    AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(child: Text(ConstantsView.MESSAGE_SENSE_DADES));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <NoteModel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(items[index].noteTitle),
                            subtitle: Text(DateFormat("yMd").format(
                                DateTime.parse(items[index].createdAt))),
                            trailing: _getDeleteIcon(items, index),
                            onTap: () {
                              _updateEnvironment(items, index);
                            },
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }

  IconButton _getDeleteIcon(List<NoteModel> items, int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        databaseHelper.deleteNote(items[index].noteId!).whenComplete(() {
          _refresh();
        });
      },
    );
  }

  void _updateEnvironment(List<NoteModel> items, int index) {
    //When we click on note
    setState(() {
      commonControlsView.textEditingControllerTitol.text =
          items[index].noteTitle;
      commonControlsView.textEditingControllerContingut.text =
          items[index].noteContent;
    });
    showDialog(
        context: context,
        builder: (context) {
          return _getAlertDialogUpdate(items, index);
        });
  }

  AlertDialog _getAlertDialogUpdate(List<NoteModel> items, int index) {
    return AlertDialog(
      title: Text(ConstantsView.LABEL_CANVIAR_TITOL),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        commonControlsView.getTextFormFieldTitol(
            ConstantsView.LABEL_NOTA_TITOL, commonControlsView.textEditingControllerTitol),
        commonControlsView.getTextFormFieldContingut(
            (ConstantsView.LABEL_NOTA_CONTINGUT), commonControlsView.textEditingControllerContingut),
      ]),
      actions: [
        Row(
          children: [
            _getTextButtonCanviar(items, index),
            _getTextButtonCancel(),
          ],
        ),
      ],
    );
  }

  TextButton _getTextButtonCanviar(List<NoteModel> items, int index) {
    return TextButton(
      onPressed: () {
        databaseHelper
            .updateNote(
                commonControlsView.textEditingControllerTitol.text,
                commonControlsView.textEditingControllerContingut.text,
                items[index].noteId)
            .whenComplete(() {
          //After update, note will refresh
          _refresh();
          Navigator.pop(context);
        });
      },
      child: Text(ConstantsView.LABEL_CANVIAR_NOTA_OK),
    );
  }

  TextButton _getTextButtonCancel() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(ConstantsView.LABEL_CANVIAR_NOTA_CANCEL),
    );
  }
}
