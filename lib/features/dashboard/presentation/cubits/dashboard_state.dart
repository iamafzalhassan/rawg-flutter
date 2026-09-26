part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final bool hasReachedEnd;
  final bool isFiltering;
  final bool isLoading;
  final bool isLoadingMore;

  final int currentPage;

  final String? errorMessage;
  final String? searchQuery;

  final List<Game> games;

  final GameOverview? selectedGame;

  final SortItem? platform;

  const DashboardState({
    this.hasReachedEnd = false,
    this.isFiltering = false,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.errorMessage,
    this.searchQuery,
    this.games = const [],
    this.selectedGame,
    this.platform,
  });

  bool get hasGames => games.isNotEmpty;
  bool get shouldShowError => errorMessage != null && !hasGames;
  bool get shouldShowLoadMore => !isLoadingMore && !hasReachedEnd && hasGames;

  DashboardState copyWith({
    bool clearPlatform = false,
    bool clearSearchQuery = false,
    bool? hasReachedEnd,
    bool? isFiltering,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    String? errorMessage,
    String? searchQuery,
    List<Game>? games,
    GameOverview? selectedGame,
    SortItem? platform,
  }) => DashboardState(
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    isFiltering: isFiltering ?? this.isFiltering,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    currentPage: currentPage ?? this.currentPage,
    errorMessage: errorMessage,
    searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
    games: games ?? this.games,
    selectedGame: selectedGame,
    platform: clearPlatform ? null : platform ?? this.platform,
  );

  @override
  List<Object?> get props => [hasReachedEnd, isFiltering, isLoading, isLoadingMore, currentPage, errorMessage, searchQuery, games, selectedGame, platform];
}
