import 'package:flutter/material.dart';
import 'package:pockets/controller/hive/boxes.dart';
import 'package:pockets/model/hive/account.dart';
import 'package:pockets/view/model/pocket_text_form_field.dart';
import 'package:pockets/view/model/pockets_button.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late int amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Account"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: PocketsTextFormField(
                    labelText: "Account Name",
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter account name";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        name = val!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: PocketsTextFormField(
                    labelText: "Initial Amount",
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter initial amount";
                      }
                      if (int.tryParse(val) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        amount = int.parse(val!);
                      });
                    },
                  ),
                ),
                const Spacer(),
                PocketsButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState?.save();
                    final accountBox = Boxes.getAccounts();
                    accountBox.add(
                      Account(
                        name: name,
                        amount: amount,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Account Created Successfully",
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        // behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
