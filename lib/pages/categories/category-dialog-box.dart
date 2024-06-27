import 'package:bargainz/database/category-database.dart';
import 'package:bargainz/database/unit-of-measure-database.dart';
import 'package:bargainz/models/category.dart';
import 'package:bargainz/models/unit-of-measure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoryDialogBox extends StatefulWidget {
  final String? id;
  final Category category;

  const CategoryDialogBox({
    super.key,
    this.id,
    required this.category,
  });

  @override
  State<CategoryDialogBox> createState() => _CategoryDialogBoxState();
}

class _CategoryDialogBoxState extends State<CategoryDialogBox> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<UnitOfMeasure> units_of_measure = [];

  @override
  void initState() {
    super.initState();

    UnitsOfMeasureDatabase.getUnitsOfMeasure().forEach((stream) {
      units_of_measure = stream.docs.map((el) {
        return UnitOfMeasure(id: el.id, name: el["name"], code: el["code"]);
      }).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Column(
      children: [
        Text(
          "${widget.id != null ? "Update" : "Create"} Category",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(64, 0, 0, 0),
        ),
        FormBuilder(
          key: _formKey,
          initialValue: widget.category.toMap(),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderDropdown(
                items: [
                  for (UnitOfMeasure unit_of_measure in units_of_measure)
                    DropdownMenuItem(
                      child: Text(unit_of_measure.name),
                      value: unit_of_measure.code,
                      key: Key(unit_of_measure.id ?? ''),
                    )
                ],
                name: 'unit_of_measure',
                decoration: const InputDecoration(labelText: 'Unit Of Measure'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    bool valid =
                        _formKey.currentState?.saveAndValidate() ?? false;

                    if (valid) {
                      final data = _formKey.currentState?.value;
                      Category category = Category.toObject(data ?? {});

                      if (widget.id != null) {
                        category.id = widget.id;
                        CategoryDatabase.updateCategory(category);
                      } else {
                        category.id = "";
                        CategoryDatabase.insertCategory(category);
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(8),
                      backgroundColor: WidgetStateProperty.all(Colors.white)),
                  child: Text(widget.id != null ? "Update" : "Create", style: const TextStyle(color: Colors.teal),),
                ),
              )
            ],
          ),
        ),
      ],
    );

    return AlertDialog(
      content: SizedBox(height: 280, child: childWidget),
    );
  }
}
