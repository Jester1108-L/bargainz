import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RetailerDialogBox extends StatefulWidget {
  final String? id;
  final Retailer retailer;

  const RetailerDialogBox({
    super.key,
    this.id,
    required this.retailer,
  });

  @override
  State<RetailerDialogBox> createState() => _RetailerDialogBoxState();
}

class _RetailerDialogBoxState extends State<RetailerDialogBox> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Column(
      children: [
        Text(
          "${widget.id != null ? "Update" : "Create"} Retailer",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(64, 0, 0, 0),
        ),
        FormBuilder(
          key: _formKey,
          initialValue: widget.retailer.toMap(),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FilledButton(
                  onPressed: () {
                    bool valid =
                        _formKey.currentState?.saveAndValidate() ?? false;

                    if (valid) {
                      final data = _formKey.currentState?.value;
                      Retailer retailer = Retailer.toObject(data ?? {});

                      if (widget.id != null) {
                        retailer.id = widget.id;
                        RetailerDatabase.updateRetailer(retailer);
                      } else {
                        retailer.id = "";
                        RetailerDatabase.insertRetailer(retailer);
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green)),
                  child: const Text("Save"),
                ),
              )
            ],
          ),
        ),
      ],
    );

    return AlertDialog(
      content: SizedBox(height: 170, child: childWidget),
    );
  }
}
