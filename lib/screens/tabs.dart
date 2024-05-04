//12
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';

import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import '../data/dummy_data.dart';

//import '../models/meal.dart';
import '../widgets/main_drawer.dart';
import 'package:meals_app/providers/meals_provider.dart';

//we are creating an already filtered list of meals adn then can be filtered a bit more
//for a fitting category instead of the categories screen
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  //for using provider we replace StatefulWidget with ConsumerStatefulWidget and State with consumerState
  //if widget is statelesswidget then we use ConsumerWidget
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends ConsumerState<TabsScreen> {
  int _selectPageIndex = 0;

  //final List<Meal> _favoriteMeals = [];
  //Map<Filter, bool> _selectedFilters = kInitialFilters;

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  //Shifted to mealsDetails widget in ref.read()
  // }

  // //this data will be sent to meal_details
  // void _toggleMealFavoriteStatus(Meal meal) {
  //   //doing this means we are managing the state, so we will learn in next course section to manage state using provider or bloc or other but here will try by different functions
  //   //.contain is to determine whether the given meal is a part of _favoriteMeals or not?
  //   final isExisting = _favoriteMeals.contains(meal); //
  //
  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals
  //           .remove(meal); //remove from favorites if already marked favorite
  //     });
  //     _showInfoMessage('Meal is not longer a favorite');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal); //add to favorites if not marked favorite
  //       _showInfoMessage('Meal is marked favorite');
  //     });
  //   } //tab screen doesn't have the direct access to the meal_details screen, instead it has access to only categories and mealsScreen but these both in the end reach meal_details screen
  // }

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    //main_drawer can communicate with tabsScreen
    //when listTile will be tapped then then _setScreen will be executed and then diff identifier will be passed by _setScreen
    if (identifier == 'filters') {
      //Navigator.of(context)
      //           .pushReplacement(MaterialPageRoute(builder: (context) => const FiltersScreen()));

      //push returns a future and also a dynamic value i.e. generic
      //it receives a future from pop of filters WillPopScope
      //we wait to receive the data, hence await
      await Navigator.of(
              context) //here we pass extra details to push by telling it what type of data it will receive, Syntax is as follows
          .push<Map<Filter, bool>>(MaterialPageRoute(
              builder: (context) => const FiltersScreen(
                  //currentFilters: _selectedFilters,
                  )));
      // setState(() {
      //   //?? means result could be null and null cant be a value of _selectedFilters hence we use ?? to that we can store the value which is right to ?? in _selectedFilters if result is null
      //   //_selectedFilters = result ?? kInitialFilters;//used to show meals after we choose the category on categories screen
      // });
    }
    /*
    else { //Navigator from here is removed and placed on top so that when we pop from filters screen the drawer is withdrawn automatically
      Navigator.of(context).pop();
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    //ref is a property provided by riverpod because we are extending ConsumerStateWidget
    //ref allows us to set listeners,
    //with ref we can do a couple of utility methods like read() and watch(), though according to riverpod teams we should use most of the times watch()
    //because this way you ever change your logic you cannot run into unintended bugs where you forgot to replace a read with a watch, thats why you use watch() from very beginning
    final meals = ref.watch(
        mealsProvider); //therefore we have set a listener that will re-execute the build method when the data in mealsProvider is changed
    final activeFilters = ref.watch(filtersProvider);

    //we make provider dependent on another by using below method
    final availableMeals = ref.watch(filteredMealsProvider);

    // final availableMeals = meals.where((meal) {
    //   if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
    //     return false;
    //   } //instead of this write this -> activeFilters[Filter.vegan]!
    //   if (activeFilters[Filter.vegan]! && !meal.isVegan) {
    //     return false;
    //   }
    //   return true;
    //   //.toList() returns an list and not iterable
    // }).toList(); //dummyMeals should be available meal such that _selectedFilter is taken into account
    //where() allows us to filter a list
    Widget activePage = CategoriesScreen(
      //onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePageTitle = 'Your Favorites';
      activePage = MealsScreen(
        meals: favoriteMeals,
        //meals: _favoriteMeals, //favorites should always be visible
        //onToggleFavorite: _toggleMealFavoriteStatus,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex, //highlight the tab selected
        items: const [
          //using Icon() we build the icon
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
