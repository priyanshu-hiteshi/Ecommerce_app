import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {}; // Store cart items with product ID as key

  // Expose cart items as a read-only map
  Map<int, CartItem> get cartItems => _cartItems;

  // Calculate the total amount of the cart
  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((_, cartItem) {
      total += cartItem.product.price *
          cartItem.quantity; // Access `cartItem.product`
    });
    return total;
  }

  // Add a product to the cart
  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      // If product already in cart, increase quantity
      _cartItems[product.id]!.quantity++;
    } else {
      // Add new product to cart
      _cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Remove a product from the cart
  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  // Increment the quantity of a specific product in the cart
  void incrementQuantity(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity++;
      notifyListeners();
    }
  }

  // Decrement the quantity of a specific product in the cart
  // Remove the product if the quantity becomes zero
  void decrementQuantity(int productId) {
    if (_cartItems.containsKey(productId) &&
        _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId); // Remove item if quantity reaches 0
    }
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

// Define the CartItem model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
