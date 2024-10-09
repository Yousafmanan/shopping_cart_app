import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/models/cart_model.dart';
import '../utility/cart_provider.dart';
import '../utility/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'My Products',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Badge(
            label: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(value.getCounter().toString());
              },
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data!.isEmpty){
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 150,),
                        Center(child: Image(
                          image: AssetImage('assets/cart.png'),)),
                      ],
                    );
                  }else{
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
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
                                        image: NetworkImage(snapshot.data![index].image.toString()),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index].productName.toString(),
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    dbHelper!.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  },
                                                  child: const Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              snapshot.data![index].unitTag.toString() +
                                                  " " +
                                                  r"$" +
                                                  snapshot.data![index].productPrice.toString(),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price = snapshot.data![index].initialPrice!;

                                                            if (quantity > 1) {
                                                              quantity--;
                                                              int? newPrice = price * quantity;

                                                              dbHelper!.updateQuantity(
                                                                Cart(
                                                                  id: snapshot.data![index].id,
                                                                  productId: snapshot.data![index].id.toString(),
                                                                  productName: snapshot.data![index].productName,
                                                                  initialPrice: snapshot.data![index].initialPrice,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag.toString(),
                                                                  image: snapshot.data![index].image.toString(),
                                                                ),
                                                              ).then((onValue) {
                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                              }).catchError((error) {
                                                                print(error.toString());
                                                              });
                                                            } else {
                                                              print("Quantity can't go below 1");
                                                            }
                                                          },
                                                          child: const Icon(Icons.remove, color: Colors.white),
                                                        ),
                                                        Text(snapshot.data![index].quantity.toString(), style: const TextStyle(color: Colors.white)),
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price = snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice = price * quantity;

                                                            dbHelper!.updateQuantity(
                                                              Cart(
                                                                id: snapshot.data![index].id,
                                                                productId: snapshot.data![index].id.toString(),
                                                                productName: snapshot.data![index].productName,
                                                                initialPrice: snapshot.data![index].initialPrice,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                image: snapshot.data![index].image.toString(),
                                                              ),
                                                            ).then((onValue) {
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                            }).catchError((error) {
                                                              print(error.toString());
                                                            });
                                                          },
                                                          child: const Icon(Icons.add, color: Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return const Text('NO DATA');
                }
              },
            ),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) != "0.00",
                  child: Column(
                    children: [
                      ReusableWidget(title: 'Sub Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                      ReusableWidget(title: 'Discount 5%', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                      ReusableWidget(title: 'Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
