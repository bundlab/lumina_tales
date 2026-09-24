import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/story_provider.dart';
import 'screens/reader_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryProvider()),
      ],
      child: const LuminaTalesApp(),
    ),
  );
}

class LuminaTalesApp extends StatelessWidget {
  const LuminaTalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuminaTales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: "Leo");
    final themeController = TextEditingController(text: "Magic Flying Castle");

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_stories, size: 100, color: Colors.purple),
              const SizedBox(height: 16),
              const Text("LuminaTales", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 8),
              const Text("AI Interactive Storybook for Kids", style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Child's Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: themeController,
                decoration: const InputDecoration(labelText: "Story Theme / World", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.stars),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                label: const Text("Create Story World", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Provider.of<StoryProvider>(context, listen: false).startNewStory(
                    nameController.text,
                    themeController.text,
                    6,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReaderScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
