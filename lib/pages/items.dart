import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/items/item-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final _controller = TextEditingController();
  List<Retailer> _retailers = [];

  void onSave(bool updating, String id) {
    setState(() {
      Product product = Product(barcode: _controller.text, id: id);

      if (updating) {
        ProductDatabase.updateProduct(product);
      } else {
        ProductDatabase.insertProduct(product);
      }

      _controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(String id) {
    setState(() {
      ProductDatabase.deleteProduct(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () async {
                _retailers = await RetailerDatabase.getRetailersListing();

                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              onSubmitted: (String text) {
                print(text);
              },
              hintText: "Search Retails...",
              trailing: [
                ElevatedButton(
                  onPressed: () {
                    print(controller.text);
                  },
                  style: const ButtonStyle(
                      padding: WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.all(0))),
                  child: const Icon(Icons.search),
                )
              ],
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
            List<Retailer> filteredRetails = _retailers
                .where((retailer) =>
                    controller.text.isEmpty ||
                    retailer.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                .toList();

            return List<ListTile>.generate(filteredRetails.length, (int index) {
              final String item = filteredRetails[index].name;

              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          }),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => {},
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 244, 253, 255),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductDatabase.getProducts(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: Image.asset('assets/images/image-loading.gif'),
                        ),
                      ),
                    ],
                  );
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for (DocumentSnapshot doc in docs)
                      ItemTile(
                        title: doc["barcode"],
                        onDelete: (context) => onDelete(doc.id),
                        onEdit: (context) => onSave(true, doc.id),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
