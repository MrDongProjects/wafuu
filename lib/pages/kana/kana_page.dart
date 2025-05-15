import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/audio_service.dart';
import '../../widgets/pressable_button.dart';

class KanaPage extends StatelessWidget {
  const KanaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppTheme.lanternEmoji),
              const SizedBox(width: 8),
              const Text('假名学习'),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.wasabiGreen,
            labelColor: AppTheme.wasabiGreen,
            unselectedLabelColor: AppTheme.secondaryText,
            labelStyle: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: screenWidth * 0.04,
              letterSpacing: 1,
            ),
            tabs: const [
              Tab(text: '平假名 ひらがな'),
              Tab(text: '片假名 カタカナ'),
              Tab(text: '浊音 だくおん'),
              Tab(text: '拗音 ようおん'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            KanaGridView(kanaList: hiraganaList),
            KanaGridView(kanaList: katakanaList),
            KanaGridView(kanaList: dakuonList),
            KanaGridView(
              kanaList: youonList,
              crossAxisCount: 3,
              isYouon: true,
            ),
          ],
        ),
      ),
    );
  }
}

class KanaGridView extends StatelessWidget {
  final List<KanaItem> kanaList;
  final int crossAxisCount;
  final bool isYouon;

  const KanaGridView({
    super.key,
    required this.kanaList,
    this.crossAxisCount = 5,
    this.isYouon = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize =
        (screenWidth - (32 + (crossAxisCount - 1) * 8)) / crossAxisCount;

    return Container(
      color: isDarkMode ? AppTheme.noriBlack : AppTheme.riceWhite,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: kanaList.length, // 保持原有长度以保持空位
        itemBuilder: (context, index) {
          final kana = kanaList[index];
          // 如果是空白项，返回透明的占位符
          if (kana.kana.isEmpty || kana.kana == ' ') {
            return const SizedBox();
          }

          return SizedBox(
            width: itemSize,
            height: itemSize,
            child: PressableButton(
              onTap: () => _playSound(context, kana.sound),
              padding: EdgeInsets.zero,
              backgroundColor: isDarkMode ? AppTheme.noriBlack : Colors.white,
              pressedColor: AppTheme.wasabiGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              borderColor: isDarkMode ? Colors.grey[800] : AppTheme.divider,
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        kana.kana,
                        style: TextStyle(
                          fontSize: isYouon ? 22 : 28,
                          fontWeight: FontWeight.w500,
                          color:
                              isDarkMode ? Colors.white : AppTheme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kana.romaji,
                        style: TextStyle(
                          fontSize: isYouon ? 12 : 14,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _playSound(BuildContext context, String soundPath) async {
    try {
      final audioService = AudioService();
      await audioService.playSound(soundPath);
    } catch (e) {
      debugPrint('播放音频失败: $e');
    }
  }
}

class KanaItem {
  final String kana;
  final String romaji;
  final String sound; // 音频文件路径

  const KanaItem({
    required this.kana,
    required this.romaji,
    required this.sound,
  });
}

// 平假名列表
const List<KanaItem> hiraganaList = [
  // あ行
  KanaItem(kana: 'あ', romaji: 'a', sound: 'sounds/hiragana/a.mp3'),
  KanaItem(kana: 'い', romaji: 'i', sound: 'sounds/hiragana/i.mp3'),
  KanaItem(kana: 'う', romaji: 'u', sound: 'sounds/hiragana/u.mp3'),
  KanaItem(kana: 'え', romaji: 'e', sound: 'sounds/hiragana/e.mp3'),
  KanaItem(kana: 'お', romaji: 'o', sound: 'sounds/hiragana/o.mp3'),
  // か行
  KanaItem(kana: 'か', romaji: 'ka', sound: 'sounds/hiragana/ka.mp3'),
  KanaItem(kana: 'き', romaji: 'ki', sound: 'sounds/hiragana/ki.mp3'),
  KanaItem(kana: 'く', romaji: 'ku', sound: 'sounds/hiragana/ku.mp3'),
  KanaItem(kana: 'け', romaji: 'ke', sound: 'sounds/hiragana/ke.mp3'),
  KanaItem(kana: 'こ', romaji: 'ko', sound: 'sounds/hiragana/ko.mp3'),
  // さ行
  KanaItem(kana: 'さ', romaji: 'sa', sound: 'sounds/hiragana/sa.mp3'),
  KanaItem(kana: 'し', romaji: 'shi', sound: 'sounds/hiragana/shi.mp3'),
  KanaItem(kana: 'す', romaji: 'su', sound: 'sounds/hiragana/su.mp3'),
  KanaItem(kana: 'せ', romaji: 'se', sound: 'sounds/hiragana/se.mp3'),
  KanaItem(kana: 'そ', romaji: 'so', sound: 'sounds/hiragana/so.mp3'),
  // た行
  KanaItem(kana: 'た', romaji: 'ta', sound: 'sounds/hiragana/ta.mp3'),
  KanaItem(kana: 'ち', romaji: 'chi', sound: 'sounds/hiragana/chi.mp3'),
  KanaItem(kana: 'つ', romaji: 'tsu', sound: 'sounds/hiragana/tsu.mp3'),
  KanaItem(kana: 'て', romaji: 'te', sound: 'sounds/hiragana/te.mp3'),
  KanaItem(kana: 'と', romaji: 'to', sound: 'sounds/hiragana/to.mp3'),
  // な行
  KanaItem(kana: 'な', romaji: 'na', sound: 'sounds/hiragana/na.mp3'),
  KanaItem(kana: 'に', romaji: 'ni', sound: 'sounds/hiragana/ni.mp3'),
  KanaItem(kana: 'ぬ', romaji: 'nu', sound: 'sounds/hiragana/nu.mp3'),
  KanaItem(kana: 'ね', romaji: 'ne', sound: 'sounds/hiragana/ne.mp3'),
  KanaItem(kana: 'の', romaji: 'no', sound: 'sounds/hiragana/no.mp3'),
  // は行
  KanaItem(kana: 'は', romaji: 'ha', sound: 'sounds/hiragana/ha.mp3'),
  KanaItem(kana: 'ひ', romaji: 'hi', sound: 'sounds/hiragana/hi.mp3'),
  KanaItem(kana: 'ふ', romaji: 'fu', sound: 'sounds/hiragana/fu.mp3'),
  KanaItem(kana: 'へ', romaji: 'he', sound: 'sounds/hiragana/he.mp3'),
  KanaItem(kana: 'ほ', romaji: 'ho', sound: 'sounds/hiragana/ho.mp3'),
  // ま行
  KanaItem(kana: 'ま', romaji: 'ma', sound: 'sounds/hiragana/ma.mp3'),
  KanaItem(kana: 'み', romaji: 'mi', sound: 'sounds/hiragana/mi.mp3'),
  KanaItem(kana: 'む', romaji: 'mu', sound: 'sounds/hiragana/mu.mp3'),
  KanaItem(kana: 'め', romaji: 'me', sound: 'sounds/hiragana/me.mp3'),
  KanaItem(kana: 'も', romaji: 'mo', sound: 'sounds/hiragana/mo.mp3'),
  // や行
  KanaItem(kana: 'や', romaji: 'ya', sound: 'sounds/hiragana/ya.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'ゆ', romaji: 'yu', sound: 'sounds/hiragana/yu.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'よ', romaji: 'yo', sound: 'sounds/hiragana/yo.mp3'),
  // ら行
  KanaItem(kana: 'ら', romaji: 'ra', sound: 'sounds/hiragana/ra.mp3'),
  KanaItem(kana: 'り', romaji: 'ri', sound: 'sounds/hiragana/ri.mp3'),
  KanaItem(kana: 'る', romaji: 'ru', sound: 'sounds/hiragana/ru.mp3'),
  KanaItem(kana: 'れ', romaji: 're', sound: 'sounds/hiragana/re.mp3'),
  KanaItem(kana: 'ろ', romaji: 'ro', sound: 'sounds/hiragana/ro.mp3'),
  // わ行
  KanaItem(kana: 'わ', romaji: 'wa', sound: 'sounds/hiragana/wa.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'を', romaji: 'wo', sound: 'sounds/hiragana/wo.mp3'),
  KanaItem(kana: 'ん', romaji: 'n', sound: 'sounds/hiragana/n.mp3'),
];

// 片假名列表
const List<KanaItem> katakanaList = [
  // ア行
  KanaItem(kana: 'ア', romaji: 'a', sound: 'sounds/hiragana/a.mp3'),
  KanaItem(kana: 'イ', romaji: 'i', sound: 'sounds/hiragana/i.mp3'),
  KanaItem(kana: 'ウ', romaji: 'u', sound: 'sounds/hiragana/u.mp3'),
  KanaItem(kana: 'エ', romaji: 'e', sound: 'sounds/hiragana/e.mp3'),
  KanaItem(kana: 'オ', romaji: 'o', sound: 'sounds/hiragana/o.mp3'),
  // カ行
  KanaItem(kana: 'カ', romaji: 'ka', sound: 'sounds/hiragana/ka.mp3'),
  KanaItem(kana: 'キ', romaji: 'ki', sound: 'sounds/hiragana/ki.mp3'),
  KanaItem(kana: 'ク', romaji: 'ku', sound: 'sounds/hiragana/ku.mp3'),
  KanaItem(kana: 'ケ', romaji: 'ke', sound: 'sounds/hiragana/ke.mp3'),
  KanaItem(kana: 'コ', romaji: 'ko', sound: 'sounds/hiragana/ko.mp3'),
  // サ行
  KanaItem(kana: 'サ', romaji: 'sa', sound: 'sounds/hiragana/sa.mp3'),
  KanaItem(kana: 'シ', romaji: 'shi', sound: 'sounds/hiragana/shi.mp3'),
  KanaItem(kana: 'ス', romaji: 'su', sound: 'sounds/hiragana/su.mp3'),
  KanaItem(kana: 'セ', romaji: 'se', sound: 'sounds/hiragana/se.mp3'),
  KanaItem(kana: 'ソ', romaji: 'so', sound: 'sounds/hiragana/so.mp3'),
  // タ行
  KanaItem(kana: 'タ', romaji: 'ta', sound: 'sounds/hiragana/ta.mp3'),
  KanaItem(kana: 'チ', romaji: 'chi', sound: 'sounds/hiragana/chi.mp3'),
  KanaItem(kana: 'ツ', romaji: 'tsu', sound: 'sounds/hiragana/tsu.mp3'),
  KanaItem(kana: 'テ', romaji: 'te', sound: 'sounds/hiragana/te.mp3'),
  KanaItem(kana: 'ト', romaji: 'to', sound: 'sounds/hiragana/to.mp3'),
  // ナ行
  KanaItem(kana: 'ナ', romaji: 'na', sound: 'sounds/hiragana/na.mp3'),
  KanaItem(kana: 'ニ', romaji: 'ni', sound: 'sounds/hiragana/ni.mp3'),
  KanaItem(kana: 'ヌ', romaji: 'nu', sound: 'sounds/hiragana/nu.mp3'),
  KanaItem(kana: 'ネ', romaji: 'ne', sound: 'sounds/hiragana/ne.mp3'),
  KanaItem(kana: 'ノ', romaji: 'no', sound: 'sounds/hiragana/no.mp3'),
  // ハ行
  KanaItem(kana: 'ハ', romaji: 'ha', sound: 'sounds/hiragana/ha.mp3'),
  KanaItem(kana: 'ヒ', romaji: 'hi', sound: 'sounds/hiragana/hi.mp3'),
  KanaItem(kana: 'フ', romaji: 'fu', sound: 'sounds/hiragana/fu.mp3'),
  KanaItem(kana: 'ヘ', romaji: 'he', sound: 'sounds/hiragana/he.mp3'),
  KanaItem(kana: 'ホ', romaji: 'ho', sound: 'sounds/hiragana/ho.mp3'),
  // マ行
  KanaItem(kana: 'マ', romaji: 'ma', sound: 'sounds/hiragana/ma.mp3'),
  KanaItem(kana: 'ミ', romaji: 'mi', sound: 'sounds/hiragana/mi.mp3'),
  KanaItem(kana: 'ム', romaji: 'mu', sound: 'sounds/hiragana/mu.mp3'),
  KanaItem(kana: 'メ', romaji: 'me', sound: 'sounds/hiragana/me.mp3'),
  KanaItem(kana: 'モ', romaji: 'mo', sound: 'sounds/hiragana/mo.mp3'),
  // ヤ行
  KanaItem(kana: 'ヤ', romaji: 'ya', sound: 'sounds/hiragana/ya.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'ユ', romaji: 'yu', sound: 'sounds/hiragana/yu.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'ヨ', romaji: 'yo', sound: 'sounds/hiragana/yo.mp3'),
  // ラ行
  KanaItem(kana: 'ラ', romaji: 'ra', sound: 'sounds/hiragana/ra.mp3'),
  KanaItem(kana: 'リ', romaji: 'ri', sound: 'sounds/hiragana/ri.mp3'),
  KanaItem(kana: 'ル', romaji: 'ru', sound: 'sounds/hiragana/ru.mp3'),
  KanaItem(kana: 'レ', romaji: 're', sound: 'sounds/hiragana/re.mp3'),
  KanaItem(kana: 'ロ', romaji: 'ro', sound: 'sounds/hiragana/ro.mp3'),
  // ワ行·
  KanaItem(kana: 'ワ', romaji: 'wa', sound: 'sounds/hiragana/wa.mp3'),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: ' ', romaji: ' ', sound: ''),
  KanaItem(kana: 'ヲ', romaji: 'wo', sound: 'sounds/hiragana/wo.mp3'),
  KanaItem(kana: 'ン', romaji: 'n', sound: 'sounds/hiragana/n.mp3'),
];

// 浊音列表
const List<KanaItem> dakuonList = [
  // が行
  KanaItem(kana: 'が', romaji: 'ga', sound: 'sounds/hiragana/ga.mp3'),
  KanaItem(kana: 'ぎ', romaji: 'gi', sound: 'sounds/hiragana/gi.mp3'),
  KanaItem(kana: 'ぐ', romaji: 'gu', sound: 'sounds/hiragana/gu.mp3'),
  KanaItem(kana: 'げ', romaji: 'ge', sound: 'sounds/hiragana/ge.mp3'),
  KanaItem(kana: 'ご', romaji: 'go', sound: 'sounds/hiragana/go.mp3'),
  // ざ行
  KanaItem(kana: 'ざ', romaji: 'za', sound: 'sounds/hiragana/za.mp3'),
  KanaItem(kana: 'じ', romaji: 'ji', sound: 'sounds/hiragana/zi.mp3'),
  KanaItem(kana: 'ず', romaji: 'zu', sound: 'sounds/hiragana/zu.mp3'),
  KanaItem(kana: 'ぜ', romaji: 'ze', sound: 'sounds/hiragana/ze.mp3'),
  KanaItem(kana: 'ぞ', romaji: 'zo', sound: 'sounds/hiragana/zo.mp3'),
  // だ行
  KanaItem(kana: 'だ', romaji: 'da', sound: 'sounds/hiragana/da.mp3'),
  KanaItem(kana: 'ぢ', romaji: 'ji', sound: 'sounds/hiragana/zi.mp3'),
  KanaItem(kana: 'づ', romaji: 'zu', sound: 'sounds/hiragana/zu.mp3'),
  KanaItem(kana: 'で', romaji: 'de', sound: 'sounds/hiragana/de.mp3'),
  KanaItem(kana: 'ど', romaji: 'do', sound: 'sounds/hiragana/do.mp3'),
  // ば行
  KanaItem(kana: 'ば', romaji: 'ba', sound: 'sounds/hiragana/ba.mp3'),
  KanaItem(kana: 'び', romaji: 'bi', sound: 'sounds/hiragana/bi.mp3'),
  KanaItem(kana: 'ぶ', romaji: 'bu', sound: 'sounds/hiragana/bu.mp3'),
  KanaItem(kana: 'べ', romaji: 'be', sound: 'sounds/hiragana/be.mp3'),
  KanaItem(kana: 'ぼ', romaji: 'bo', sound: 'sounds/hiragana/bo.mp3'),
  // ぱ行
  KanaItem(kana: 'ぱ', romaji: 'pa', sound: 'sounds/hiragana/pa.mp3'),
  KanaItem(kana: 'ぴ', romaji: 'pi', sound: 'sounds/hiragana/pi.mp3'),
  KanaItem(kana: 'ぷ', romaji: 'pu', sound: 'sounds/hiragana/pu.mp3'),
  KanaItem(kana: 'ぺ', romaji: 'pe', sound: 'sounds/hiragana/pe.mp3'),
  KanaItem(kana: 'ぽ', romaji: 'po', sound: 'sounds/hiragana/po.mp3'),
];

// 拗音列表
const List<KanaItem> youonList = [
  // きゃ行
  KanaItem(kana: 'きゃ', romaji: 'kya', sound: 'sounds/hiragana/kya.mp3'),
  KanaItem(kana: 'きゅ', romaji: 'kyu', sound: 'sounds/hiragana/kyu.mp3'),
  KanaItem(kana: 'きょ', romaji: 'kyo', sound: 'sounds/hiragana/kyo.mp3'),
  // ぎゃ行
  KanaItem(kana: 'ぎゃ', romaji: 'gya', sound: 'sounds/hiragana/gya.mp3'),
  KanaItem(kana: 'ぎゅ', romaji: 'gyu', sound: 'sounds/hiragana/gyu.mp3'),
  KanaItem(kana: 'ぎょ', romaji: 'gyo', sound: 'sounds/hiragana/gyo.mp3'),
  // しゃ行
  KanaItem(kana: 'しゃ', romaji: 'sha', sound: 'sounds/hiragana/sha.mp3'),
  KanaItem(kana: 'しゅ', romaji: 'shu', sound: 'sounds/hiragana/shu.mp3'),
  KanaItem(kana: 'しょ', romaji: 'sho', sound: 'sounds/hiragana/sho.mp3'),
  // じゃ行
  KanaItem(kana: 'じゃ', romaji: 'ja', sound: 'sounds/hiragana/ja.mp3'),
  KanaItem(kana: 'じゅ', romaji: 'ju', sound: 'sounds/hiragana/ju.mp3'),
  KanaItem(kana: 'じょ', romaji: 'jo', sound: 'sounds/hiragana/jo.mp3'),
  // ちゃ行
  KanaItem(kana: 'ちゃ', romaji: 'cha', sound: 'sounds/hiragana/cha.mp3'),
  KanaItem(kana: 'ちゅ', romaji: 'chu', sound: 'sounds/hiragana/chu.mp3'),
  KanaItem(kana: 'ちょ', romaji: 'cho', sound: 'sounds/hiragana/cho.mp3'),
  // にゃ行
  KanaItem(kana: 'にゃ', romaji: 'nya', sound: 'sounds/hiragana/nya.mp3'),
  KanaItem(kana: 'にゅ', romaji: 'nyu', sound: 'sounds/hiragana/nyu.mp3'),
  KanaItem(kana: 'にょ', romaji: 'nyo', sound: 'sounds/hiragana/nyo.mp3'),
  // ひゃ行
  KanaItem(kana: 'ひゃ', romaji: 'hya', sound: 'sounds/hiragana/hya.mp3'),
  KanaItem(kana: 'ひゅ', romaji: 'hyu', sound: 'sounds/hiragana/hyu.mp3'),
  KanaItem(kana: 'ひょ', romaji: 'hyo', sound: 'sounds/hiragana/hyo.mp3'),
  // びゃ行
  KanaItem(kana: 'びゃ', romaji: 'bya', sound: 'sounds/hiragana/bya.mp3'),
  KanaItem(kana: 'びゅ', romaji: 'byu', sound: 'sounds/hiragana/byu.mp3'),
  KanaItem(kana: 'びょ', romaji: 'byo', sound: 'sounds/hiragana/byo.mp3'),
  // ぴゃ行
  KanaItem(kana: 'ぴゃ', romaji: 'pya', sound: 'sounds/hiragana/pya.mp3'),
  KanaItem(kana: 'ぴゅ', romaji: 'pyu', sound: 'sounds/hiragana/pyu.mp3'),
  KanaItem(kana: 'ぴょ', romaji: 'pyo', sound: 'sounds/hiragana/pyo.mp3'),
  // みゃ行
  KanaItem(kana: 'みゃ', romaji: 'mya', sound: 'sounds/hiragana/mya.mp3'),
  KanaItem(kana: 'みゅ', romaji: 'myu', sound: 'sounds/hiragana/myu.mp3'),
  KanaItem(kana: 'みょ', romaji: 'myo', sound: 'sounds/hiragana/myo.mp3'),
  // りゃ行
  KanaItem(kana: 'りゃ', romaji: 'rya', sound: 'sounds/hiragana/rya.mp3'),
  KanaItem(kana: 'りゅ', romaji: 'ryu', sound: 'sounds/hiragana/ryu.mp3'),
  KanaItem(kana: 'りょ', romaji: 'ryo', sound: 'sounds/hiragana/ryo.mp3'),
];
