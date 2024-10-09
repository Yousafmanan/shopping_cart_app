import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/models/cart_model.dart';
import 'package:shopping_cart_app/screens/cart_screen.dart';
import 'package:shopping_cart_app/utility/cart_provider.dart';
import 'package:shopping_cart_app/utility/db_helper.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {

  DbHelper? dbHelper = DbHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruits Basket'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://www.shutterstock.com/shutterstock/photos/2500608655/display_1500/stock-photo-ripe-mango-isolated-on-white-background-2500608655.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2456317693/display_1500/stock-photo-orange-fruit-with-leaves-and-half-isolated-on-the-white-background-full-depth-of-field-clipping-2456317693.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2490657677/display_1500/stock-photo-fresh-green-grape-cluster-isolated-on-white-background-2490657677.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2497082447/display_1500/stock-photo-bunch-of-bananas-isolated-on-white-background-with-clipping-path-and-full-depth-of-field-2497082447.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2499664695/display_1500/stock-photo-cherry-with-stem-and-leaf-isolated-on-white-background-2499664695.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2485109819/display_1500/stock-photo-ripe-red-peaches-with-green-leaf-isolated-on-white-background-file-contains-clipping-path-2485109819.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2512053151/display_1500/stock-photo-many-different-fresh-fruits-in-wicker-basket-isolated-on-white-2512053151.jpg',
  ];

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Badge(
              label: Consumer<CartProvider>(
                builder: (context, value, child){
                  return Text(value.getCounter().toString());
                },
              ),

              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
        itemCount: productName.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image(
                          height: 100,
                          width: 100,
                          image: NetworkImage(
                              productImage[index].toString())),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName[index].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              productUnit[index].toString() +
                                  " " +
                                  r"$" +
                                  productPrice[index].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  dbHelper!.insert(Cart(
                                    id: index,
                                    productId: index.toString(),
                                    productName: productName[index].toString(),
                                    initialPrice: productPrice[index],
                                    productPrice: productPrice[index],
                                    quantity: 1,
                                    unitTag: productUnit[index].toString(),
                                    image: productImage[index].toString(),
                                  )).then((onValue) {

                                    print('Product is added to cart');
                                    cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                    cart.addCounter();

                                  }).catchError((error) {
                                    print(error.toString());
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }))
        ],
      ),
    );
  }
}
