import '../model/categoryModel.dart';

// Proses Fecthing Data
List<CategoryModel> getCategories() {
  // new list
  List<CategoryModel> categories = <CategoryModel>[];
  CategoryModel category = CategoryModel(imageUrl: '', categoryName: '');

  category.categoryName = "Japanese";
  category.imageUrl =
      'https://images.pexels.com/photos/670705/pexels-photo-670705.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categories.add(category);

  category = new CategoryModel(categoryName: '', imageUrl: '');
  category.categoryName = "Indian";
  category.imageUrl =
      "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
  categories.add(category);

  category = new CategoryModel(categoryName: '', imageUrl: '');
  category.categoryName = "Indonesian";
  category.imageUrl =
      "https://images.pexels.com/photos/106343/pexels-photo-106343.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
  categories.add(category);

  category = new CategoryModel(categoryName: '', imageUrl: '');
  category.categoryName = "Chinese";
  category.imageUrl =
      'https://images.pexels.com/photos/1907228/pexels-photo-1907228.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2';
  categories.add(category);

  category = new CategoryModel(categoryName: '', imageUrl: '');
  category.categoryName = "Italian";
  category.imageUrl =
      "https://images.pexels.com/photos/1653877/pexels-photo-1653877.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
  categories.add(category);

  category = new CategoryModel(categoryName: '', imageUrl: '');
  category.categoryName = "Western";
  category.imageUrl =
      "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
  categories.add(category);

  return categories;
}
