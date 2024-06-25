import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/items/item-tile.dart';
import 'package:bargainz/pages/items/new-product.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  String? scannedBarcode = null;
  String? searchTerm = null;
  List<Retailer> _retailers = [];
  // late Future<void> _initializeControllerFuture;

  void onDelete(String id) {
    setState(() {
      ProductDatabase.deleteProduct(id);
    });
  }

  void onBarcodeScanned() async {
    Navigator.pop(context);

    if (scannedBarcode != null) {
      Product product = Product(
          barcode: scannedBarcode ?? "",
          name: "",
          retailer: "",
          unit_of_measure: "",
          category: "",
          unit: 0,
          price: 0,
          description: "");

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
                          Text("Scanned Barcode: $scannedBarcode"),
                          const Text("Would you like to proceed?"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                            32), // fromHeight use double.infinity as width and 40 is the height
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
                        minimumSize: const Size.fromHeight(
                            32), // fromHeight use double.infinity as width and 40 is the height
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
                        minimumSize: const Size.fromHeight(
                            32), // fromHeight use double.infinity as width and 40 is the height
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
                        minimumSize: const Size.fromHeight(
                            32), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () async {
                        try {
                          final image = await cameraController.takePicture();
                          final inputImage =
                              InputImage.fromFilePath(image.path);
                          final List<Barcode> barcodes =
                              await BarcodeScanner().processImage(inputImage);

                          if (barcodes.isNotEmpty) {
                            scannedBarcode = barcodes.first.displayValue;
                          } else {
                            scannedBarcode = null;
                          }

                          onBarcodeScanned();
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
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductDatabase.getProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                List<DocumentSnapshot> docs = snapshot.data!.docs.where((doc) {return (searchTerm == null) || (doc["retailer"] == searchTerm);}).toList();

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
                      ItemTile(
                        product: Product(
                            barcode: doc["barcode"],
                            name: doc["name"],
                            category: doc["category"],
                            price: doc["price"],
                            unit: doc["unit"],
                            retailer: doc["retailer"],
                            unit_of_measure: doc["unit_of_measure"],
                            description: doc["description"]),
                        onDelete: (context) => onDelete(doc.id),
                        onEdit: (context) {
                          Product product = Product(
                              barcode: doc["barcode"],
                              name: doc["name"],
                              category: doc["category"],
                              retailer: doc["retailer"],
                              price: doc["price"],
                              unit: doc["unit"],
                              unit_of_measure: doc["unit_of_measure"],
                              description: doc["description"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => NewProduct(
                                product: product,
                                id: doc.id,
                              ),
                            ),
                          );
                        },
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
