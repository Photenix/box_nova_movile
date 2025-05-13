import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    final hasImages = product['images'] != null && product['images'].isNotEmpty;
    final defaultImage = 'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ProductFormScreen(product: product),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de imágenes
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: hasImages ? product['images'].length : 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: hasImages
                            ? product['images'][index]
                            : defaultImage,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.network(defaultImage),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Información básica
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(product['classification']),
                  backgroundColor: Colors.purple[50],
                  labelStyle: TextStyle(color: Colors.purple[800]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              product['description'] ?? 'Sin descripción',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Divider(),
            // Variantes del producto
            Text(
              'Variantes disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...product['details'].map<Widget>((detail) =>
                _buildVariantCard(detail)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantCard(Map<String, dynamic> detail) {
    final hasPurchasePrice = detail['purchasePrice'] != null &&
        detail['purchasePrice'] > 0;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Tamaño
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  detail['size'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Información de precios
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  'Código: ${detail['barcode']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                // PRECIO DE COMPRA (si existe)
                // if (hasPurchasePrice)
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Precio compra',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        decimalDigits: 2,
                        symbol: '\$',
                        locale: 'es',
                      ).format(detail['purchasePrice'] ?? detail['price']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
                // PRECIO DE VENTA
                Text(
                  'Precio venta',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    decimalDigits: 2,
                    symbol: '\$',
                    locale: 'es',
                  ).format(detail['price']),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                ],
              ),
            ),
            // Cantidad en stock
            Column(
              children: [
                Text(
                  'Stock',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '${detail['quantity']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: detail['quantity'] > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}