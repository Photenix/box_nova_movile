import 'package:box_nova/main.dart';
import 'package:box_nova/modules/product/product_list.dart';
import 'package:box_nova/modules/user/user_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatelessWidget {
  final Color primaryColor = Colors.purple; // Purple 500
  final Color accentColor = Colors.deepPurpleAccent;
  final double buttonWidth = 280.0;

  const Admin({super.key});

  void _exit(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: "Inicio")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Panel de administración',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 4
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo con sombra y borde circular
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.purple.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/Logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de usuarios con icono
              SizedBox(
                width: buttonWidth,
                child: _buildAdminButton(
                  context: context,
                  icon: Icons.people_alt,
                  text: 'Listado de usuarios',
                  destination: const UserBody(),
                ),
              ),

              const SizedBox(height: 16),

              // Botón de productos con icono
              SizedBox(
                width: buttonWidth,
                child: _buildAdminButton(
                  context: context,
                  icon: Icons.inventory_2,
                  text: 'Listado de productos',
                  destination: const ProductList(),
                ),
              ),

              const SizedBox(height: 16),

              // Botón de cerrar sesión
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: () => _exit(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Créditos
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Proyecto creado por boxnova\nAño 2025',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  // Widget reutilizable para botones de administración
  Widget _buildAdminButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Widget destination,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        // shadowColor: Colors.purple.withOpacity(0.3),
      ),
    );
  }
}
