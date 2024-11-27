import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProductScreen extends StatelessWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  void _updateProduct(BuildContext context, DocumentSnapshot product) async {
    TextEditingController nameController =
        TextEditingController(text: product['nombre']);
    TextEditingController priceController =
        TextEditingController(text: product['precio'].toString());
    TextEditingController descriptionController =
        TextEditingController(text: product['descripcion']);
    TextEditingController imageUrlController =
        TextEditingController(text: product['imagen']);
    String category = product['categoria'] ?? 'Sin categoría';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Actualizar Producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de la imagen',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: category,
                  onChanged: (value) {
                    category = value!;
                  },
                  items: <String>[
                    'Sin categoría',
                    'Frutas y Verduras',
                    'Lácteos',
                    'Carnes',
                    'Bebidas',
                    'Panadería',
                    'Cereales',
                    'Granos',
                    'Dulces'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('productos')
                      .doc(product.id)
                      .update({
                    'nombre': nameController.text,
                    'precio': double.parse(priceController.text),
                    'descripcion': descriptionController.text,
                    'imagen': imageUrlController.text,
                    'categoria': category,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Producto actualizado correctamente')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar producto: $e')),
                  );
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Productos'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final productos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final product = productos[index];
              return ListTile(
                leading: Image.network(
                  product['imagen'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product['nombre']),
                subtitle: Text('\$${product['precio']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    _updateProduct(context, product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
