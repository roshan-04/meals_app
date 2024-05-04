//9
import 'package:flutter/material.dart';
import 'package:meals_app/screens/meal_details.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:meals_app/widgets/meal_item_trait.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(BuildContext context, Meal meal) onSelectMeal;

  String get complexityText {
    //name is used to access the key of enum and [0] used to access the first character
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1); //hello + world => hello world
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        //to set the rounded border to the card
        borderRadius: BorderRadius.circular(8),
      ),
      //now if you see the shape here doesn't work because the stack by default ignores it and hence we will have to add a paratermer so that it aceepts the shape
      clipBehavior: Clip.hardEdge,
      //this cuts the content that comes out of the rounded shape
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(context,meal);
        },
        child: Stack(
          children: [
            Hero( //hero widget is used to animate widgets across different screens
              tag: meal.id, //used to identify on this screen and target screen
              child: FadeInImage(
                //fadeinimage and memoryimage are a class given by flutter
                //fadeinimage is faded in image, and gives us a dummy image which is transparent adn nothing to something on screen
                //background black color before image is showed is shown using tranparent image package
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
                //cover means that if image goes out of the container then extra portion is cut off
                height: 200,
                //height gives fixed height to the image
                width: double
                    .infinity, //to tell the image to take as much as width as possible
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      softWrap: true,
                      //to wrap the text in good looking way
                      maxLines: 2,
                      //if string is too long then how many times it should be displayed
                      overflow: TextOverflow.ellipsis,
                      //how to end the lines after 2 lines if string is still remaining
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //we cant use a row inside of a row(we use expanded to do so) hence we use it by putting in MealItemTrait and also
                      //here it is inside column which is inside of positioned widget left & right set to 0, therefore positioned enforces its child i.e. container to
                      //take exactly that width between that left and right border of that stack
                      // and hence we have fixed with which is passed container which is passed to column and then to row
                      //and hence it is contrained horizontaly and hence no problem for row having inside
                      children: [
                        //MealItemTrait(icon: Icons.schedule, label: meal.duration.toString()), //since duration is an integer and label takes a string we convert it to string using .toString() or alternatively
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration} min',
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                          icon: Icons.work,
                          label:
                              complexityText, //complexity should be shown in upper case letter hence we use getter to make first letter capital
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          label:
                              affordabilityText, //complexity should be shown in upper case letter hence we use getter to make first letter capital
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
