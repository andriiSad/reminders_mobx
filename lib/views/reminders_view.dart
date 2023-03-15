import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:reminders_mobx/dialogs/delete_reminder_dialog.dart';
import 'package:reminders_mobx/dialogs/show_textfield_dialog.dart';
import 'package:reminders_mobx/state/app_state.dart';

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
      body: const ReminderListView(),
    );
  }
}

class ReminderListView extends StatelessWidget {
  const ReminderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(
      builder: (context) => ListView.builder(
        itemCount: appState.sortedReminders.length,
        itemBuilder: (context, index) {
          final reminder = appState.sortedReminders[index];
          return Observer(
            builder: (context) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: reminder.isDone,
              onChanged: (bool? isDone) {
                appState.modify(
                  reminder,
                  isDone: isDone ?? false,
                );
                reminder.isDone = isDone ?? false;
              },
              title: Row(
                children: [
                  Expanded(
                    child: Text(reminder.text),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDeleteReminder =
                          await showDeleteReminderDialog(context);
                      if (shouldDeleteReminder) {
                        appState.deleteReminder(reminder);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
