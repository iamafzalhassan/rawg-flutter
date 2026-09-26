import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/core/network/connection_checker.dart';
import 'package:rawg/features/dashboard/domain/entities/game.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';
import 'package:rawg/features/dashboard/domain/entities/sort_item.dart';
import 'package:rawg/features/dashboard/domain/usecases/get_game_overview_use_case.dart';
import 'package:rawg/features/dashboard/domain/usecases/get_games_use_case.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  static const Duration _debounce = Duration(seconds: 1);

  final ConnectionChecker _connectionChecker;

  final GetGameOverviewUseCase _getGameOverviewUseCase;

  final GetGamesUseCase _getGamesUseCase;

  bool _isOffline = false;

  int _requestId = 0;

  StreamSubscription<bool>? _connection;

  Timer? _timer;

  DashboardCubit(this._connectionChecker, this._getGameOverviewUseCase, this._getGamesUseCase) : super(const DashboardState()) {
    _connection = _connectionChecker.onStatusChange.listen(_onConnectionChanged);
    getGames();
  }

  Future<void> getGames({bool clearSearchQuery = false, bool loadMore = false, String? searchQuery}) async {
    if (loadMore && (state.isLoadingMore || state.hasReachedEnd)) return;
    final id = ++_requestId;
    emit(loadMore ? state.copyWith(isLoadingMore: true) : state.copyWith(clearSearchQuery: clearSearchQuery, hasReachedEnd: false, isFiltering: false, isLoading: true, currentPage: 1, searchQuery: searchQuery));
    final query = state.searchQuery;
    final result = await _getGamesUseCase(page: loadMore ? state.currentPage + 1 : 1, platforms: state.platform?.value, searchQuery: query == null || query.isEmpty ? null : query);
    if (id != _requestId) return;
    switch (result) {
      case ApiSuccess(:final data):
        final games = loadMore ? [...state.games, ...data.games] : data.games;
        emit(state.copyWith(hasReachedEnd: !data.hasMore, isLoading: false, isLoadingMore: false, currentPage: data.page, errorMessage: games.isEmpty ? 'dashboard.noGamesFound'.tr() : null, games: games));
      case ApiFailure(:final message):
        emit(state.copyWith(isLoading: false, isLoadingMore: false, errorMessage: message));
    }
  }

  Future<void> getGameOverview(int id) async {
    switch (await _getGameOverviewUseCase(id)) {
      case ApiSuccess(:final data):
        emit(state.copyWith(selectedGame: data));
      case ApiFailure(:final message):
        emit(state.copyWith(errorMessage: message));
    }
  }

  void onSearchChanged(String query) {
    _timer?.cancel();
    if (query.isEmpty) {
      getGames(clearSearchQuery: true);
    } else {
      _timer = Timer(_debounce, () => getGames(searchQuery: query));
    }
  }

  void selectPlatform(SortItem item) {
    _timer?.cancel();
    emit(state.copyWith(clearPlatform: state.platform?.id == item.id, isFiltering: true, errorMessage: state.errorMessage, selectedGame: state.selectedGame, platform: item));
    _timer = Timer(_debounce, getGames);
  }

  void _onConnectionChanged(bool isConnected) {
    if (isConnected && _isOffline && !state.hasGames) getGames();
    _isOffline = !isConnected;
  }

  @override
  Future<void> close() {
    _connection?.cancel();
    _timer?.cancel();
    return super.close();
  }
}
