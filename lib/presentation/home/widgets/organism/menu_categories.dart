import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
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
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<CategoryBloc, CategoryState>(
    //   builder: (context, state) {
    //     return state.maybeWhen(
    //       loaded: (categories) => Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           ...categories.map(
    //             (category) => Flexible(
    //               child: CategoryButton(
    //                 imagePath: category.image!,
    //                 label: category.name!,
    //                 onPressed: () {},
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       orElse: () => const SizedBox.shrink(),
    //       loading: () => const Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //       error: (message) => Center(
    //         child: Text(message),
    //       ),
    //     );
          return Row(
          children: [
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuCatering.path,
                label: 'Catering & Snack',
                onPressed: () {},
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuCake.path,
                label: 'Cake & Bakery',
                onPressed: () {},
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuBeverage.path,
                label: 'Beverage',
                onPressed: () {},
              ),
            ),
            Flexible(
              child: CategoryButton(
                imagePath: Assets.images.categories.menuIceCream.path,
                label: 'Ice Cream',
                onPressed: () {},
              ),
            ),
          ],
        );
    //   },
    // );
  }
}
