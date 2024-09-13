import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCentreController extends GetxController {
  static SearchCentreController get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<UserModel> allRecyclingCenters = <UserModel>[].obs;
  final RxList<UserModel> recyclingCenters = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  final TextEditingController textSearch = TextEditingController();

  final RxList<bool> selectedFilter = [false, true].obs;
  final RxList<String> recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecyclingCenters();
    textSearch.addListener(() {
      search(textSearch.text);
    });
  }

  void toggleFilter(int index) {
    for (int buttonIndex = 0;
        buttonIndex < selectedFilter.length;
        buttonIndex++) {
      if (buttonIndex == index) {
        selectedFilter[buttonIndex] = true;
      } else {
        selectedFilter[buttonIndex] = false;
      }
    }
    update();
  }

  void search(String searchText) {
    if (searchText.isEmpty) {
      recyclingCenters.assignAll(allRecyclingCenters);
    } else {
      if (selectedFilter[0]) {
        filterByName(searchText);
      } else {
        filterByAddress(searchText);
      }
    }
  }

  void addToRecentSearches(String searchText) {
    // Ajouter le terme de recherche actuel aux recherches récentes
    if (searchText.isNotEmpty && !recentSearches.contains(searchText)) {
      recentSearches.insert(0, searchText);
    }
  }

  Future<void> getRecyclingCenters() async {
    try {
      isLoading.value = true;

      final querySnapshot = await _db.collection("Centres").get();
      final List<UserModel> users =
          querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
      allRecyclingCenters.assignAll(users);
      recyclingCenters.assignAll(allRecyclingCenters);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  void filterByName(String searchText) {
    recyclingCenters.assignAll(allRecyclingCenters
        .where((center) =>
            center.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList());
  }

  void filterByAddress(String searchText) {
    recyclingCenters.assignAll(allRecyclingCenters
        .where((center) =>
            center.adress.toLowerCase().contains(searchText.toLowerCase()))
        .toList());
  }
}
