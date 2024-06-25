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
    required this.id,
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
      // scrollDirection: Axis.vertical,
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
                      key: Key(unit_of_measure.id),
                    )
                ],
                name: 'unit_of_measure',
                decoration: const InputDecoration(labelText: 'Unit Of Measure'),
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
                      Category category = Category(
                          name: data?["name"],
                          unit_of_measure: data?["unit_of_measure"]);

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
                      backgroundColor: WidgetStateProperty.all(Colors.green)),
                  child: const Text("Save"),
                ),
                // child: MaterialButton(
                //   color: Colors.teal,
                //   elevation: 8,
                //   onPressed: () {
                //     bool valid =
                //         _formKey.currentState?.saveAndValidate() ?? false;

                //     if (valid) {
                //       final data = _formKey.currentState?.value;
                //       Category category = Category(
                //           name: data?["name"],
                //           unit_of_measure: data?["unit_of_measure"]);

                //       if (widget.id != null) {
                //         category.id = widget.id;
                //         CategoryDatabase.updateCategory(category);
                //       } else {
                //         category.id = "";
                //         CategoryDatabase.insertCategory(category);
                //       }

                //       Navigator.pop(context);
                //     }
                //   },
                //   child: Text(widget.id != null ? "Update" : "Create"),
                // ),
              )
            ],
          ),
        ),
      ],
    );

    return AlertDialog(
      content: SizedBox(height: 220, child: childWidget),
    );
    // return AlertDialog(
    //   content: SizedBox(
    //     height: 200,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text("Create Category"),
    //         const Divider(
    //           thickness: 1,
    //           color: Color.fromARGB(64, 0, 0, 0),
    //         ),

    //         Container(
    //           padding: EdgeInsets.symmetric(vertical: 8),
    //           child: Column(
    //             children: [
    //               TextField(
    //                 controller: controller,
    //                 decoration: const InputDecoration(
    //                     border: OutlineInputBorder(), hintText: "Category Name"),
    //               ),
    //             ],
    //           ),
    //         ),

    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             FilledButton(
    //               onPressed: onSave,
    //               style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
    //               child: const Text("Save"),
    //             ),
    //             FilledButton(
    //               onPressed: onCancel,
    //               style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
    //               child: const Text("Cancel"),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
