import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/categoriescontroller.dart';
import '../../../utils/colorUtils.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Function to show the dialog box
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategoriesController>(
          builder: ((controller) {
            return AlertDialog(
              title: Text('Add Category'),
              content: TextField(
                controller: controller.categoryNameController,
                decoration: InputDecoration(hintText: 'Category Name'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add the category
                    String categoryName =
                        controller.categoryNameController.text.trim();
                    if (categoryName.isNotEmpty) {
                      controller.addCategories(
                          [categoryName]); //Pass the category as a list
                      controller
                          .saveCategoriesToFirestore(controller.categories);
                      // Close the dialog
                      setState(() {
                        controller.categoryNameController.text = "";
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _showDeleteCategoryDialog(String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategoriesController>(
          builder: ((controller) {
            return AlertDialog(
              title: Text('Delete Category'),
              content: Text('Are you sure you want to delete this category?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Delete the category
                    controller.deleteCategory(categoryName);
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<CategoriesController>(
        builder: (controller) => controller.isloading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : controller.categories.isEmpty
                ? Center(
                    child: Text('No Category available'),
                  )
                : ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              controller.categories[index],
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Delete the category
                                controller.deleteCategory(
                                    controller.categories[index]);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primarycolor,
        onPressed: () {
          _showAddCategoryDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
