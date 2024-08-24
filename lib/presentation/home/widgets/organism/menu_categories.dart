import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onlineshop_app/presentation/category/presentation/catering_category.dart';
import 'package:flutter_onlineshop_app/presentation/category/presentation/ice_category.dart';

import '../../../../core/core.dart';
import '../../../category/presentation/beverage_category.dart';
import '../../../category/presentation/cake_category.dart';
import '../../bloc/category/category_bloc.dart';
import '../category_button.dart';

class MenuCategories extends StatefulWidget {
  const MenuCategories({super.key});

  @override
  State<MenuCategories> createState() => _MenuCategoriesState();
}

class _MenuCategoriesState extends State<MenuCategories> {
  @override
  void initState() {
    // context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          return Row(
          children: [
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuCatering.path,
                label: 'Catering & Snack',
                onPressed: () {
                  Navigator.push(
                      context,
                  MaterialPageRoute(builder:
                  (context) => CateringCategory(),
                  ),
                  );
                },
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuCake.path,
                label: 'Cake & Bakery',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:
                        (context) => CakeCategory(),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuBeverage.path,
                label: 'Beverage',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:
                        (context) => BeverageCategory(),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuIceCream.path,
                label: 'Ice Cream',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:
                        (context) => IceCreamCategory(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    //   },
    // );
  }
}
