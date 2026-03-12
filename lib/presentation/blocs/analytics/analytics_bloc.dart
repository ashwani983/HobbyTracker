import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/analytics_service.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {}

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}
class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsResult result;
  const AnalyticsLoaded(this.result);
  @override
  List<Object?> get props => [result];
}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService _service;

  AnalyticsBloc(this._service) : super(AnalyticsInitial()) {
    on<LoadAnalytics>((e, emit) async {
      emit(AnalyticsLoading());
      final result = await _service.compute();
      emit(AnalyticsLoaded(result));
    });
  }
}
