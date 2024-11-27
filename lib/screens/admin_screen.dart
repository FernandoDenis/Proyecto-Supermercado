import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    String selectedCategory = 'Sin categoría'; // Categoría predeterminada

    void addProduct() async {
      final name = nameController.text.trim();
      final price = double.tryParse(priceController.text.trim());
      final description = descriptionController.text.trim();
      final imageUrl = imageUrlController.text.trim();

      if (name.isNotEmpty &&
          price != null &&
          description.isNotEmpty &&
          imageUrl.isNotEmpty) {
        try {
          await FirebaseFirestore.instance.collection('productos').add({
            'nombre': name,
            'precio': price,
            'descripcion': description,
            'imagen': imageUrl,
            'categoria': selectedCategory,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto agregado correctamente.')),
          );
          nameController.clear();
          priceController.clear();
          descriptionController.clear();
          imageUrlController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar producto: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración de Productos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agregar Producto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del producto'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de la imagen'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: [
                'Sin categoría',
                'Canasta básica',
                'Bebidas',
                'Snacks',
                'Frutas y verduras',
                'Carnes'
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCategory = value;
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text('Agregar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
