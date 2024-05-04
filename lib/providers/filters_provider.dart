import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';
//we will build a provider that depends on another provider

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          //setting an initial state to the parent class FiltersNotifier
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state =
        chosenFilters; //this function gets a new map then we override the existing map
  }

  void setFilter(Filter filter, bool isActive) {
    //state[Filter] = isActive; //this is not allowed, because we have to do it in immutable way but this mutates it
    state = {
      ...state,
      filter: isActive,
    }; //Now we have to set the state to a new map with the updated key
    //copy the existing map, and its existing key-value pairs with the spread operator into a new map and then explicitly set one key to a new value
    //this will override the key value pair with the same filter identifier that has been copied and all the other key value pairs will be kept along with this new setting here
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

//multiple providers can be in same file
//filteredMealsProvider depends on filterProvider and also mealsProvider
final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    } //instead of this write this -> activeFilters[Filter.vegan]!
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
    //.toList() returns an list and not iterable
  }).toList();
});
