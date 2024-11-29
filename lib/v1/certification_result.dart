import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CertificationResult extends StatefulWidget {
  const CertificationResult({super.key});

  @override
  State<CertificationResult> createState() => _CertificationResultState();
}

class _CertificationResultState extends State<CertificationResult> {
  String? userName;
  String? birthday;
  String? phone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, String> result =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      /* 응답 예시
      {
        "imp_uid": "imp_945956592472",
        "success": "true",
        "merchant_uid": "mid_1732862948223"
      }
      */
      fetchUserInfo(result);
    });
  }

  Future<void> fetchUserInfo(Map<String, String> result) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8080/api/resources/identity-verifications/v1'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(result),
        // body: jsonEncode({'imp_uid': result['imp_uid']}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          userName = data['name'];
          birthday = data['birthday'];
          phone = data['phone'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final success = result['success'] == 'true';

    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증 결과'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              success ? '본인인증에 성공하였습니다' : '본인인증에 실패하였습니다',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  _buildInfoRow('생년월일', birthday!),
                  _buildInfoRow('연락처', phone!),
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
