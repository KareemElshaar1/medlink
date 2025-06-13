import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/color_manger.dart';
import '../../../../../core/utils/font_weight_helper.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../data/models/appointment_model.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  String _generatePaymentId() {
    // Generate a random 8-digit number
    final random = DateTime.now().millisecondsSinceEpoch % 100000000;
    return 'PAY-${random.toString().padLeft(8, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final price = args?['price']?.toString() ?? '0';
    final showSuccess = args?['showSuccess'] ?? false;
    final paymentId = _generatePaymentId();

    return BlocProvider(
      create: (_) => GetIt.instance<PaymentCubit>()..getAppointments(),
      child: PaymentContent(
        price: price,
        paymentId: paymentId,
        showSuccess: showSuccess,
      ),
    );
  }
}

class PaymentContent extends StatelessWidget {
  final String price;
  final String paymentId;
  final bool showSuccess;

  const PaymentContent({
    super.key,
    required this.price,
    required this.paymentId,
    this.showSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PaymentCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Appointments',
          style: TextStyles.font18DarkBlueBold.copyWith(
            color: ColorsManager.textDark,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        centerTitle: true,
      ),
      body: _buildBody(context, state, cubit),
    );
  }

  Widget _buildBody(
      BuildContext context, PaymentState state, PaymentCubit cubit) {
    if (showSuccess) {
      return _PaymentSuccessView(
        state: PaymentLoaded({'status': 'success'}),
        price: price,
        paymentId: paymentId,
        onBackPressed: () => cubit.getAppointments(),
      );
    }

    if (state is PaymentLoaded) {
      return _PaymentSuccessView(
        state: state,
        price: price,
        paymentId: paymentId,
        onBackPressed: () => cubit.getAppointments(),
      );
    }

    if (state is AppointmentsLoaded) {
      return _AppointmentsListView(
        appointments: state.appointments,
        onPayPressed: (appointmentId) =>
            _showPaymentDialog(context, appointmentId, cubit),
        onCancelPressed: (appointmentId) =>
            _showCancelDialog(context, appointmentId),
      );
    }

    if (state is PaymentError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => cubit.getAppointments(),
      );
    }

