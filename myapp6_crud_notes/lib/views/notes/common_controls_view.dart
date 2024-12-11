import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/settings/constants_view.dart';

class CommonControlsView {
  final textEditingControllerTitol = TextEditingController();
  final textEditingControllerContingut = TextEditingController();

  TextFormField getTextFormFieldTitol(
      String pLabel, TextEditingController pController) {
    return TextFormField(
      controller: pController,
      validator: _validatorTextTitol,
      decoration: InputDecoration(
        label: Text(pLabel),
      ),
    );
  }

  TextFormField getTextFormFieldContingut(
      String pLabel, TextEditingController pController) {
    return TextFormField(
      controller: pController,
      validator: _validatorTextContingut,
      decoration: InputDecoration(
        label: Text(pLabel),
      ),
    );
  }

  String? _validatorTextTitol(String? pValue) {
    return _validatorTextString(ConstantsView.LABEL_NOTA_TITOL, pValue, false, 1, 20);
  }

  String? _validatorTextContingut(String? pValue) {
    return _validatorTextString(ConstantsView.LABEL_NOTA_CONTINGUT, pValue, false, 1, 100);
  }

  String? _validatorTextString(String pFieldName, String? pValue,
      bool pAdmitNull, int? pMinLength, int? pMaxLength) {
    String? result = null;

    if (!pAdmitNull) {
      if (pValue == null) {
        result = '$pFieldName ha d' 'estar informat';
      }
    }

    if (result == null) {
      if (pMinLength != null) {
        if (pValue != null && pValue.length < pMinLength) {
          result = '$pFieldName ha de tenir almenys $pMinLength caràcter/s';
        }
      }
    }

    if (result == null) {
      if (pMaxLength != null) {
        if (pValue != null && pValue.length > pMaxLength) {
          result =
              '$pFieldName ha de tenir una longitud màxima de $pMaxLength caràcter/s';
        }
      }
    }

    return result;
  }
}
