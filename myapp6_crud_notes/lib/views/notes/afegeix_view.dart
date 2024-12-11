import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/JsonModels/note_model.dart';
import 'package:sqlite_flutter_crud/persistencia/dbhelper.dart';
import 'package:sqlite_flutter_crud/settings/constants_view.dart';
import 'package:sqlite_flutter_crud/views/notes/common_controls_view.dart';

//import '../../settings/constants_view.dart';



class Afegeix extends StatefulWidget {
  const Afegeix({super.key});

  @override
  State<Afegeix> createState() => _AfegeixState();
}

class _AfegeixState extends State<Afegeix> {
  //final textEditingControllerTitol = TextEditingController();
  //final textEditingControllerContingut = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final commonControlsView = CommonControlsView();
  final databaseHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantsView.LABEL_AFEGIR_NOTA),
        actions: [
          _getSaveIconButton(),
        ],
      ),
      body: Form(
        //I forgot to specify key
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                commonControlsView.getTextFormFieldTitol(
                    ConstantsView.LABEL_NOTA_TITOL, commonControlsView.textEditingControllerTitol),
                commonControlsView.getTextFormFieldContingut(
                    (ConstantsView.LABEL_NOTA_CONTINGUT), commonControlsView.textEditingControllerContingut),
              ],
            ),
          )),
    );
  }

  IconButton _getSaveIconButton() {
    return IconButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            databaseHelper
                .createNote(NoteModel(
                noteTitle: commonControlsView.textEditingControllerTitol.text,
                noteContent: commonControlsView.textEditingControllerContingut.text,
                createdAt: DateTime.now().toIso8601String()))
                .whenComplete(() {
              Navigator.of(context).pop(true);
            });
          }
        },
        icon: Icon(Icons.save));
  }
}


