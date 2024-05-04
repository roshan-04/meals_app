//14
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:meals_app/screens/tabs.dart';
//import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/filters_provider.dart';

// enum Filter {
//   glutenFree,
//   lactoseFree,
//   vegetarian,
//   vegan,
// }

//so instead of changing the state in local we can update the provider based on applied fliter and then update the widget
//hence we convert the ConsumerStatefulWidget to ConsumerWidget
class FiltersScreen extends ConsumerWidget {
  //replace statefulwidget with consumerstatefulwidget
  const FiltersScreen({
    super.key,
    //required this.currentFilters,
  });

//
//   //final Map<Filter, bool> currentFilters;
//
//   @override
//   ConsumerState<FiltersScreen> createState() {
//     return _FiltersScreenState();
//   }
// }
//
// class _FiltersScreenState extends ConsumerState<FiltersScreen> {
//   var _glutenFreeFilterSet = false;
//   var _lactoseFreeFilterSet = false;
//   var _vegetarianFilterSet = false;
//   var _veganFilterSet = false;

  //we have a widget property to access the members of the widget class to state class
  //but this widget property can be used in only in methods of state class
  //hence we create initState()
  // @override
  // void initState() {
  //   //initState() is called only once hence we can use read
  //   super.initState(); //we read filtersProvider to manage our local state
  //   final activeFilters = ref.read(filtersProvider);
  //   _glutenFreeFilterSet = activeFilters[Filter.glutenFree]!;
  //   _lactoseFreeFilterSet = activeFilters[Filter.lactoseFree]!;
  //   _vegetarianFilterSet = activeFilters[Filter.vegetarian]!;
  //   _veganFilterSet = activeFilters[Filter.vegan]!;
  //   //we don't need to call setState because initState will execute before build method
  //   // _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree]!;
  //   // _lactoseFreeFilterSet = widget.currentFilters[Filter.lactoseFree]!;
  //   // _vegetarianFilterSet = widget.currentFilters[Filter.vegetarian]!;
  //   // _veganFilterSet = widget.currentFilters[Filter.vegan]!;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(
        filtersProvider); //we use watch because watch sets up a listener that reexecutes the build method, whenever the state in the provider changes
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: (identifier) {
      //     Navigator.of(context).pop();
      //     if (identifier == 'meals') {
      //       //There are 2 things you either push a new screen on top of other screen
      //       //or oyu replace a screen with current screen this can be does with pushReplacement, and remaining things remain same as normal push
      //       Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (context) => const TabsScreen()));
      //     }
      //   },
      // ),
      // body: WillPopScope(
      //   //when backbutton of device or in app is pressed then
      //   //we need to return the variable values so that the meals can be filtered
      //   //to tabsScreen so we need to know when user tapped the back button
      //   //so we use WillPopScope()
      //
      //   //futures are something that results eventually in some value
      //   //which is not there yet, and this will happen whenever the user tries to leave this screen
      //   //
      //   onWillPop: () async {
      //     ref.read(filtersProvider.notifier).setFilters({
      //       //here pop will go back to tabScreen hence the data will be passed there,
      //       //it will go to _setScreen in TabsScreen where we can access the returned data
      //       //here you can return any kind of data, here we are returning map
      //       //glutenFree are keys that stores true or false
      //       //from _glutenFreeFilterSet and others respectively
      //       Filter.glutenFree: _glutenFreeFilterSet,
      //       Filter.lactoseFree: _lactoseFreeFilterSet,
      //       Filter.vegetarian: _vegetarianFilterSet,
      //       Filter.vegan: _veganFilterSet,
      //     });
      //     return true;
      //     //function that return a future
      //     //Navigator.of(context).pop();
      //     //return false; //here we have to return true to confirm that we are returning back
      //     //but we have put false because we have manually used pop function, otherwise it will pop twice hence closing the app
      //   },
      //   child:
      body: Column(
        children: [
          SwitchListTile(
            value: activeFilters[Filter.glutenFree]!,
            //value: _glutenFreeFilterSet,
            //boolean, value is a changeable hence we need to do the needful
            onChanged: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, isChecked);
              //boolean function
              // setState(() {
              //   _glutenFreeFilterSet = isChecked;
              // });
            },
            //function that receives a boolean
            title: Text(
              'Gluten-free',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              'Only include gluten-free meals.',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(
              left: 34,
              right: 22,
            ),
          ),
          //this is optimised to be used in a list that shows a row in the list

          SwitchListTile(
            value: activeFilters[Filter.lactoseFree]!,
            //value: _lactoseFreeFilterSet,
            //boolean, value is a changeable hence we need to do the needful
            onChanged: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, isChecked);
              //boolean function
              // setState(() {
              //   _lactoseFreeFilterSet = isChecked;
              // });
            },
            //function that receives a boolean
            title: Text(
              'Lactose-free',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              'Only include lactose-free meals.',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(
              left: 34,
              right: 22,
            ),
          ),

          SwitchListTile(
            value: activeFilters[Filter.vegetarian]!,
            //value: _vegetarianFilterSet,
            //boolean, value is a changeable hence we need to do the needful
            onChanged: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, isChecked);
              //boolean function
              // setState(() {
              //   _vegetarianFilterSet = isChecked;
              // });
            },
            //function that receives a boolean
            title: Text(
              'Vegetarian',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              'Only include vegetarian meals.',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(
              left: 34,
              right: 22,
            ),
          ),

          SwitchListTile(
            value: activeFilters[Filter.vegan]!,
            //value: _veganFilterSet,
            //boolean, value is a changeable hence we need to do the needful
            onChanged: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegan, isChecked);
              //boolean function
              // setState(() {
              //   _veganFilterSet = isChecked;
              // });
            },
            //function that receives a boolean
            title: Text(
              'Vegan',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              'Only include vegan meals.',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(
              left: 34,
              right: 22,
            ),
          ),
        ],
      ),
    );
  }
}
