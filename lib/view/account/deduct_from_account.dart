import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pockets/controller/hive/boxes.dart';
import 'package:pockets/model/hive/account.dart';
import 'package:pockets/view/model/pocket_text_form_field.dart';

import '../model/pockets_button.dart';

class DeductFromAccount extends StatefulWidget {
  const DeductFromAccount({Key? key}) : super(key: key);

  @override
  State<DeductFromAccount> createState() => _DeductFromAccountState();
}

class _DeductFromAccountState extends State<DeductFromAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Account>? accounts;
  Account? selectedAccount;
  late int amount;

  @override
  void initState() {
    fetchFromDB();
    super.initState();
  }

  fetchFromDB() async {
    final box = Boxes.getAccounts();
    setState(() {
      accounts = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deduct From Account"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: accounts != null
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PocketsTextFormField(
                          labelText: "Enter amount",
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter an amount";
                            } else if (int.tryParse(val) == null) {
                              return "Please enter a valid amount";
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
                      Text(
                        selectedAccount == null ? "Select an Account" : "",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: DropdownSearch<Account>(
                          items: accounts!,
                          selectedItem: selectedAccount,
                          validator: (val) {
                            if (val == null) {
                              return "Please choose an account";
                            }
                            return null;
                          },
                          onSaved: (account) {
                            setState(() {
                              selectedAccount = account!;
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      PocketsButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState?.save();
                          selectedAccount!.amount =
                              selectedAccount!.amount - amount;
                          selectedAccount!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Amount deducted from account",
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              // behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text("Deduct"),
                        ),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
