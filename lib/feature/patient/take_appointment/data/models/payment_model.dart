class PaymentModel {
  final int appointmentId;
  final String cardNumber;
  final String cardHolderName;
  final String expirationMonth;
  final String expirationYear;
  final String cvv;

  PaymentModel({
    required this.appointmentId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'cvv': cvv,
    };
  }
}
