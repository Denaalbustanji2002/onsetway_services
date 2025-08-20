import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureCardModel {
  final String title;
  final String description;
  final IconData icon;
  final String image;
  final Color accentColor;
  final List<String> bulletPoints;

  FeatureCardModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
    required this.bulletPoints,
    this.accentColor = Colors.white,
  });
}
