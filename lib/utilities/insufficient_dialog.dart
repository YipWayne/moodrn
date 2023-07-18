import 'package:flutter/material.dart';

import 'package:moodrn/utilities/generic_dialog.dart';

Future<void> showInsufficientDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Insufficient information',
    content: 'Please choose an emoji and at least one activity',
    optionsBuilder: () => {
      'OK': null,
    }
  );
}