import 'package:flutter/material.dart';

import 'package:moodrn/utilities/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this entry?',
    optionsBuilder: () => {
      'No': false,
      'Yes': true
    }
  ).then(
    (value) => value ?? false
  );
}