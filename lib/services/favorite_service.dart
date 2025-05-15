import '../models/favorite_word.dart';

abstract class FavoriteService {
  Future<List<FavoriteWord>> getFavorites();
  Future<void> addFavorite(FavoriteWord favorite);
  Future<void> removeFavorite(String id);
}

// 后端API实现
class ApiFavoriteService implements FavoriteService {
  final String baseUrl;

  ApiFavoriteService({required this.baseUrl});

  @override
  Future<List<FavoriteWord>> getFavorites() async {
    // TODO: 实现真实的API调用
    // 临时返回模拟数据
    return [
      FavoriteWord(
        id: '1',
        word: '猫',
        reading: 'ねこ',
        meaning: '猫，猫咪',
      ),
      FavoriteWord(
        id: '2',
        word: '犬',
        reading: 'いぬ',
        meaning: '狗，犬',
      ),
    ];
  }

  @override
  Future<void> addFavorite(FavoriteWord favorite) async {
    // TODO: 实现真实的API调用
  }

  @override
  Future<void> removeFavorite(String id) async {
    // TODO: 实现真实的API调用
  }
}
