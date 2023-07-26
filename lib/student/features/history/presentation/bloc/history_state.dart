import 'package:equatable/equatable.dart';

enum HistoryStatus {
  success,
  failure,
  loading,
}

class HistoryState extends Equatable {
  const HistoryState({
    this.message = '',
    this.status = HistoryStatus.loading,
    this.cit = '',
    this.cot = '',
    this.percentage = '',
  });

  final String message;
  final HistoryStatus status;
  final String cit;
  final String cot;
  final String percentage;

  factory HistoryState.fromJson(Map<String, dynamic> data) => HistoryState(
        cit: data['cit'],
        cot: data['cot'],
        percentage: data['percentage'],
      );

  HistoryState copyWith({
    String? cit,
    String? cot,
    String? percentage,
    HistoryStatus? status,
    String? message,
  }) {
    return HistoryState(
      cit: cit ?? this.cit,
      cot: cot ?? this.cot,
      percentage: percentage ?? this.percentage,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        percentage,
        cit,
        cot,
      ];
}
