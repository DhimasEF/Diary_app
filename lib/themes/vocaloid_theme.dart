import 'package:flutter/material.dart';

class VocaloidTheme {
  final String bg;
  final String sticker;
  final Color accent;

  VocaloidTheme({
    required this.bg,
    required this.sticker,
    required this.accent,
  });
}

final Map<int, VocaloidTheme> monthThemes = {
  1: VocaloidTheme(
    bg: 'assets/themes/ichika/jan_bg.jpg',
    sticker: 'assets/themes/ichika/ichika.png',
    accent: Color.fromARGB(255, 15, 81, 143),
  ),
  2: VocaloidTheme(
    bg: 'assets/themes/saki/feb_bg.jpg',
    sticker: 'assets/themes/saki/saki.png',
    accent: Color.fromARGB(255, 230, 226, 22),
  ),
  3: VocaloidTheme(
    bg: 'assets/themes/mafuyu/mar_bg.jpg',
    sticker: 'assets/themes/mafuyu/mafuyu.png',
    accent: Color.fromARGB(255, 192, 20, 183),
  ),
  4: VocaloidTheme(
    bg: 'assets/themes/kanade/apr_bg.jpg',
    sticker: 'assets/themes/kanade/kanade.png',
    accent: Color.fromARGB(255, 134, 148, 147),
  ),
  5: VocaloidTheme(
    bg: 'assets/themes/airi/mei_bg.jpg',
    sticker: 'assets/themes/airi/airi.png',
    accent: Color.fromARGB(255, 230, 49, 79),
  ),
  6: VocaloidTheme(
    bg: 'assets/themes/emu/juni_bg.jpg',
    sticker: 'assets/themes/emu/emu.png',
    accent: Color.fromARGB(255, 211, 89, 150),
  ),
  7: VocaloidTheme(
    bg: 'assets/themes/ena/juli_bg.jpg',
    sticker: 'assets/themes/ena/ena.png',
    accent: Color.fromARGB(255, 97, 62, 9),
  ),
  8: VocaloidTheme(
    bg: 'assets/themes/haruka/agus_bg.jpg',
    sticker: 'assets/themes/haruka/haruka.png',
    accent: Color.fromARGB(255, 13, 94, 185),
  ),
  9: VocaloidTheme(
    bg: 'assets/themes/kohane/sept_bg.jpg',
    sticker: 'assets/themes/kohane/kohane.png',
    accent: Color.fromARGB(255, 214, 212, 62),
  ),
  10: VocaloidTheme(
    bg: 'assets/themes/nene/okt_bg.jpg',
    sticker: 'assets/themes/nene/nene.png',
    accent: Color.fromARGB(255, 66, 206, 85),
  ),
  11: VocaloidTheme(
    bg: 'assets/themes/miku/nov_bg.jpg',
    sticker: 'assets/themes/miku/miku.png',
    accent: Color(0xFF39C5BB),
  ),
  12: VocaloidTheme(
    bg: 'assets/themes/rin/dec_bg.jpg',
    sticker: 'assets/themes/rin/rin.png',
    accent: Colors.orangeAccent,
  ),
};
