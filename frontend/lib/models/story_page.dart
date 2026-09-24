class ChoiceOption {
  final String id;
  final String text;
  final String actionPrompt;

  ChoiceOption({required this.id, required this.text, required this.actionPrompt});

  factory ChoiceOption.fromJson(Map<String, dynamic> json) {
    return ChoiceOption(
      id: json['id'],
      text: json['text'],
      actionPrompt: json['action_prompt'],
    );
  }
}

class StoryPage {
  final int pageId;
  final String narrativeText;
  final String imageUrl;
  final String audioUrl;
  final List<ChoiceOption> choices;

  StoryPage({
    required this.pageId,
    required this.narrativeText,
    required this.imageUrl,
    required this.audioUrl,
    required this.choices,
  });

  factory StoryPage.fromJson(Map<String, dynamic> json) {
    return StoryPage(
      pageId: json['page_id'],
      narrativeText: json['narrative_text'],
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      choices: (json['choices'] as List)
          .map((c) => ChoiceOption.fromJson(c))
          .toList(),
    );
  }
}
