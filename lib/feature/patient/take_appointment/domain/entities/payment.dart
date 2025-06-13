class Payment {
  final int appointmentId;
  final String cardNumber;
  final String cardHolderName;
  final String expirationMonth;
  final String expirationYear;
  final String cvv;

  Payment({
    required this.appointmentId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
  });
}
