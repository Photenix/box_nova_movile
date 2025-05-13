import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/CommonSearch.dart';
import 'package:box_nova/modules/product/product_card.dart';
import 'package:box_nova/modules/product/product_details.dart';
import 'package:box_nova/modules/product/product_form.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // Datos de ejemplo basados en tu esquema
  List<Map<String, dynamic>> _productList = [
    {
      'name': 'Zapatillas Running',
      'description': 'Zapatillas cómodas para correr largas distancias',
      'totalQuantity': 50,
      'classification': 'Unisex',
      'color': 'Black/Red',
      'images': [
        'https://down-co.img.susercontent.com/file/e2dc82222934c185d9bbf76d8977e8fa'
      ],
      'details': [
        {
          'size': 'M',
          'price': 89.99,
          'quantity': 20,
          'discount': 10,
          'barcode': '1234567890123'
        },
        {
          'size': 'L',
          'price': 89.99,
          'quantity': 30,
          'discount': 15,
          'barcode': '1234567890124'
        }
      ]
    },
    {
      'name': 'Camiseta Deportiva',
      'description': 'Camiseta transpirable para entrenamiento',
      'totalQuantity': 75,
      'classification': 'Male',
      'color': 'Blue',
      'images': [], // Sin imágenes
      'details': [
        {
          'size': 'S',
          'price': 29.99,
          'quantity': 25,
          'discount': 0,
          'barcode': '1234567890125'
        },
        {
          'size': 'M',
          'price': 29.99,
          'quantity': 30,
          'discount': 5,
          'barcode': '1234567890126'
        },
        {
          'size': 'L',
          'price': 29.99,
          'quantity': 20,
          'discount': 0,
          'barcode': '1234567890127'
        }
      ]
    }
  ];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  void _getProducts() async {
    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try{
      List<Map<String, dynamic>> products = await ProductModel.getProducts();
      // print( products );
      setState(() {
        _productList = products;
        _isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _findProducts() async {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isLoading = true; // Activar el estado de carga
    });
    try{
      if( query.length == 0 ){
        _getProducts();
      }
      else{
        ProductType products = await ProductModel.searchProducts(query);
        setState(() {
          _productList = products;
          _isLoading = false;
        });
      }
    }
    catch(e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
    _searchController.addListener(_findProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Productos'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body:
      _isLoading
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Indicador de carga circular
            SizedBox(height: 16),
            Text('Cargando productos...'),
          ],
        ),
      )
      : _productList.isEmpty
      ?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No hay productos disponibles'
                  : 'No se encontraron resultados',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
      :ListView.builder(
        itemCount: _productList.length,
        //crea producto por producto
        itemBuilder: (context, index) {
          final product = _productList[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final hasImages = product['images'] != null && product['images'].isNotEmpty;
    final imageUrl = hasImages
        ? product['images'][0]
        : 'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png';

    final traslater = {
      'Unisex': 'Unisex',
      'Male': 'Hombre',
      'Female': 'Mujer',
      'Girl': 'Niña',
      'Boy': 'Niño'
    };

    String showDescription( description ){
      if( description == null || description == '' ) return "Sin descripción";
      return description;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(product: product),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagen del producto
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    width: 80,
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Image.network(
                    'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      showDescription(product['description']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(traslater[product['classification']] ?? product['classification']),
                          backgroundColor: Colors.purple[50],
                          labelStyle: TextStyle(color: Colors.purple[800]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product['totalQuantity']} en stock',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          // '\$${product['details'][0]['price']}',
                          NumberFormat.currency(
                            decimalDigits: 0,       // Cantidad de decimales (0 para precios enteros)
                            symbol: '',             // Elimina el símbolo de moneda
                            locale: 'es',           // Configuración regional para español
                          ).format(product['details'][0]['price']) + " COP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
              // Cantidad y precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
