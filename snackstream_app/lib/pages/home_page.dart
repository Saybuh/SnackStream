import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_current_location.dart';
import '../components/my_description_box.dart';
import '../components/my_drawer.dart';
import '../components/my_food_tile.dart';
import '../components/my_sliver_appbar.dart';
import '../components/my_tab_bar.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import 'food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sorts out and returns a list of food items that belong to a
  // specific category from a larger list of food items.
  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  // go to food page
  void goToFood(Food food) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FoodPage(food: food)));
  }

  // return list of foods in given category
  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return FoodTile(
            food: categoryMenu[index],
            onTap: () => goToFood(categoryMenu[index]),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, value, child) {
        final fullMenu = value.menu;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          drawer: const MyDrawer(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              MySliverAppBar(
                title: MyTabBar(tabController: _tabController),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Theme.of(context).colorScheme.secondary,
                    ),

                    // switch
                    MyCurrentLocation(),

                    // description box
                    const MyDescriptionBox()
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: getFoodInThisCategory(fullMenu),
            ),
          ),
        );
      },
    );
  }
}
