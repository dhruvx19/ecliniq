import 'package:flutter/material.dart';

class FamilyMember {
  final String name;
  final String relation;
  final String image;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.image,
  });
}



class FamilySelectionProvider extends ChangeNotifier {
  final List<FamilyMember> _familyMembers = [
    FamilyMember(
      name: 'Ketan Patni',
      relation: 'Self',
      image: 'https://i.pravatar.cc/150?img=12',
    ),
    FamilyMember(
      name: 'Archana Patni',
      relation: 'Mother',
      image: 'https://i.pravatar.cc/150?img=47',
    ),
    FamilyMember(
      name: 'Devendra Patni',
      relation: 'Father',
      image: 'https://i.pravatar.cc/150?img=33',
    ),
    FamilyMember(
      name: 'Raj Patni',
      relation: 'Brother',
      image: 'https://i.pravatar.cc/150?img=13',
    ),
    FamilyMember(
      name: 'Priya Patni',
      relation: 'Sister',
      image: 'https://i.pravatar.cc/150?img=28',
    ),
    FamilyMember(
      name: 'Amit Patni',
      relation: 'Uncle',
      image: 'https://i.pravatar.cc/150?img=51',
    ),
    FamilyMember(
      name: 'Sneha Patni',
      relation: 'Aunt',
      image: 'https://i.pravatar.cc/150?img=44',
    ),
  ];

  List<FamilyMember> get familyMembers => _familyMembers;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  FamilyMember get selectedMember => _familyMembers[_selectedIndex];

  void selectMember(int index) {
    if (_selectedIndex != index && index >= 0 && index < _familyMembers.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}