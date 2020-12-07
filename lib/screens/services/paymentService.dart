import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com//v1';
  static String secret = '';

  static init() {
    print('hey');
    StripePayment.setOptions(
      StripeOptions(
          publishableKey:
              "pk_test_51Hogf7HrFbKq9S5d7aGUZUZReFxz1Bg7y3A8tPaOBqfJ9R5f4p49bS9VoPRcchIZWOvhF9LehybleYr7GIWOqTWU009YWlTgXP",
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  static payViaExistingCard({String amount, String currency, card}) {
    return new StripeTransactionResponse(
      message: 'Transaction successful',
      success: true,
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      CardFormPaymentRequest();
      print(paymentMethod);

      return new StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: true,
      );
    }
  }
}
