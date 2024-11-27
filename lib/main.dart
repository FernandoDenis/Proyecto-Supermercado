import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/payment_method_screen.dart';
import 'screens/address_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/delete_product_screen.dart';
import 'screens/update_product_screen.dart';
import 'screens/confirmation_screen.dart'; // Importa la pantalla de confirmación

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supermercado App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/', // Ruta inicial de la aplicación
      routes: {
        '/': (context) => const LoginScreen(), // Pantalla de inicio de sesión
        '/register': (context) => const RegisterScreen(), // Registro
        '/products': (context) =>
            const ProductScreen(), // Pantalla de productos
        '/admin': (context) => const AdminScreen(), // Pantalla de administrador
        '/address': (context) => const AddressScreen(), // Dirección
        '/payment-method': (context) =>
            const PaymentMethodScreen(), // Método de pago
        '/add_product': (context) =>
            const AddProductScreen(), // Agregar producto
        '/cart': (context) => const CartScreen(), // Carrito
        '/confirmation': (context) =>
            const ConfirmationScreen(), // Pantalla de confirmación
        '/delete_product': (context) => const DeleteProductScreen(),
        '/update_product': (context) => const UpdateProductScreen(),
      },
    );
  }
}
