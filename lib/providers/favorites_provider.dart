import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal.dart';

//StateNotifier is a generic class hence we put what type of data will be managed by StateNotifier and ultimately by StateNotifierProvider in angular brackets StateNotifier<List<Meal>>
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  //initial value to be initialised and all the methods used to change this list
  FavoriteMealsNotifier()
      : super([]); //constructor function to initialise the list

  //methods we want to edit this data
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(
        meal); //check whether meal is in state or not returns true or false

    if (mealIsFavorite) {
      //state is globally available made available by StateNotifier, which holds the data, in this case it is list
      //add, remove it not applicable on state instead replace will work or reassign to a new list no matter adding a meal or removing a meal
      //to remove a favorite, with .where() we filter a list and get a new iterable which is converted to list using .toList()
      //true to keep it and false to drop it,
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      //... spread operator
      state = [...state, meal]; //keep existing list add a new meal
      return true;
    }
    //we are updating the state in immutable way, i.e. without mutating, without editing the existing state in memory
  }
}

//the basic idea to create a provider is to store the favorite meals in the list of favorite meals
//we are not using this -> final mealsProvider = Provider((ref) because
//it is great if you have a list that never changes, but if you have
//where the data changes then StateNotifierProvider is great, the syntax is a follows
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier(); //this returns the instance of the class
});
