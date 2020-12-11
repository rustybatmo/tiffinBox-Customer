import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String secret =
      'sk_test_51Hogf7HrFbKq9S5dwsoOOfY0b2khTDzMgMUDhkbIFwIqssi1TFWxRNFB37wtnPWXFYMINRnPEfxgQVMI8CUWpiRn00bG7QZ62K';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51Hogf7HrFbKq9S5d7aGUZUZReFxz1Bg7y3A8tPaOBqfJ9R5f4p49bS9VoPRcchIZWOvhF9LehybleYr7GIWOqTWU009YWlTgXP",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } catch (err) {
      print('There is an error : $err');
    }

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

      // CreditCard card = {
      //   'last4': paymentMethod.card.last4,
      //   'exp_month': paymentMethod.card.expMonth,
      //   'exp_year': paymentMethod.card.expYear,
      // };

      // CreditCard card = CreditCard(
      //   last4: paymentMethod.card.last4,
      //   expMonth: paymentMethod.card.expMonth,
      //   expYear: paymentMethod.card.expYear,
      // );

      // StripePayment.createTokenWithCard(card)
      //     .then((token) => print(token.tokenId));
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return _getPlatformExceptionErrorResult(err);
    }
    // catch (err) {
    //   return new StripeTransactionResponse(
    //     message: 'Transaction failed: ${err.toString()}',
    //     success: true,
    //   );
    // }
  }

  static _getPlatformExceptionErrorResult(PlatformException error) {
    String message = 'Something went wrong';
    if (error.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
      message: message,
      success: false,
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: StripeService.headers,
      );
      return jsonDecode((response.body));
    } catch (err) {
      print(err.toString());
    }

    return null;
  }
}
