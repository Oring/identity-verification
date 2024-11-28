import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';

class Certification extends StatelessWidget {
  const Certification({super.key});

  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      appBar: AppBar(
        title: const Text('본인인증'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      initialChild: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('잠시만 기다려주세요...'),
          ],
        ),
      ),
      userCode: 'imp27337815',
      data: CertificationData(
        pg: 'inicis_unified',
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
        mRedirectUrl: 'http://detectchangingwebview/iamport/f',
      ),
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/certification-result',
          arguments: result,
        );
      },
    );
  }
}
