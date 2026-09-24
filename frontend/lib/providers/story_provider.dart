import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/story_page.dart';

class StoryProvider extends ChangeNotifier {
  final String baseUrl = "http://10.0.2.2:8000/api/v1";
  
  StoryPage? _currentPage;
  bool _isLoading = false;

  StoryPage? get currentPage => _currentPage;
  bool get isLoading => _isLoading;

  Future<void> startNewStory(String name, String theme, int age) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/story/start'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'child_name': name, 'theme': theme, 'age_group': age}),
      );

      if (response.statusCode == 200) {
        _currentPage = StoryPage.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error starting story: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> chooseOption(ChoiceOption choice) async {
    if (_currentPage == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/story/continue'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'story_id': 'active_story',
          'current_page_id': _currentPage!.pageId,
          'selected_choice_id': choice.id,
        }),
      );

      if (response.statusCode == 200) {
        _currentPage = StoryPage.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error making choice: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
