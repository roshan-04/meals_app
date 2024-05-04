//11
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal.dart';
import 'package:meals_app/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  //replace statelessWidget with consumerwidget
  const MealDetailsScreen({
    super.key,
    required this.meal,
    //required this.onToggleFavorite,
  });

  final Meal meal;

  //final void Function(Meal meal) onToggleFavorite;

  @override
  //WidgetRef is to get ref used to listening to Provider which is not required in ConsumerStateful becuase we have the consumerState class globally available in that class
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              //we use read not watch to not set up an ongoing listener because inside of such a function tht would be a problematic but instead read a value once
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(
                      meal); //.notifier is used to get access to teh Notifier class we made which ofcourse has the toggleMealFavoriteStatus methods in it
              //onToggleFavorite(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      wasAdded ? 'Meal added as a favorite' : 'Meal removed'),
                ),
              );
            },
            //since we have the favorites we will have to manage state for add or remove
            //items from favorites hence we do it but not in meal_details file because
            //we need this information which is favorite or not in tabs screen but in this file its very difficult
            icon: AnimatedSwitcher(
              //animatedSwitcher is focused on transitioning between two values
              duration: const Duration(milliseconds: 300),
              //child, animation will be provided by flutter in transiitonBuilder
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(animation),
                  //turns: animation,
                  child: child,
                ); //this child is whatever is set as child i.e. Icon()
                //how we wanna animate whenever the button changes
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ), //change the icon based on favorite status
            ), //implicit animation are pre built animation given by flutter
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //Now here since it is not scrollable we get pixel overflow
          //hence this problem can be solved using just ListView instead of column or singleChildScrollView

          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
