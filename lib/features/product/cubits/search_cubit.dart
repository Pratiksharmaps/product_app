import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/api_client.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<String> results;
  final String? error;

  const SearchState({required this.status, this.results = const [], this.error});

  @override
  List<Object?> get props => [status, results, error];
}

class SearchCubit extends Cubit<SearchState> {
  final ApiClient _apiClient;

  SearchCubit(this._apiClient) : super(const SearchState(status: SearchStatus.initial));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(const SearchState(status: SearchStatus.initial));
      return;
    }

    emit(const SearchState(status: SearchStatus.loading));
    try {
      final response = await _apiClient.get('/search', queryParameters: {'q': query});
      final results = List<String>.from(response.data['results']);
      emit(SearchState(status: SearchStatus.success, results: results));
    } catch (e) {
      emit(SearchState(status: SearchStatus.error, error: e.toString()));
    }
  }
}

