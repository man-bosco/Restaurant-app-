import 'package:food_ordering_app/model/item_model/MenuModel.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/design.dart';

class DetailsPage extends StatefulWidget {
  final dynamic resto;
  const DetailsPage({Key? key, required this.resto}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Restaurant get resto => widget.resto;

  @override
  Widget build(BuildContext context) {
    // var selectedItem = widget.resto;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(resto.imageUrls),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned.fill(
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7)
                            ],
                                        begin: Alignment.center,
                                        end: Alignment.bottomCenter)))),
                        Positioned(
                            bottom: 30,
                            left: 30,
                            right: 0,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Owned by: ${resto.ownership}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  Text('Cooking Style: ${resto.cuisines}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ])),
                        AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            iconTheme: IconThemeData(color: Colors.white),
                            title: Center(
                                child: Icon(Icons.fastfood_sharp,
                                    color: Colors.white, size: 40)),
                            actions: [
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.pending,
                                      color: Colors.white, size: 30))
                            ])
                      ],
                    ))),
            Expanded(
                child: Column(
              children: [
                DetailsRatingBar(resto: resto),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Text('${resto.description}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      DetailsBottomActions()
                    ]))
              ],
            ))
          ],
        ));
  }
}

// detail_page widget section

class DetailsRatingBar extends StatefulWidget {
  final dynamic resto;
  const DetailsRatingBar({Key? key, required this.resto}) : super(key: key);

  @override
  _DetailsRatingBarState createState() => _DetailsRatingBarState();
}

class _DetailsRatingBarState extends State<DetailsRatingBar> {
  Restaurant get resto => widget.resto;

  @override
  Widget build(BuildContext context) {
    var sampleRatingData = {
      'Rating': '${resto.stars}',
      'Price': 'Rwf ${resto.priceRange}',
      'Hours': '24/7'
    };

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              sampleRatingData.entries.length,
              (index) => Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2), width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text(sampleRatingData.entries.elementAt(index).key,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(sampleRatingData.entries.elementAt(index).value,
                            style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                  ))),
    );
  }
}

class DetailsBottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(children: [
          Expanded(
              child: Material(
                  borderRadius: BorderRadius.circular(15),
                  color: mainColor,
                  child: InkWell(
                    highlightColor: Colors.white.withOpacity(0.2),
                    splashColor: Colors.white.withOpacity(0.2),
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.all(21),
                        child: Text('Place your Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF476930), width: 2)),
              child: Icon(Icons.shopping_cart_sharp,
                  color: Color(0xFF476930), size: 25))
        ]));
  }
}
