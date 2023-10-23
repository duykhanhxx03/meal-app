import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarianFree,
  vegan,
}

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarianFree: false,
  Filter.vegan: false
};

class FiltersProvider extends StateNotifier<Map<Filter, bool>> {
  FiltersProvider() : super(kInitialFilters);

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filter filter, bool isActived) {
    state = {
      ...state,
      filter: isActived,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProvider, Map<Filter, bool>>(
        (ref) => FiltersProvider());

final filterMealsProvider = Provider((ref) {
  final meals = ref.read(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarianFree]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
