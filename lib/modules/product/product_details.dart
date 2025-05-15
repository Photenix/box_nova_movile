import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasImages = product['images'] != null && product['images'].isNotEmpty;
    const defaultImage = 'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png';

    String descriptionProduct = product['description'] == '' ?'Sin descripción' :product['description'];

    final traslater = {
      'Unisex': 'Unisex',
      'Male': 'Hombre',
      'Female': 'Mujer',
      'Girl': 'Niña',
      'Boy': 'Niño'
    };

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
        padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: hasImages
                            ? product['images'][index]
                            : defaultImage,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.network(defaultImage),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Información básica
            Text(
              product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(traslater[ product['classification'] ] ??  product['classification'] ),
                  backgroundColor: Colors.purple[50],
                  labelStyle: TextStyle(color: Colors.purple[800]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              descriptionProduct ?? 'Sin descripción',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Divider(),
            // Variantes del producto
            const Text(
              'Variantes disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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

    final discountPrice = detail['price'] - ((detail['price'] * detail['discount'])/100);

    final pricePurchase = detail['purchasePrice'] == 0 ?detail['price'] :detail['purchasePrice'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
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
            const SizedBox(width: 16),
            // Información de precios
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  'Código: ${detail['barcode']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
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
                      ).format(pricePurchase ?? detail['purchasePrice']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple[800],
                        // color: Colors.grey[800],
                        // decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                Row(
                  children:[
                    Text(
                      NumberFormat.currency(
                        decimalDigits: 2,
                        symbol: '\$',
                        locale: 'es',
                      ).format(discountPrice),
                      // ).format(detail['price']),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),

                    SizedBox(width: 8),
                    if (detail['discount'] > 0)
                      Text(
                        '${detail['discount']}% OFF',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ]
                )

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