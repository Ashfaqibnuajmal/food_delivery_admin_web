import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/input_decoration.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';
import 'package:user_app/features/due_payment/logic/controller/due_entry_controller.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_entry_date_picker_button.dart';
import 'package:user_app/features/due_payment/presentation/widget/due_details_screen/due_entry_dialog_button.dart';
import 'package:user_app/features/due_payment/logic/provider/due_entry_action_provider.dart';
import 'package:user_app/features/due_payment/logic/provider/due_entry_form_validator.dart';
import 'package:user_app/features/due_payment/utils/due_date_format.dart';

Future<void> customEditEntryDialog({
  required BuildContext context,
  required PaymentEntryModel currentEntry,
}) async {
  final screenContext = context;

  return showDialog(
    context: screenContext,
    builder: (dialogContext) {
      return EditEntryDialog(
        currentEntry: currentEntry,
        screenContext: screenContext,
      );
    },
  );
}

class EditEntryDialog extends StatefulWidget {
  final PaymentEntryModel currentEntry;
  final BuildContext screenContext;

  const EditEntryDialog({
    super.key,
    required this.currentEntry,
    required this.screenContext,
  });

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dueEntryController = DueEntryController();

  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.currentEntry.amount.toString(),
    );
    _notesController = TextEditingController(text: widget.currentEntry.notes);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DueEntryFormProvider>().setInitialValues(
        selectedDate: widget.currentEntry.date,
        status: widget.currentEntry.status,
        amount: widget.currentEntry.amount,
        notes: widget.currentEntry.notes,
      );
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DueEntryFormProvider>(
      builder: (context, formProvider, _) {
        return Dialog(
          backgroundColor: AppColors.deepBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 50,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Edit Entry", style: CustomTextStyles.title),
                    const SizedBox(height: 20),

                    DueEntryDatePickerButton(
                      label: formProvider.selectedDate != null
                          ? DueDateFormatter.formatDate(
                              formProvider.selectedDate!,
                            )
                          : "Pick Date",
                      onPressed: () async {
                        final picked = await _dueEntryController.pickEditDate(
                          context,
                          formProvider.selectedDate ?? widget.currentEntry.date,
                        );

                        if (picked != null) {
                          formProvider.setSelectedDate(picked);
                        }
                      },
                    ),

                    if (formProvider.showDateError)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "Date is required",
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      decoration: inputDecoration("Status"),
                      dropdownColor: AppColors.darkBlue,
                      initialValue: formProvider.status,
                      style: const TextStyle(color: AppColors.pureWhite),
                      items: DueEntryController.statusItems,
                      validator: _dueEntryController.validateStatus,
                      onChanged: formProvider.setStatus,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration("Enter Amount"),
                      style: const TextStyle(color: AppColors.pureWhite),
                      validator: _dueEntryController.validateAmount,
                      onChanged: formProvider.setAmount,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _notesController,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration("Notes"),
                      style: const TextStyle(color: AppColors.pureWhite),
                      validator: _dueEntryController.validateNotes,
                      onChanged: formProvider.setNotes,
                    ),
                    const SizedBox(height: 30),
                    Consumer<DueEntryActionProvider>(
                      builder: (context, actionProvider, _) {
                        return DueEntryDialogButton(
                          label: "Update Entry",
                          isLoading: actionProvider.isSavingEntry,
                          onPressed: () {
                            actionProvider.runSaveEntryAction(() {
                              return _dueEntryController.updateEntry(
                                dialogContext: context,
                                screenContext: widget.screenContext,
                                formKey: _formKey,
                                currentEntry: widget.currentEntry,
                                selectedDate: formProvider.selectedDate,
                                status: formProvider.status,
                                amount:
                                    formProvider.amount ??
                                    widget.currentEntry.amount,
                                notes: formProvider.notes,
                                setShowDateError: formProvider.setShowDateError,
                              );
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
