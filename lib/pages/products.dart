import 'package:bargainz/components/stream-list-view.dart';
import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/items/product-tile.dart';
import 'package:bargainz/pages/items/new-product.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String? searchTerm;
  List<Retailer> _retailers = [];

  // Delete product
  void onDelete(String id) {
    ProductDatabase.deleteProduct(id);
    setState(() {});
  }

  // Process barcode on image scanned
  void onBarcodeScanned(String? barcode) async {
    Navigator.pop(context);

    if (barcode != null) {
      Product product = Product.empty();

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text("Scanned Barcode: $barcode"),
                          const Text("Would you like to proceed?"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => NewProduct(
                              id: null,
                              product: product,
                            ),
                          ),
                        );
                      },
                      child: const Text("OK"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                          "No barcode has been scanned. Please try again."),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  // Display camera screen
  void onCameraDisplay() async {
    if (mounted) {
      List<CameraDescription> cameras = await availableCameras();
      CameraController cameraController =
          CameraController(cameras.last, ResolutionPreset.medium);
      await cameraController.initialize();

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 375,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CameraPreview(cameraController),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () async {
                        try {
                          final image = await cameraController.takePicture();
                          final inputImage =
                              InputImage.fromFilePath(image.path);
                          final List<Barcode> barcodes =
                              await BarcodeScanner().processImage(inputImage);

                          onBarcodeScanned(barcodes.isNotEmpty
                              ? barcodes.first.displayValue
                              : null);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  // Builder function for list view
  Widget productListView(List<DocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'No products',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (DocumentSnapshot doc in docs)
          ProductTile(
            product: Product.toObjectWithSnapshot(doc),
            onDelete: (context) => onDelete(doc.id),
            onEdit: (context) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NewProduct(
                    product: Product.toObjectWithSnapshot(doc),
                    id: doc.id,
                  ),
                ),
              );
            },
          )
      ],
    );
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
                searchTerm = text;
                setState(() {});
              },
              hintText: "Search Retails...",
              trailing: [
                ElevatedButton(
                  onPressed: () {
                    searchTerm = controller.text;
                    setState(() {});
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
                  searchTerm = item;

                  controller.closeView(item);
                  setState(() {});
                },
              );
            });
          }),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => onCameraDisplay(),
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: const Icon(
                    Icons.camera,
                    color: Color.fromARGB(255, 244, 253, 255),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => ProductDatabase.deleteAll(),
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  child: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 244, 253, 255),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamListView(
                stream: ProductDatabase.getProducts(),
                listViewBuilder: productListView),
          ),
        ],
      ),
    );
  }
}
