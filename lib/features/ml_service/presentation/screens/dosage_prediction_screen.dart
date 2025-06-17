import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/color_manger.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/ml_service_cubit.dart';
import '../cubit/ml_service_state.dart';
import '../../data/models/patient_data_model.dart';
import '../../data/datasources/ml_service_remote_data_source.dart';
import '../../data/repositories/ml_service_repository_impl.dart';
import 'dosage_prediction_result_screen.dart';

class DosagePredictionScreen extends StatefulWidget {
  const DosagePredictionScreen({Key? key}) : super(key: key);

  @override
  State<DosagePredictionScreen> createState() => _DosagePredictionScreenState();
}

class _DosagePredictionScreenState extends State<DosagePredictionScreen>
    with TickerProviderStateMixin {
  late final MLServiceCubit _cubit;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedDrug = '';
  String _selectedRoute = 'Oral';
  String _selectedGender = 'M';
  String _selectedAdmissionType = 'EMERGENCY';
  final _diagnosisController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize dependencies
    final dio = Dio();
    final dataSource = MLServiceRemoteDataSourceImpl(
      dio: dio,
      baseUrl: 'http://192.168.251.133:8000',
    );
    final repository = MLServiceRepositoryImpl(
      remoteDataSource: dataSource,
    );
    _cubit = MLServiceCubit(
      repository: repository,
    );
    _cubit.getAvailableDrugs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _diagnosisController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final patientData = PatientDataModel(
        age: double.parse(_ageController.text),
        weight: _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : null,
        drug: _selectedDrug,
        route: _selectedRoute,
        gender: _selectedGender,
        admissionType: _selectedAdmissionType,
        diagnosis: _diagnosisController.text.isNotEmpty
            ? _diagnosisController.text
            : null,
      );

      _cubit.predictDosage(patientData);
    }
  }

  void _resetForm() {
    setState(() {
      _ageController.clear();
      _weightController.clear();
      _diagnosisController.clear();
      _selectedDrug = '';
      _selectedRoute = 'Oral';
      _selectedGender = 'M';
      _selectedAdmissionType = 'EMERGENCY';
    });
  }

  Widget _buildConfidenceChart(double confidence) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.w),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2.w,
          centerSpaceRadius: 60.w,
          sections: [
            PieChartSectionData(
              color: _getConfidenceColor(confidence),
              value: confidence * 100,
              title: '${(confidence * 100).toStringAsFixed(1)}%',
              radius: 40.w,
              titleStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.background,
              ),
            ),
            PieChartSectionData(
              color: ColorsManager.lightGray,
              value: (1 - confidence) * 100,
              title: '',
              radius: 40.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsChart(MLServiceLoaded state) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.all(16.w),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: ColorsManager.lightGray,
                strokeWidth: 1.w,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Confidence',
                          style: TextStyle(fontSize: 12.sp));
                    case 1:
                      return Text('Safety', style: TextStyle(fontSize: 12.sp));
                    case 2:
                      return Text('Efficacy',
                          style: TextStyle(fontSize: 12.sp));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%',
                      style: TextStyle(fontSize: 12.sp));
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: state.prediction.confidence * 100,
                  color: _getConfidenceColor(state.prediction.confidence),
                  width: 30.w,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(4.r)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: _calculateSafetyScore(state.prediction.confidence),
                  color: ColorsManager.success,
                  width: 30.w,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(4.r)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: _calculateEfficacyScore(state.prediction.confidence),
                  color: ColorsManager.info,
                  width: 30.w,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(4.r)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  double _calculateSafetyScore(double confidence) {
    return (confidence * 0.9 + 0.1) * 100; // Mock safety calculation
  }

  double _calculateEfficacyScore(double confidence) {
    return (confidence * 0.85 + 0.15) * 100; // Mock efficacy calculation
  }

  Widget _buildInputCard({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: ColorsManager.primary),
                  SizedBox(width: 8.w),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.textDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(MLServiceLoaded state) {
    _animationController.forward();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getConfidenceColor(state.prediction.confidence)
                        .withOpacity(0.9),
                    _getConfidenceColor(state.prediction.confidence),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.background.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 40.w,
                      color: ColorsManager.background,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Dosage Prediction Result',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.background,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'AI-Powered Analysis',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.background.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildResultSection(
                              'Dosage Information',
                              [
                                _buildResultItem(
                                  'Dosage Class',
                                  state.prediction.dosageClass.toString(),
                                  Icons.category,
                                ),
                                SizedBox(height: 16.h),
                                _buildResultItem(
                                  'Dosage Label',
                                  state.prediction.dosageLabel,
                                  Icons.label,
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            _buildResultSection(
                              'Clinical Details',
                              [
                                _buildResultItem(
                                  'Recommendation',
                                  state.prediction.recommendation,
                                  Icons.recommend,
                                ),
                                if (state.prediction.normalRange != null) ...[
                                  SizedBox(height: 16.h),
                                  _buildResultItem(
                                    'Normal Range',
                                    state.prediction.normalRange!,
                                    Icons.timeline,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: ColorsManager.background,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.shadow.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Confidence Score',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.textDark,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _buildConfidenceChart(
                                  state.prediction.confidence),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.background,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.shadow.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prediction Metrics',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textDark,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildMetricsChart(state),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextButton(
                          buttonText: 'New Prediction',
                          leadingIcon: const Icon(Icons.refresh,
                              color: ColorsManager.background),
                          onPressed: _resetForm,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: AppTextButton(
                          buttonText: 'Save Result',
                          leadingIcon: const Icon(Icons.save,
                              color: ColorsManager.background),
                          onPressed: () {
                            // Export or save functionality
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: ColorsManager.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.w, color: ColorsManager.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: ColorsManager.background,
        appBar: AppBar(
          title: Text(
            'AI Dosage Prediction',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.background,
            ),
          ),
          elevation: 0,
          backgroundColor: ColorsManager.primary,
          centerTitle: true,
        ),
        body: BlocBuilder<MLServiceCubit, MLServiceState>(
          builder: (context, state) {
            if (state is MLServiceLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: ColorsManager.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Processing prediction...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorsManager.textDark,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is MLServiceError) {
              return Center(
                child: Card(
                  margin: EdgeInsets.all(16.w),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: ColorsManager.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textDark,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsManager.textMedium,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AppTextButton(
                          buttonText: 'Retry',
                          onPressed: () => _cubit.getAvailableDrugs(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is MLServiceLoaded) {
              // Navigate to result screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DosagePredictionResultScreen(
                      prediction: state.prediction,
                    ),
                  ),
                );
              });
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputCard(
                      title: 'Patient Information',
                      icon: Icons.person,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppTextFormField(
                                  controller: _ageController,
                                  hintText: 'Age',
                                  labelText: 'Age',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: const Icon(Icons.cake,
                                      color: ColorsManager.primary),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter age';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: AppTextFormField(
                                  controller: _weightController,
                                  hintText: 'Weight (kg)',
                                  labelText: 'Weight (kg)',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: const Icon(Icons.monitor_weight,
                                      color: ColorsManager.primary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon: const Icon(Icons.wc,
                                  color: ColorsManager.primary),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'M', child: Text('Male')),
                              DropdownMenuItem(
                                  value: 'F', child: Text('Female')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildInputCard(
                      title: 'Medication Details',
                      icon: Icons.medication,
                      child: Column(
                        children: [
                          if (state is DrugsLoaded)
                            DropdownButtonFormField<String>(
                              value:
                                  _selectedDrug.isEmpty ? null : _selectedDrug,
                              decoration: InputDecoration(
                                labelText: 'Drug',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                prefixIcon: const Icon(Icons.medical_services,
                                    color: ColorsManager.primary),
                              ),
                              items: state.drugs.map((drug) {
                                return DropdownMenuItem(
                                  value: drug,
                                  child: Text(drug),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDrug = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a drug';
                                }
                                return null;
                              },
                            ),
                          SizedBox(height: 16.h),
                          DropdownButtonFormField<String>(
                            value: _selectedRoute,
                            decoration: InputDecoration(
                              labelText: 'Administration Route',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon: const Icon(Icons.route,
                                  color: ColorsManager.primary),
                            ),
                            items: ['Oral', 'IV', 'IM', 'SC'].map((route) {
                              return DropdownMenuItem(
                                value: route,
                                child: Text(route),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRoute = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildInputCard(
                      title: 'Clinical Information',
                      icon: Icons.local_hospital,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedAdmissionType,
                            decoration: InputDecoration(
                              labelText: 'Admission Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon: const Icon(Icons.emergency,
                                  color: ColorsManager.primary),
                            ),
                            items:
                                ['EMERGENCY', 'ELECTIVE', 'URGENT'].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedAdmissionType = value!;
                              });
                            },
                          ),
                          SizedBox(height: 16.h),
                          AppTextFormField(
                            controller: _diagnosisController,
                            hintText: 'Diagnosis (Optional)',
                            labelText: 'Diagnosis (Optional)',
                            prefixIcon: const Icon(Icons.assignment,
                                color: ColorsManager.primary),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AppTextButton(
                      buttonText: 'Generate Prediction',
                      leadingIcon: const Icon(Icons.analytics,
                          color: ColorsManager.background),
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