    return _AppointmentsListView(
      appointments: const [],
      onPayPressed: (_) {},
      onCancelPressed: (_) {},
    );
  }

  void _showPaymentDialog(
      BuildContext context, int appointmentId, PaymentCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: Builder(
          builder: (builderContext) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 0.9.sw,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: ColorsManager.background,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose Payment Method',
                    style: TextStyles.font18DarkBlueBold,
                  ),
                  SizedBox(height: 20.h),
                  _PaymentOptionCard(
                    title: 'Pay with Visa',
                    icon: Icons.credit_card,
                    onTap: () {
                      Navigator.pop(builderContext);
                      _showVisaPaymentDialog(context, appointmentId, cubit);
                    },
                  ),
                  SizedBox(height: 12.h),
                  _PaymentOptionCard(
                    title: 'Pay with Cash',
                    icon: Icons.money,
                    onTap: () {
                      Navigator.pop(builderContext);
                      _showCashPaymentDialog(context, appointmentId, cubit);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showVisaPaymentDialog(
      BuildContext context, int appointmentId, PaymentCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: Builder(
          builder: (builderContext) => _PaymentDialog(
            appointmentId: appointmentId,
            onPaymentProcessed: () {
              Navigator.pop(builderContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                  settings: RouteSettings(
                    arguments: {'price': price, 'showSuccess': true},
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 3), () {
                cubit.getAppointments();
              });
            },
          ),
        ),
      ),
    );
  }

  void _showCashPaymentDialog(
      BuildContext context, int appointmentId, PaymentCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: Builder(
          builder: (builderContext) => AlertDialog(
            title: Text(
              'Cash Payment',
              style: TextStyles.font18DarkBlueBold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.money,
                  size: 64.w,
                  color: ColorsManager.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Please pay the amount in cash at the clinic during your appointment.',
                  style: TextStyles.font14GrayRegular,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(builderContext),
                child: Text(
                  'Cancel',
                  style: TextStyles.font14GrayRegular.copyWith(
                    color: ColorsManager.error,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primary,
                  foregroundColor: ColorsManager.background,
                ),
                onPressed: () {
                  Navigator.pop(builderContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentPage(),
                      settings: RouteSettings(
                        arguments: {'price': price, 'showSuccess': true},
                      ),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    cubit.getAppointments();
                  });
                },
                child: Text(
                  'Confirm',
                  style: TextStyles.font14GrayRegular.copyWith(
                    color: ColorsManager.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PaymentCubit>(),
        child: Builder(
          builder: (builderContext) => _CancelDialog(
            onConfirm: () {
              Navigator.pop(builderContext);
              context.read<PaymentCubit>().cancelAppointment(appointmentId);
            },
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessView extends StatelessWidget {
  final PaymentLoaded state;
  final String price;
  final String paymentId;
  final VoidCallback onBackPressed;

  const _PaymentSuccessView({
    required this.state,
    required this.price,
    required this.paymentId,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 0.9.sw,
          margin: EdgeInsets.symmetric(vertical: 16.h),
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
              _SuccessIcon(),
              SizedBox(height: 16.h),
              _SuccessTitle(),
              SizedBox(height: 8.h),
              _SuccessMessage(),
              SizedBox(height: 24.h),
              _PaymentDetails(
                state: state,
                price: price,
                paymentId: paymentId,
              ),
              SizedBox(height: 24.h),
              _BackButton(onPressed: onBackPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _SuccessTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Payment Successful!',
      style: TextStyles.font24BlackBold.copyWith(
        color: ColorsManager.success,
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }
}

class _SuccessMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Your appointment has been confirmed',
      style: TextStyles.font14GrayRegular,
      textAlign: TextAlign.center,
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

class _PaymentDetails extends StatelessWidget {
  final PaymentLoaded state;
  final String price;
  final String paymentId;

  const _PaymentDetails({
    required this.state,
    required this.price,
    required this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.paymentData is Map<String, dynamic>) ...[
            _PaymentInfoRow(
              label: 'Payment ID',
              value: paymentId,
              icon: Icons.receipt_long_outlined,
            ),
            SizedBox(height: 8.h),
            _PaymentInfoRow(
              label: 'Status',
              value: state.paymentData['status']?.toString().toUpperCase() ??
                  'SUCCESS',
              icon: Icons.check_circle_outline,
              valueColor: ColorsManager.success,
            ),
            SizedBox(height: 8.h),
            _PaymentInfoRow(
              label: 'Amount',
              value: 'ج $price',
              icon: Icons.attach_money,
              valueColor: ColorsManager.primary,
            ),
          ] else ...[
            _PaymentInfoRow(
              label: 'Payment ID',
              value: paymentId,
              icon: Icons.receipt_long_outlined,
            ),
            SizedBox(height: 8.h),
            _PaymentInfoRow(
              label: 'Status',
              value: 'SUCCESS',
              icon: Icons.check_circle_outline,
              valueColor: ColorsManager.success,
            ),
            SizedBox(height: 8.h),
            _PaymentInfoRow(
              label: 'Amount',
              value: 'ج $price',
              icon: Icons.attach_money,
              valueColor: ColorsManager.primary,
            ),
            SizedBox(height: 8.h),
            _PaymentInfoRow(
              label: 'Message',
              value: state.paymentData.toString(),
              icon: Icons.info_outline,
              valueColor: ColorsManager.primary,
            ),
          ],
        ],
      ),
    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _PaymentInfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyles.font16WhiteSemiBold.copyWith(
                  color: valueColor ?? ColorsManager.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primary,
        foregroundColor: ColorsManager.background,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Back to Appointments',
        style: TextStyles.font16WhiteSemiBold.copyWith(
          color: ColorsManager.background,
          fontWeight: FontWeightHelper.semiBold,
        ),
      ),
    ).animate(delay: 800.ms).fadeIn().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}

class _AppointmentsListView extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final Function(int) onPayPressed;
  final Function(int) onCancelPressed;

  const _AppointmentsListView({
    required this.appointments,
    required this.onPayPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const _EmptyAppointmentsView();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _AppointmentCard(
          appointment: appointment,
          onPayPressed: () => onPayPressed(appointment.id),
          onCancelPressed: () => onCancelPressed(appointment.id),
        ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.2, end: 0);
      },
    );
  }
}

class _EmptyAppointmentsView extends StatelessWidget {
  const _EmptyAppointmentsView();

  @override
  Widget build(BuildContext context) {
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
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onRetry,
            ).animate(delay: 400.ms).fadeIn().scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                ),
          ],
        ),
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

class _PaymentDialogHeader extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;

  const _PaymentDialogHeader({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            ColorsManager.primary,
            ColorsManager.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "VISA",
            style: TextStyle(
              color: ColorsManager.background,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cardNumber.isEmpty ? "**** **** **** ****" : cardNumber,
            style: TextStyle(
              color: ColorsManager.background,
              fontSize: 20.sp,
              letterSpacing: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Card Holder",
                style: TextStyle(
                  color: ColorsManager.background.withOpacity(0.8),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "Exp Date",
                style: TextStyle(
                  color: ColorsManager.background.withOpacity(0.8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardHolderName.isEmpty ? "YOUR NAME" : cardHolderName,
                style: TextStyle(
                  color: ColorsManager.background,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                expiryDate.isEmpty ? "MM/YY" : expiryDate,
                style: TextStyle(
                  color: ColorsManager.background,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _PaymentFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const _PaymentFormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: ColorsManager.textHint),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorsManager.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorsManager.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorsManager.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorsManager.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorsManager.error, width: 2),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            errorStyle: TextStyle(
              color: ColorsManager.error,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  final int appointmentId;
  final VoidCallback onPaymentProcessed;

  const _PaymentDialog({
    required this.appointmentId,
    required this.onPaymentProcessed,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  bool isProcessing = false;

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    final digits = value.replaceAll(' ', '');
    if (digits.length != 16) {
      return 'Card number must be 16 digits';
    }
    if (!digits.startsWith('4')) {
      return 'Card number must start with 4 (Visa)';
    }
    // Luhn algorithm for card number validation
    int sum = 0;
    bool alternate = false;
    for (int i = digits.length - 1; i >= 0; i--) {
      int n = int.parse(digits[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    if (sum % 10 != 0) {
      return 'Invalid card number';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter cardholder name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date';
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Invalid format (MM/YY)';
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) {
      return 'Invalid numbers';
    }
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card expired';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    }
    if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'CVV must contain only numbers';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(_onCardNumberChanged);
    expiryDateController.addListener(_onExpiryDateChanged);
  }

  @override
  void dispose() {
    cardNumberController.removeListener(_onCardNumberChanged);
    expiryDateController.removeListener(_onExpiryDateChanged);
    cardNumberController.dispose();
    cardHolderNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final text = cardNumberController.text;
    final formatted = _formatCardNumber(text);
    if (text != formatted) {
      cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onExpiryDateChanged() {
    final text = expiryDateController.text;
    final formatted = _formatExpiryDate(text);
    if (text != formatted) {
      expiryDateController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _formatCardNumber(String input) {
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

  String _formatExpiryDate(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digitsOnly[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 0.9.sw,
        constraints: BoxConstraints(
          maxHeight: 0.9.sh,
        ),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: ColorsManager.background,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.shadow,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PaymentDialogHeader(
                  cardNumber: cardNumberController.text,
                  cardHolderName: cardHolderNameController.text,
                  expiryDate: expiryDateController.text,
                ),
                SizedBox(height: 30.h),
                _PaymentFormField(
                  controller: cardNumberController,
                  label: "Card Number",
                  hint: "1234 5678 9012 3456",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                  ],
                  validator: _validateCardNumber,
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 20.h),
                _PaymentFormField(
                  controller: cardHolderNameController,
                  label: "Card Holder Name",
                  hint: "John Doe",
                  validator: _validateCardHolderName,
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: _PaymentFormField(
                        controller: expiryDateController,
                        label: "Expiry Date",
                        hint: "MM/YY",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        validator: _validateExpiryDate,
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: _PaymentFormField(
                        controller: cvvController,
                        label: "CVV",
                        hint: "123",
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: _validateCVV,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isProcessing
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() ?? false) {
                              setState(() => isProcessing = true);
                              await context.read<PaymentCubit>().processPayment(
                                    appointmentId: widget.appointmentId,
                                    cardNumber: cardNumberController.text
                                        .replaceAll(' ', ''),
                                    cardHolderName:
                                        cardHolderNameController.text,
                                    expirationMonth:
                                        expiryDateController.text.split('/')[0],
                                    expirationYear:
                                        expiryDateController.text.split('/')[1],
                                    cvv: cvvController.text,
                                  );
                              widget.onPaymentProcessed();
                            }
                          },
                    child: isProcessing
                        ? CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorsManager.background),
                          )
                        : Text(
                            "Pay Now",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: ColorsManager.background,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _CancelDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          onPressed: () => Navigator.pop(context),
          child: Text(
            'No',
            style: TextStyles.font14GrayRegular.copyWith(
              color: ColorsManager.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'Yes, Cancel',
            style: TextStyles.font14GrayRegular.copyWith(
              color: ColorsManager.error,
            ),
          ),
        ),
      ],
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
        color: ColorsManager.primaryWithOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsManager.primary,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImage(
                imageUrl: appointment.doctorImage ??
                    'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorsManager.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: ColorsManager.primary,
                  size: 24.w,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Dr. ${appointment.doctor}',
              style: TextStyles.font16WhiteSemiBold.copyWith(
                color: ColorsManager.textDark,
                fontWeight: FontWeightHelper.bold,
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
                color: ColorsManager.background,
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primary,
                      foregroundColor: ColorsManager.background,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: onPayPressed,
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeightHelper.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.error,
                    foregroundColor: ColorsManager.background,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: onCancelPressed,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.semiBold,
                    ),
                  ),
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
            color: ColorsManager.textDark,
          ),
        ),
      ],
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorsManager.primary, size: 24.w),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyles.font16WhiteSemiBold.copyWith(
                color: ColorsManager.textDark,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorsManager.textLight,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
