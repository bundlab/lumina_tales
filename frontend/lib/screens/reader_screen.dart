import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/story_provider.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context);
    final page = storyProvider.currentPage;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text("✨ LuminaTales Reader", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: storyProvider.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(color: Colors.amber, size: 80.0),
                  SizedBox(height: 20),
                  Text("Weaving your next magical chapter...", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                ],
              ),
            )
          : page == null
              ? const Center(child: Text("No story loaded."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              child: page.imageUrl.isNotEmpty
                                  ? Image.network(page.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover)
                                  : Container(height: 250, color: Colors.purple.shade100, child: const Icon(Icons.image, size: 80, color: Colors.purple)),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton.filled(
                                        iconSize: 40,
                                        icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                                        color: Colors.purple,
                                        onPressed: () => _playAudio(page.audioUrl),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Tap to Listen", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                                    ],
                                  ),
                                  const Divider(height: 30),
                                  
                                  Text(
                                    page.narrativeText,
                                    style: const TextStyle(fontSize: 20, height: 1.5, fontFamily: 'Georgia', color: Colors.black80),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text("What should happen next?", 
                        textAlign: TextAlign.center, 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 12),

                      ...page.choices.map((choice) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            padding: const EdgeInsets.vertical(16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => storyProvider.chooseOption(choice),
                          child: Text(choice.text, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )),
                    ],
                  ),
                ),
    );
  }
}
