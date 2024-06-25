import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/database/category-database.dart';
import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/category.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';

class NewProduct extends StatefulWidget {
  final Product product;
  final String? id;

  const NewProduct({super.key, required this.product, required this.id});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<Retailer> retailers = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    RetailerDatabase.getRetailers().forEach((stream) {
      retailers = stream.docs.map((el) {
        return Retailer(id: el.id, name: el["name"]);
      }).toList();
      setState(() {});
    });
    CategoryDatabase.getCategories().forEach((stream) {
      categories = stream.docs.map((el) {
        return Category(id: el.id, name: el["name"], unit_of_measure: el["unit_of_measure"]);
      }).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = ListView(
      scrollDirection: Axis.vertical,
      children: [
        Text(
          "${widget.id != null ? "Update" : "Create"} Product",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(64, 0, 0, 0),
        ),
        FormBuilder(
          key: _formKey,
          initialValue: widget.product.toMap(),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'barcode',
                decoration: const InputDecoration(labelText: 'Barcode'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(labelText: 'Description'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.number,
                name: 'unit',
                initialValue: widget.product.unit.toString(),
                decoration: const InputDecoration(labelText: 'Units'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                keyboardType: TextInputType.number,
                name: 'price',
                initialValue: widget.product.price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderDropdown(
                items: [
                  for (Retailer retailer in retailers)
                    DropdownMenuItem(
                      child: Text(retailer.name),
                      value: retailer.name,
                      key: Key(retailer.id),
                    )
                ],
                name: 'retailer',
                decoration: const InputDecoration(labelText: 'Retailer'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderDropdown(
                items: [
                  for (Category category in categories)
                    DropdownMenuItem(
                      child: Text(category.name),
                      value: category.name,
                      key: Key(category.id ?? ""),
                    )
                ],
                name: 'category',
                decoration: const InputDecoration(labelText: 'Category'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MaterialButton(
                  color: Colors.teal,
                  elevation: 8,
                  onPressed: () {
                    bool valid =
                        _formKey.currentState?.saveAndValidate() ?? false;

                    if (valid) {
                      final data = _formKey.currentState?.value;
                      Product product = Product(
                          barcode: data?["barcode"],
                          name: data?["name"],
                          category: data?["category"],
                          price: double.parse(data?["price"]),
                          unit: double.parse(data?["unit"]),
                          unit_of_measure: categories.where((cat){return cat.name == data?["category"];}).first.unit_of_measure,
                          retailer: data?["retailer"],
                          description: data?["description"]);

                      if (widget.id != null) {
                        product.id = widget.id;
                        ProductDatabase.updateProduct(product);
                      } else {
                        ProductDatabase.insertProduct(product);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.id != null ? "Update" : "Create"),
                ),
              )
            ],
          ),
        ),
      ],
    );

    return AppScaffold(childWidget: childWidget);
  }
}
