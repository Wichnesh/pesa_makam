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
              title: const Text('Add Category'),
              content: TextField(
                controller: controller.categoryNameController,
                decoration: const InputDecoration(hintText: 'Category Name'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add the category
                    String categoryName =
                        controller.categoryNameController.text.trim();
                    if (categoryName.isNotEmpty) {
                      controller
                          .saveCategoriesToFirestore(categoryName);
                      // Close the dialog
                      setState(() {
                        controller.categoryNameController.text = "";
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
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
              title: const Text('Delete Category'),
              content: const Text('Are you sure you want to delete this category?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Delete the category
                    controller.deleteCategory(categoryName);
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
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
        title: const Text('Categories'),
        backgroundColor: primarycolor,
      ),
      body: GetBuilder<CategoriesController>(
        builder: (controller) => controller.isloading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.categories.isEmpty
                ? const Center(
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
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Delete the category
                                _showDeleteCategoryDialog(controller.categories[index]);
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
