import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_ordering_app/model/user_model.dart';
import 'package:food_ordering_app/model/bottom_navigation_model/app_bottom_bar_item_model.dart';
import 'package:food_ordering_app/model/item_model/MenuModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/design.dart';
import 'detail_page.dart';
import 'LoginPage.dart';

import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:io';

const IconData restaurant = IconData(0xe532, fontFamily: 'MaterialIcons');

// Dash Board
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[200],
            title: const Center(
                child: Icon(Icons.fastfood_sharp, color: mainColor, size: 40)),
            actions: const [
              SizedBox(width: 40, height: 40),
            ],
            iconTheme: const IconThemeData(color: mainColor)),
        drawer: Drawer(
            child: Container(
          color: Color(0xFF476930),
          child: Container(
            color: Color(0xFF476930),
            child: SafeArea(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/background.jpg'),
                    )),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    accountName: null,
                    accountEmail: null,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.article,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Review FAQs",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite_border_sharp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Favorites",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: ActionChip(
                        label: Text("Logout"),
                        onPressed: () {
                          logout(context);
                        }),
                  )
                ],
              ),
            ),
          ),
        )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppHeader(),
            AppSearch(),
            Expanded(child: AppDishesListView()),
            // AppCategoryList(),
            AppBottomBar()
          ],
        ));
  }
}

// dashboard widget section
class AppHeader extends StatefulWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                  'https://www.nicepng.com/png/detail/137-1379898_anonymous-headshot-icon-user-png.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text("${loggedInUser.email}",
                  style: TextStyle(color: mainColor, fontSize: 12))
            ])
          ],
        ));
  }
}

class AppSearch extends StatelessWidget {
  const AppSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kigali Food Explorer',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: Color(0xFF476930))),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search Restaurants',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class AppDishesListView extends StatefulWidget {
  const AppDishesListView({Key? key}) : super(key: key);

  @override
  State<AppDishesListView> createState() => _AppDishesListViewState();
}

class _AppDishesListViewState extends State<AppDishesListView> {
  Future fetchDishes() async {
    var url = await http.get(
      Uri.parse("https://restaurant-api-emile.azurewebsites.net/restaurant/"),
      headers: {
        HttpHeaders.authorizationHeader:
            "Token aec334e3c04d6dd3a56448939bfc510b08c1b8e0"
      },
    );

    var jsonData = json.decode(url.body);

    List<Restaurant> restaurants = [];

    for (var data in jsonData) {
      Restaurant restaurant = Restaurant(
          data["restoName"],
          data["stars"],
          data["priceRange"],
          data["owner"],
          data["ownership"],
          data["imageUrls"],
          data["cuisines"],
          data["description"]);

      //dish = Dish(data["name"], data["image"], data["price"], data["cooking_time"]);

      restaurants.add(restaurant);
    }

    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        child: FutureBuilder(
            future: fetchDishes(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text(
                      "$snapshot.data.error",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      Restaurant currentRestaurant = snapshot.data[i];

                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(resto: currentRestaurant)));
                          },
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(5),
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 63,
                                    backgroundImage: NetworkImage(
                                        currentRestaurant.imageUrls),
                                  ),
                                  Text('Owned by: ${currentRestaurant.owner}',
                                      style: TextStyle(
                                        color: Color(0xFF476930),
                                        fontSize: 10,
                                      )),
                                  Text(currentRestaurant.restoName,
                                      style: TextStyle(
                                        color: Color(0xFF476930),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ))
                                ]),
                          ));
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({Key? key}) : super(key: key);

  @override
  AppBottomBarState createState() => AppBottomBarState();
}

class AppBottomBarState extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset.zero)
        ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(barItems.length, (index) {
              AppBottomBarItem currentBarItem = barItems[index];

              Widget barItemWidget;

              if (currentBarItem.isSelected) {
                barItemWidget = Container(
                    padding:
                        EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainColor),
                    child: Row(children: [
                      Icon(currentBarItem.icon, color: Colors.white),
                      SizedBox(width: 5),
                      Text(currentBarItem.label,
                          style: TextStyle(color: Colors.white))
                    ]));
              } else {
                barItemWidget = IconButton(
                    icon: Icon(currentBarItem.icon, color: Color(0xFF476930)),
                    onPressed: () {
                      setState(() {
                        barItems.forEach((AppBottomBarItem item) {
                          item.isSelected = item == currentBarItem;
                        });
                      });
                    });
              }

              return barItemWidget;
            })));
  }
}

// the logout function
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
}
