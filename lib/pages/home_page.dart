import 'package:flutter/material.dart';
import 'submit_page.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();

    futureProducts = ProductService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddProductDialog(),
          ).then((_) {
            setState(() {
              futureProducts = ProductService().getProducts();
            });
          });
        },

        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada produk"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,

            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubmitPage(product: product),
                      ),
                    );
                  },
                  title: Text(product.name),

                  subtitle: Text(
                    product.description.isEmpty ? "-" : product.description,
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Rp ${product.price}"),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () async {
                          bool success = await ProductService().deleteProduct(
                            product.id,
                          );

                          if (success) {
                            setState(() {
                              futureProducts = ProductService().getProducts();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> saveProduct() async {
    setState(() {
      isLoading = true;
    });

    bool success = await ProductService().addProduct(
      name: nameController.text,
      price: int.parse(priceController.text),
      description: descriptionController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Produk"),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Harga"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,

              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },

          child: const Text("Batal"),
        ),

        ElevatedButton(
          onPressed: isLoading ? null : saveProduct,

          child: isLoading
              ? const CircularProgressIndicator()
              : const Text("Simpan"),
        ),
      ],
    );
  }
}
