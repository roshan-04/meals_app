//2
import 'package:flutter/material.dart';

import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/widgets/categories_grid_item.dart';
import '../models/category.dart';
import '../models/meal.dart';
import 'meals.dart';

//to add animation to a class we will have to make it statefulWidget

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    //required this.onToggleFavorite,
    required this.availableMeals,
  });

  //final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //we are now in state object of the widget, because behind the scenes an animation
  //sets the state and updates teh UI all the time as long as animation is playing which is why we need statefulWidget so that it can update some state behind the scenes

  //to tell dart this value doesnt have the value initially when the class is created, but will have one before it's really needed hence we use late keyword
  //late -> tells dart that this will have value as soon as it is used first time, but not yet when the class is created
  late AnimationController
      _animationController; // we store value of type animationController and use initState to set it
  //create animationController in initState
  //_animationController doesnt call the build method multiple times but its a timer or an interval running behind the scenes to which you can listen to then manually update parts of the UI
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      //vsync wants a TickerProvider, vsync parameter is responsible for making sure that this animation
      //for every frame (60 times per second), to provide a smooth animation
      //TickerProvider is received by a special feature offered in dart, with key word used to mixin a class in our class i.e. merge
      //SingleTickerProviderStateMixin provides features that are needed by Flutter's animation system and if we had multiple animationController and not one then right choice would be TickerProviderStateMixin
      vsync: this,
      //this means this entire class in which SingleTickerProvider is merged so that it gets the entire frame rate information to fire our animation once per frame
      duration: const Duration(milliseconds: 300),
      //0 and 1 are by default value
      lowerBound: 0,
      //lower and upperbound is used to decide between which values flutter will animate
      upperBound:
          1, //with animation we will animate between two values, then its your job to change these values into something that changes something on the screen
    );
    //.stop() if you want to pause it while its playing. Eg: when user tapped some widget or anything like this
    _animationController
        .forward(); //to start it you all .forward() and play it till end unless you stopped it in between
    //.repeat() is used to repeat the animation always restart it once its done
  }

  @override
  void dispose() {
    //is called automatically behind the scenes, but we can override to then still
    //call parents widgets method behind the scenes but to then also perform your own cleanup work
    _animationController
        .dispose(); //this will make sure that the _animationController is removed from the device memory once this widget is removed to make sure we dont cause any memory overflows
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    /*
    since CategoriesScreen is a StatelessWidget the context is not available globally
    //thus we pass BuildContext context to this function and use Navigator.push(context, route)
    Alternatively we can also use Navigator.push(context, route);
     */
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          //onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //we use AnimatedBuilder to update the UI that takes animation, builder
    //Other method would  be AnimatedBuilder(animation: _animationController, builder: () => GridView());
    //(context, child) => GridView() will be executed for every tick of oue animation, inside the function you can update padding, margin or whatever value you need to animate
    return AnimatedBuilder(
      //but when we go to filters screen and come back animation doesnt happen becuase categories screen was not removed it was on stack and filters screen on top of it
      //that different for favorites screen, animation restarts when the widget is readded to the screen
      //initState if called only once when widget is added
      animation: _animationController,
      //this will tell AnimatedBuilder when it should call the builder
      //we have put GridView here because, child: to put any widget that should be output as part of animated content but that should not animated themselves and this allows to improve the performance by making sure that not all the items
      //that are part of animated item are rebuilt, and reevaluated as long as the animation is running
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.5,
        ),
        children: [
          //putting the dummy data from dummy_data.dart in GridItem
          /*
            using for loop here is an alternative to using map
            availableCategories.map((category) => CategoryGridItem(category: category)).toList(),
            here to use map we use map on availableCategories and for each category reveived we pass it to
            GridItem and then convert it to list.
          */
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      //flutter has many transitions, we can use below approach to add more features and capabilities and a bit optimised
      builder: (context, child) => SlideTransition(
        //other method for using tween()
        position: Tween(
          begin: const Offset(0, 0.3),
          //Offset(dx, dy), 0 means no offset and 1 means offset by 100%
          end: const Offset(0,
              0), //this is 0,0 because the position at which gridview should be
        ).animate(
          CurvedAnimation(
            //CurvedAnimation is an object used to create such animation with the help of .animate() method
            parent: _animationController, // thing that controls the animation
            curve: Curves
                .easeInOut, //this controls how the transition between the begin and the end state will be spread over teh available animation time
          ),
        ),

        // position: _animationController.drive(
        //   Tween(
        //     begin: const Offset(0, 0.3),
        //     //Offset(dx, dy), 0 means no offset and 1 means offset by 100%
        //     end: const Offset(0, 0), //this is 0,0 because the position at which gridview should be
        //   ), //tween class creates the tween object
        // ),
        //position is an animation that animates an offset, offset is a special value that describe an offset of element from the actual position it would normally take
        //drive() method is used to build an animation based on some other value, between two offsets
        child: child,
      ),

      // builder: (context, child) => Padding(
      //     padding: EdgeInsets.only(
      //       //padding value should be set dynamically based on the bound values between which I'm animating. The animation value will start at the vlaue of 0 and end after 300 milliseconds at the value of 1
      //       //_animationController.value will be 0 to 1
      //       //so this will be like from bottom to up its coming
      //       //to play the animation we will have to explicitly start it, and this can be done in initState
      //       top: 100 - _animationController.value * 100,
      //     ),
      //     child: child),
    );
  }
}
