import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/color_manger.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/font_weight_helper.dart';
import '../../../../core/extensions/padding.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../../data/models/appointment_model.dart';
import '../../domain/use_cases/process_payment_usecase.dart';
import '../../domain/use_cases/get_appointments_usecase.dart';
import '../../domain/use_cases/cancel_appointment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(
        processPaymentUseCase: GetIt.instance<ProcessPaymentUseCase>(),
        getAppointmentsUseCase: GetIt.instance<GetAppointmentsUseCase>(),
        cancelAppointmentUseCase: GetIt.instance<CancelAppointmentUseCase>(),
      ),
      child: const PaymentContent(),
    );
  }
}

class PaymentContent extends StatelessWidget {
  const PaymentContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PaymentCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('My Appointments', style: TextStyles.font18DarkBlueBold)
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
        centerTitle: true,
      ),
      body: _buildBody(context, state, cubit),
    );
  }

  Widget _buildBody(
      BuildContext context, PaymentState state, PaymentCubit cubit) {
    if (state is PaymentLoading) {
      return const _LoadingIndicator();
    }

    if (state is PaymentLoaded) {
      return _buildPaymentSuccess(state, cubit);
    }

    if (state is AppointmentsLoaded) {
      return _buildAppointmentsList(state.appointments, cubit);
    }

    if (state is PaymentError) {
      return _buildErrorState(state.message, cubit);
    }

    return _buildInitialState(cubit);
  }

  Widget _buildPaymentSuccess(PaymentLoaded state, PaymentCubit cubit) {
    return Center(
      child: Container(
        width: 0.9.sw,
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSuccessIcon(),
            SizedBox(height: 24.h),
            _buildSuccessTitle(),
            SizedBox(height: 8.h),
            _buildSuccessMessage(),
            SizedBox(height: 32.h),
            _buildPaymentDetails(state),
            SizedBox(height: 32.h),
            _buildBackButton(cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.success.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle_outline,
        size: 64.w,
        color: ColorsManager.success,
      ),
    ).animate().scale(duration: 600.ms).then().shimmer(
          duration: 1200.ms,
          color: ColorsManager.success,
        );
  }

  Widget _buildSuccessTitle() {
    return Text(
      'Payment Successful!',
      style: TextStyles.font24BlackBold.copyWith(
        color: ColorsManager.success,
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSuccessMessage() {
    return Text(
      'Your appointment has been confirmed',
      style: TextStyles.font14GrayRegular,
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildPaymentDetails(PaymentLoaded state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          if (state.paymentData is Map<String, dynamic>) ...[
            _buildPaymentInfoRow(
              'Payment ID',
              state.paymentData['id']?.toString() ?? 'N/A',
              Icons.receipt_long_outlined,
            ),
            SizedBox(height: 12.h),
            _buildPaymentInfoRow(
              'Status',
              state.paymentData['status']?.toString().toUpperCase() ??
                  'SUCCESS',
              Icons.check_circle_outline,
              valueColor: ColorsManager.success,
            ),
            SizedBox(height: 12.h),
            _buildPaymentInfoRow(
              'Amount',
              '\$${state.paymentData['price']?.toString() ?? '0.00'}',
              Icons.attach_money,
              valueColor: ColorsManager.primary,
            ),
          ] else ...[
            _buildPaymentInfoRow(
              'Status',
              'SUCCESS',
              Icons.check_circle_outline,
              valueColor: ColorsManager.success,
            ),
            SizedBox(height: 12.h),
            _buildPaymentInfoRow(
              'Message',
              state.paymentData.toString(),
              Icons.info_outline,
              valueColor: ColorsManager.primary,
            ),
          ],
        ],
      ),
    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildBackButton(PaymentCubit cubit) {
    return AppTextButton(
      buttonText: 'Back to Appointments',
      onPressed: () => cubit.getAppointments(),
      backgroundColor: ColorsManager.primary,
    ).animate(delay: 800.ms).fadeIn().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }

  Widget _buildAppointmentsList(
      List<AppointmentModel> appointments, PaymentCubit cubit) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64.w, color: ColorsManager.primary)
                .animate()
                .scale(duration: 600.ms),
            SizedBox(height: 24.h),
            Text('No Appointments Found', style: TextStyles.font18DarkBlueBold)
                .animate()
                .fadeIn(delay: 200.ms),
            SizedBox(height: 16.h),
            Text(
              'You don\'t have any appointments yet',
              style: TextStyles.font14GrayRegular,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _AppointmentCard(
          appointment: appointment,
          onPayPressed: () =>
              _showPaymentDialog(context, appointment.id, cubit),
          onCancelPressed: () => _showCancelDialog(context, appointment.id),
        ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildErrorState(String message, PaymentCubit cubit) {
    return Center(
      child: Container(
        width: 0.9.sw,
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: ColorsManager.error)
                .animate()
                .shake(duration: 600.ms)
                .then()
                .fadeIn(),
            SizedBox(height: 16.h),
            Text(
              'Error: $message',
              style: TextStyles.font16WhiteSemiBold.copyWith(
                color: ColorsManager.error,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            SizedBox(height: 24.h),
            AppTextButton(
              buttonText: 'Try Again',
              onPressed: () => cubit.getAppointments(),
            ).animate(delay: 400.ms).fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(PaymentCubit cubit) {
    return Center(
      child: Container(
        width: 0.9.sw,
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month, size: 64.w, color: ColorsManager.primary)
                .animate()
                .scale(duration: 600.ms),
            SizedBox(height: 24.h),
            Text('No Appointments Loaded', style: TextStyles.font18DarkBlueBold)
                .animate()
                .fadeIn(delay: 200.ms),
            SizedBox(height: 16.h),
            AppTextButton(
              buttonText: 'Load Appointments',
              onPressed: () => cubit.getAppointments(),
            ).animate(delay: 400.ms).fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoRow(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: ColorsManager.textLight),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.font14GrayRegular.copyWith(
                  color: ColorsManager.textLight,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyles.font16WhiteSemiBold.copyWith(
                  color: valueColor ?? ColorsManager.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPaymentDialog(
      BuildContext context, int appointmentId, PaymentCubit cubit) {
    final formKey = GlobalKey<FormState>();
    final cardNumberController = TextEditingController();
    final cardHolderNameController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();
    bool isProcessing = false;

    String formatCardNumber(String input) {
      final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
      final buffer = StringBuffer();
      for (int i = 0; i < digitsOnly.length; i++) {
        buffer.write(digitsOnly[i]);
        var nonZeroIndex = i + 1;
        if (nonZeroIndex % 4 == 0 && nonZeroIndex != digitsOnly.length) {
          buffer.write(' ');
        }
      }
      return buffer.toString();
    }

    String formatExpiryDate(String input) {
      final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
      StringBuffer buffer = StringBuffer();
      for (int i = 0; i < digitsOnly.length && i < 4; i++) {
        if (i == 2) buffer.write('/');
        buffer.write(digitsOnly[i]);
      }
      return buffer.toString();
    }

    void onCardNumberChanged() {
      final text = cardNumberController.text;
      final formatted = formatCardNumber(text);
      if (text != formatted) {
        cardNumberController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }

    void onExpiryDateChanged() {
      final text = expiryDateController.text;
      final formatted = formatExpiryDate(text);
      if (text != formatted) {
        expiryDateController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }

    cardNumberController.addListener(onCardNumberChanged);
    expiryDateController.addListener(onExpiryDateChanged);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 0.9.sw,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card,
                              color: ColorsManager.primary, size: 32.w),
                          SizedBox(width: 16.w),
                          Text(
                            'Pay with Visa',
                            style: TextStyles.font24BlackBold.copyWith(
                              color: ColorsManager.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0),
                    SizedBox(height: 24.h),
                    _buildAnimatedFormField(
                      controller: cardHolderNameController,
                      label: 'Cardholder Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the cardholder\'s name';
                        }
                        return null;
                      },
                      delay: 400,
                    ),
                    SizedBox(height: 16.h),
                    _buildAnimatedFormField(
                      controller: cardNumberController,
                      label: 'Card Number',
                      icon: Icons.credit_card_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                      ],
                      validator: (value) {
                        if (value == null) return 'Please enter card number';
                        final digits = value.replaceAll(' ', '');
                        if (digits.length != 16) {
                          return 'Card number must be 16 digits';
                        }
                        if (!digits.startsWith('4')) {
                          return 'Card number must start with 4 (Visa)';
                        }
                        return null;
                      },
                      delay: 600,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildAnimatedFormField(
                            controller: expiryDateController,
                            label: 'Expiry Date',
                            icon: Icons.date_range_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter expiry date';
                              }
                              final parts = value.split('/');
                              if (parts.length != 2) return 'Invalid format';
                              final month = int.tryParse(parts[0]);
                              final year = int.tryParse(parts[1]);
                              if (month == null || year == null)
                                return 'Invalid numbers';
                              if (month < 1 || month > 12)
                                return 'Invalid month';
                              final currentYear = DateTime.now().year % 100;
                              final currentMonth = DateTime.now().month;
                              if (year < currentYear ||
                                  (year == currentYear &&
                                      month < currentMonth)) {
                                return 'Card expired';
                              }
                              return null;
                            },
                            delay: 800,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildAnimatedFormField(
                            controller: cvvController,
                            label: 'CVV',
                            icon: Icons.lock_outline,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (value) {
                              if (value == null || value.length != 3) {
                                return 'Enter valid CVV';
                              }
                              return null;
                            },
                            delay: 1000,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    AppTextButton(
                      buttonText: 'Pay Now',
                      onPressed: isProcessing
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                setState(() => isProcessing = true);
                                await cubit.processPayment(
                                  appointmentId: appointmentId,
                                  cardNumber: cardNumberController.text
                                      .replaceAll(' ', ''),
                                  cardHolderName: cardHolderNameController.text,
                                  expirationMonth:
                                      expiryDateController.text.split('/')[0],
                                  expirationYear:
                                      expiryDateController.text.split('/')[1],
                                  cvv: cvvController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                      isLoading: isProcessing,
                    ).animate(delay: 1200.ms).fadeIn().scale(
                        begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                    if (isProcessing)
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorsManager.primary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int delay = 0,
  }) {
    return AppTextFormField(
      controller: controller,
      labelText: label,
      hintText: hintText ?? label,
      isObscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      prefixIcon: Icon(icon, color: ColorsManager.textLight, size: 24.w),
      backgroundColor: ColorsManager.gray.withOpacity(0.1),
      inputTextStyle: TextStyles.font16WhiteSemiBold.copyWith(
        color: Colors.black,
      ),
      labelStyle: TextStyles.font16WhiteSemiBold.copyWith(
        color: ColorsManager.primary,
      ),
      hintStyle: TextStyles.font16WhiteSemiBold.copyWith(
        color: ColorsManager.textLight,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorsManager.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide:
            BorderSide(color: ColorsManager.gray.withOpacity(0.2), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorsManager.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: 0.2, end: 0);
  }

  void _showCancelDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Cancel Appointment',
          style: TextStyles.font18DarkBlueBold,
        ),
        content: Text(
          'Are you sure you want to cancel this appointment?',
          style: TextStyles.font14GrayRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'No',
              style: TextStyles.font14GrayRegular.copyWith(
                color: ColorsManager.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<PaymentCubit>().cancelAppointment(appointmentId);
            },
            child: Text(
              'Yes, Cancel',
              style: TextStyles.font14GrayRegular.copyWith(
                color: ColorsManager.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.primary),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onPayPressed;
  final VoidCallback onCancelPressed;

  const _AppointmentCard({
    required this.appointment,
    required this.onPayPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = appointment.status.toLowerCase() == 'paid';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(isPaid),
          _buildDetails(isPaid),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isPaid) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.primary.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          Icon(Icons.medical_services_outlined,
              color: ColorsManager.primary, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Dr. ${appointment.doctor}',
              style: TextStyles.font16WhiteSemiBold.copyWith(
                color: ColorsManager.primary,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isPaid ? ColorsManager.success : ColorsManager.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              isPaid ? 'Paid' : 'Unpaid',
              style: TextStyles.font14GrayRegular.copyWith(
                color: Colors.white,
                fontWeight: FontWeightHelper.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(bool isPaid) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.calendar_today, 'Date', appointment.day),
          SizedBox(height: 12.h),
          _buildInfoRow(
            Icons.access_time,
            'Time',
            '${appointment.appointmentStart} - ${appointment.appointmentEnd}',
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            Icons.location_on,
            'Location',
            '${appointment.city}, ${appointment.governorate}',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (!isPaid) ...[
                Expanded(
                  child: AppTextButton(
                    buttonText: 'Pay Now',
                    onPressed: onPayPressed,
                    backgroundColor: ColorsManager.primary,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: AppTextButton(
                  buttonText: 'Cancel',
                  onPressed: onCancelPressed,
                  backgroundColor: ColorsManager.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: ColorsManager.textLight),
        SizedBox(width: 12.w),
        Text('$label: ', style: TextStyles.font14GrayRegular),
        Text(
          value,
          style: TextStyles.font14GrayRegular.copyWith(
            fontWeight: FontWeightHelper.semiBold,
          ),
        ),
      ],
    );
  }
}
