import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/search_repository.dart';
import '../../data/models/doctor_model.dart';

// States
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<DoctorModel> doctors;

  SearchSuccess(this.doctors);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

// Cubit
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;

  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  Future<void> searchDoctors(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final doctors = await searchRepository.searchDoctors(query);
      emit(SearchSuccess(doctors));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
