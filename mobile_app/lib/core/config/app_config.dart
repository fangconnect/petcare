import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized application configuration
/// Loads configuration from .env file at app startup
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  /// Initialize the configuration by loading .env file
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  /// API base URL for backend communication (required from .env)
  String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_BASE_URL not configured in .env file');
    }
    return url;
  }

  /// Current environment (dev, test, prod)
  String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';

  /// Whether running in development mode
  bool get isDevelopment => environment == 'dev' || environment == 'development';

  /// Whether running in production mode
  bool get isProduction => environment == 'prod' || environment == 'production';

  /// Whether ads are enabled (for freemium model)
  bool get enableAds => dotenv.env['ENABLE_ADS']?.toLowerCase() == 'true';

  /// Whether analytics are enabled
  bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  /// Free tier pet limit (from .env or default 1)
  int get freeTierPetLimit => int.tryParse(dotenv.env['FREE_TIER_PET_LIMIT'] ?? '') ?? 1;

  /// Free tier history days limit (from .env or default 14)
  int get freeTierHistoryDays => int.tryParse(dotenv.env['FREE_TIER_HISTORY_DAYS'] ?? '') ?? 14;
}
