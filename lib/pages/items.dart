import 'package:bargainz/models/item.dart';
import 'package:bargainz/pages/items/item-tile.dart';
import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final List<String> _retailers = [
    'PNP',
    'Checkers',
    'Woolworths',
    'Shoprite',
  ];

  final List<Item> _items = [
    Item(barcode: "09090"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
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
                  (BuildContext context, SearchController controller) {
            List<String> filteredRetails = _retailers
                .where((retail) =>
                    controller.text.isEmpty ||
                    retail
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                .toList();

            return List<ListTile>.generate(filteredRetails.length, (int index) {
              final String item = filteredRetails[index];

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
          for (int i = 0; i < _items.length; i++)
            ItemTile(
              title: _items[i].barcode,
              onDelete: (context) => {},
              onEdit: (context) => {},
            )
        ],
      ),
    );
  }
}
