import 'package:flutter/material.dart';
import '../models/product.dart';

// Sepet ekranı — eklenen ürünleri listeler ve toplam fiyatı gösterir
class CartScreen extends StatefulWidget {
  final List<Product> cart;
  final ValueChanged<List<Product>> onCartChanged;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onCartChanged,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cart;

  @override
  void initState() {
    super.initState();
    // Gelen listeyi kopyala; orijinali doğrudan değiştirme
    _cart = List.from(widget.cart);
  }

  // Belirtilen indeksteki ürünü sepetten çıkarır
  void _removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
    });
    widget.onCartChanged(_cart); // Üst widget'a güncel listeyi bildir
  }

  // Tüm ürünlerin toplam fiyatını hesaplar
  double get _totalPrice => _cart.fold(0, (sum, p) => sum + p.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sepet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _cart.isEmpty ? _buildEmptyState() : _buildCartList(),
    );
  }

  // Sepet boşsa gösterilecek ekran
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Sepetiniz boş',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Sepette ürün varsa ürün listesi + toplam + checkout butonu
  Widget _buildCartList() {
    return Column(
      children: [
        // Ürün listesi
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _cart.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = _cart[index];
              return _buildCartItem(product, index);
            },
          ),
        ),

        // Alt kısım: toplam fiyat ve checkout butonu
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Toplam fiyat
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Toplam', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(
                    '\$${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Ödeme butonu (sadece görsel, işlevsiz)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Ödeme Yap', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tek bir sepet satırı
  Widget _buildCartItem(Product product, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Küçük ürün görseli
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(6),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Ürün adı ve fiyatı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),

          // Silme butonu
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
    );
  }
}
