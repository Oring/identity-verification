import 'package:flutter/material.dart';
import 'package:id_verification/v1/certification.dart';
import 'package:id_verification/v1/certification_result.dart';
import 'package:id_verification/v2/certification_v2.dart';
import 'package:id_verification/v2/certification_result_v2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '본인인증 테스트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/certification': (context) => const Certification(),
        '/certification-result': (context) => const CertificationResult(),
        '/certification-v2': (context) => const CertificationV2(),
        '/certification-result-v2': (context) => const CertificationResultV2(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/certification'),
              child: const Text('본인인증 하기 v1'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/certification-v2'),
              child: const Text('본인인증 하기 v2'),
            ),
          ],
        ),
      ),
    );
  }
}
