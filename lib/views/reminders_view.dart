import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders_mobx/dialogs/show_textfield_dialog.dart';
import 'package:reminders_mobx/state/app_state.dart';
import 'package:reminders_mobx/views/reminders_list_view.dart';

import 'main_popup_menu_button.dart';

class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            onPressed: () async {
              final reminderText = await showTextFieldDialog(
                context: context,
                title: 'What do you want me to remind you about?',
                hintText: 'Enter your reminder here...',
                optionsBuilder: () => {
                  TextFieldDialogButtonType.cancel: 'Cancel',
                  TextFieldDialogButtonType.confirm: 'Save',
                },
              );
              if (reminderText != null && context.mounted) {
                context.read<AppState>().createReminder(reminderText);
              }
            },
            icon: const Icon(Icons.add),
          ),
          const MainMenuPopupMenuButton(),
        ],
      ),
      body: const RemindersListView(),
    );
  }
}
