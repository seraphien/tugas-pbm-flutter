import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class SubmitPage extends StatefulWidget {
  final ProductModel product;

  const SubmitPage({super.key, required this.product});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final githubController = TextEditingController();

  bool isLoading = false;

  Future<void> handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    bool success = await ProductService().submitProduct(
      name: widget.product.name,
      price: widget.product.price,
      description: widget.product.description,
      githubUrl: githubController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tugas berhasil disubmit")));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Tugas")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: githubController,

              decoration: const InputDecoration(
                labelText: "GitHub URL",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : handleSubmit,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
