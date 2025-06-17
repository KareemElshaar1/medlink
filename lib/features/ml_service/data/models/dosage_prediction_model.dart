import 'package:equatable/equatable.dart';

class DosagePredictionModel extends Equatable {
  final int dosageClass;
  final String dosageLabel;
  final double confidence;
  final String recommendation;
  final String? normalRange;

  const DosagePredictionModel({
    required this.dosageClass,
    required this.dosageLabel,
    required this.confidence,
    required this.recommendation,
    this.normalRange,
  });

  factory DosagePredictionModel.fromJson(Map<String, dynamic> json) {
    return DosagePredictionModel(
      dosageClass: json['dosage_class'] as int,
      dosageLabel: json['dosage_label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      normalRange: json['normal_range'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dosage_class': dosageClass,
      'dosage_label': dosageLabel,
      'confidence': confidence,
      'recommendation': recommendation,
      'normal_range': normalRange,
    };
  }

  @override
  List<Object?> get props =>
      [dosageClass, dosageLabel, confidence, recommendation, normalRange];
}
