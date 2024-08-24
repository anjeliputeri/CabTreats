import 'package:dartz/dartz.dart';
import 'package:flutter_onlineshop_app/core/core.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailRemoteDataSource {
  Future sendEmailOrder(int subTotal, int shippingCost, int total, customerEmail, vendorEmail, orderID) async {
    String username = 'ihsansyafiul@gmail.com';
    String password = 'jopwznswqxjdgegb';

    const htmlGen = $AssetsHtmlGen();
    var content = await htmlGen.loadHtmlContent(htmlGen.newOrderTemplate);

    content = content.replaceAll('{{orderID}}', orderID);
    content = content.replaceAll('{{vendorEmail}}', vendorEmail);
    content = content.replaceAll('{{customerEmail}}', customerEmail);
    content = content.replaceAll('{{subTotal}}', subTotal.currencyFormatRp);
    content = content.replaceAll('{{shippingCost}}', shippingCost.currencyFormatRp);
    content = content.replaceAll('{{total}}', total.currencyFormatRp);


    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'cabtreats')
      ..recipients.add('cabtreats.uii@gmail.com')
      ..subject = 'New Order Recieved'
      ..html = content;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
