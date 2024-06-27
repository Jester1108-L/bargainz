import 'package:bargainz/database/unit-of-measure-database.dart';
import 'package:bargainz/models/unit-of-measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UnitOfMeasureDialogBox extends StatefulWidget {
  final String? id;
  final UnitOfMeasure unit_of_measure;

  const UnitOfMeasureDialogBox({
    super.key,
    this.id,
    required this.unit_of_measure,
  });

  @override
  State<UnitOfMeasureDialogBox> createState() => _UnitOfMeasureDialogBoxState();
}

class _UnitOfMeasureDialogBoxState extends State<UnitOfMeasureDialogBox> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Column(
      children: [
        Text(
          "${widget.id != null ? "Update" : "Create"} Unit Of Measure",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(64, 0, 0, 0),
        ),
        FormBuilder(
          key: _formKey,
          initialValue: widget.unit_of_measure.toMap(),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'code',
                decoration: const InputDecoration(labelText: 'Code'),
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
                      UnitOfMeasure unit_of_measure =
                          UnitOfMeasure.toObject(data ?? {});

                      if (widget.id != null) {
                        unit_of_measure.id = widget.id;
                        UnitsOfMeasureDatabase.updateUnitOfMeasure(
                            unit_of_measure);
                      } else {
                        UnitsOfMeasureDatabase.insertUnitOfMeasure(
                            unit_of_measure);
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(8),
                      backgroundColor: WidgetStateProperty.all(Colors.white)),
                  child: Text(
                    widget.id != null ? "Update" : "Create",
                    style: const TextStyle(color: Colors.teal),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );

    return AlertDialog(
      content: SizedBox(height: 270, child: childWidget),
    );
  }
}
