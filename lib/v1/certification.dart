import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      userCode: '${dotenv.env['USER_CODE']}',
      data: CertificationData(
        pg: 'inicis_unified', // KG 이니시스 통합인증
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
        // mRedirectUrl ? 리디렉션 될 URL. (https://developers.portone.io/opi/ko/extra/identity-verification/v1/all/1?v=v1)
        //                본인인증을 완료하면 다시 리디렉션될 주소... 라고 하지만 아무 값이라도 다됨.
        mRedirectUrl: '${dotenv.env['V1_M_REDIRECT_URL']}',
        // mRedirectUrl: 'http://10.0.2.2:8080/api/v1/certification/verify',
        // mRedirectUrl: 'http://detectchangingwebview/iamport/f',
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
