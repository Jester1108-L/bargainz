import 'package:bargainz/components/stream-list-view.dart';
import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/products/product-tile.dart';
import 'package:bargainz/pages/products/new-product.dart';
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

  void onBarcodeConfirm(String barcode) async {
    Product product = await ProductDatabase.getProduct(barcode);
    Navigator.pop(context);

    if (product.barcode.isNotEmpty) {
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
                    const Center(
                      child: Text(
                          "Barcode already exists. Would you like to create a new entry?"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Product newProduct = Product.empty();

                        newProduct.barcode = product.barcode;
                        newProduct.name = product.name;
                        newProduct.description = product.description;

                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => NewProduct(
                              id: null,
                              product: newProduct,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      product.barcode = barcode;
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => NewProduct(
            id: null,
            product: product,
          ),
        ),
      );
    }
  }

  // Process barcode on image scanned
  void onBarcodeScanned(String? barcode) async {
    Navigator.pop(context);

    if (barcode != null) {
      Product product = Product.empty();

      product.barcode = barcode;

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
                        elevation: 8,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        onBarcodeConfirm(barcode);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.teal),
                      ),
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
                        elevation: 8,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.teal),
                      ),
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
                        elevation: 8,
                        backgroundColor: Colors.teal,
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
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
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

    final products = docs.map((doc) => Product.toObjectWithSnapshot(doc));

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (Product product in products)
          ProductTile(
            product: product,
            onDelete: (context) => onDelete(product.id ?? ""),
            onEdit: (context) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NewProduct(
                    product: product,
                    id: product.id,
                  ),
                ),
              );
            },
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
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
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 8.0)),
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
              hintText: "Search Retailers...",
              trailing: [
                ElevatedButton(
                  onPressed: () {
                    searchTerm = controller.text;
                    setState(() {});
                  },
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(4),
                      padding: WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.all(0))),
                  child: const Icon(
                    Icons.search,
                    color: Colors.teal,
                  ),
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
                      elevation: WidgetStatePropertyAll(8),
                      backgroundColor: WidgetStatePropertyAll(Colors.white)),
                  child: const Icon(
                    Icons.camera,
                    color: Colors.teal,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                        "Are you sure you would like to delete all products?"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      minimumSize: const Size.fromHeight(32),
                                    ),
                                    onPressed: () {
                                      ProductDatabase.deleteAll();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      minimumSize: const Size.fromHeight(32),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                  },
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(8),
                      backgroundColor: WidgetStatePropertyAll(Colors.white)),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.teal,
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
