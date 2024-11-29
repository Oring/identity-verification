import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CertificationResultV2 extends StatefulWidget {
  const CertificationResultV2({super.key});

  @override
  State<CertificationResultV2> createState() => _CertificationResultV2State();
}

class _CertificationResultV2State extends State<CertificationResultV2> {
  String? userName;
  String? birthDate;
  String? phoneNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic> result =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      fetchUserInfo(result);
    });
  }

  Future<void> fetchUserInfo(Map<String, dynamic> result) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8080/api/resources/identity-verifications/v2'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(result),
        /* 응답 예시
        {
          "identityVerificationId": "identity-verification-c4015047-d0bd-417b-984a-0ccce36c35c5",
          "identityVerificationTxId": "01937702-2765-b741-5d38-7576e62d901b",
          "transactionType": "IDENTITY_VERIFICATION"
        }
        */
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          userName = data['name'];
          birthDate = data['birthDate'];
          phoneNumber = data['phoneNumber'];
          isLoading = false;
        });
      } else {
        // 실패 얼럿 띄우기
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('인증 정보 조회 실패 [${response.body}]'),
          ),
        );

        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증 결과 v2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              '본인인증이 완료되었습니다',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text('인증 결과: $result'),
            const SizedBox(height: 32),
            if (isLoading)
              const CircularProgressIndicator()
            else if (userName != null)
              Column(
                children: [
                  _buildInfoRow('이름', userName!),
                  _buildInfoRow('생년월일', birthDate!),
                  _buildInfoRow('연락처', phoneNumber!),
                ],
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('처음으로'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
