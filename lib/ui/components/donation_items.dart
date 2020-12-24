import 'package:flutter/material.dart';

class DonationItem {
  const DonationItem(
      {@required this.name, @required this.description, @required this.amount})
      : assert(name != null),
        assert(description != null),
        assert(amount != null);
  final String name;
  final String description;
  final int amount;
}

List<DonationItem> donationItems = [
  DonationItem(name: "Tea", description: "A cup of tea", amount: 10),
  DonationItem(name: "Coffee", description: "A cup of coffee", amount: 40),
  DonationItem(name: "Snacks", description: "For the tea/coffee", amount: 90),
  DonationItem(name: "Small Meal", description: "For one person", amount: 150),
  DonationItem(
      name: "Normal Meal", description: "For one developer", amount: 280),
  DonationItem(
      name: "Jumbo Meal", description: "For two developers", amount: 500),
  DonationItem(name: "Full Meal", description: "For the team", amount: 890),
  DonationItem(
      name: "Supernova", description: "This is not a meal", amount: 1450),
];
