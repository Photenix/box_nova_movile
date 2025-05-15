import 'package:box_nova/models/ProductModel.dart';
import 'package:box_nova/modules/general/pagination_controls.dart';
import 'package:box_nova/modules/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductType _productList = [];

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  int _limit = 10;
  bool _hasMore = true;


  Future<void> _refreshProducts() async {
    setState(() {
      _currentPage = 1;
      _productList.clear();
    });
    _getProducts();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
    _getProducts();
  }

  void _changeLimit(int newLimit) {
    setState(() {
      _limit = newLimit;
      _currentPage = 1;
      _productList.clear();
      _hasMore = true;
    });
    _getProducts();
  }


  void _getProducts() async {
    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      ProductType products = await ProductModel.getProducts(
          _currentPage, _limit);
      // print( products );
      setState(() {
        _productList = products;
        _isLoading = false;
      });
    }
    catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _findProducts() async {
    if (_isLoading) return;
    final query = _searchController.text.toLowerCase();

    try {
      if (query.isEmpty) {
        _getProducts();
      }
      else if (query.length > 2) {
        setState(() {
          _isLoading = true; // Activar el estado de carga
        });
        ProductType products = await ProductModel.searchProducts(query);
        setState(() {
          _productList = products;
          _isLoading = false;
        });
      }
    }
    catch (e) {
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
          title: const Text('Listado de Productos'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
        ),
        body:
        _isLoading
            ? const Center(
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
          ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 50, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _searchController.text.isEmpty
                    ? 'No hay productos disponibles'
                    : 'No se encontraron resultados',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: ElevatedButton.icon(
                  onPressed: _clearSearch,
                  label: const Text(
                    "Limpiar busqueda",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[500],
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              )
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: ListView.builder(
                    itemCount: _productList.length,
                    //crea producto por producto
                    itemBuilder: (context, index) {
                      final product = _productList[index];
                      return _buildProductCard(product);
                    },
                  ),
                )
            ),
            PaginationControls(
              currentPage: _currentPage,
              hasMore: _hasMore,
              limit: _limit,
              onPrevious: () {
                setState(() => _currentPage--);
                _getProducts();
              },
              onNext: () {
                setState(() => _currentPage++);
                _getProducts();
              },
              onChangeLimit: (newLimit) {
                _changeLimit(newLimit);
              },
            )
          ],
        )
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

    String showDescription(description) {
      if (description == null || description == '') return "Sin descripción";
      return description;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          padding: const EdgeInsets.all(12),
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
                  placeholder: (context, url) =>
                      Container(
                        color: Colors.grey[200],
                        width: 80,
                        height: 80,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget: (context, url, error) =>
                      Image.network(
                        'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      showDescription(product['description']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(traslater[product['classification']] ??
                              product['classification']),
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
                        const SizedBox(height: 4),
                        Text(
                          // '\$${product['details'][0]['price']}',
                          "${NumberFormat.currency(
                            decimalDigits: 0,
                            // Cantidad de decimales (0 para precios enteros)
                            symbol: '',
                            // Elimina el símbolo de moneda
                            locale: 'es', // Configuración regional para español
                          ).format(product['details'][0]['price'])} COP",
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
            ],
          ),
        ),
      ),
    );
  }
}
