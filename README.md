# 플러터 본인인증 테스트

포트원 본인인증 테스트 앱입니다.

## 프로젝트 사전설정
프로젝트 루트 경로에 `.env` 파일을 생성하고 환경변수를 설정합니다.
```
STORE_ID=store-aa6d5a55-df32-42d8-8d98-ca6efefb2b76 # 상점아이디
CHANNEL_KEY=channel-key-29eae0b1-a323-4cec-99d2-1c02d4b3b025 # 채널 키
USER_CODE=imp27337815 # 고객사 식별코드 (V1)

V1_M_REDIRECT_URL=http://example.com # V1 리디렉션 URL
# 본인인증을 완료하면 다시 리디렉션될 주소... 라고 하지만 아무 값이라도 다됨(?)
# https://developers.portone.io/opi/ko/extra/identity-verification/v1/all/1?v=v1

V2_REDIRECT_URL=portone://complete # V2 리디렉션 URL
```

## 환경

```bash
flutter doctor --verbose
[√] Flutter (Channel stable, 3.24.3, on Microsoft Windows [Version 10.0.22631.4460], locale ko-KR)
    • Flutter version 3.24.3 on channel stable at C:\Users\jake\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 2663184aa7 (3 months ago), 2024-09-11 16:27:48 -0500
    • Engine revision 36335019a8
    • Dart version 3.5.3
    • DevTools version 2.37.3

[√] Windows Version (Installed version of Windows is version 10 or higher)

[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at C:\Users\jake\AppData\Local\Android\Sdk
    • Platform android-34, build-tools 34.0.0
    • ANDROID_HOME = C:\Users\jake\AppData\Local\Android\Sdk
    • Java binary at: C:\Program Files\Android\Android Studio\jbr\bin\java
    • Java version OpenJDK Runtime Environment (build 21.0.3+-12282718-b509.11)
    • All Android licenses accepted.

[√] Chrome - develop for the web
    • Chrome at C:\Program Files\Google\Chrome\Application\chrome.exe

[X] Visual Studio - develop Windows apps
    X Visual Studio not installed; this is necessary to develop Windows apps.
      Download at https://visualstudio.microsoft.com/downloads/.
      Please install the "Desktop development with C++" workload, including all of its default components

[√] Android Studio (version 2024.2)
    • Android Studio at C:\Program Files\Android\Android Studio
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 21.0.3+-12282718-b509.11)

[√] IntelliJ IDEA Ultimate Edition (version 2023.2)
    • IntelliJ at C:\Program Files\JetBrains\IntelliJ IDEA 2023.2.5
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart

[√] VS Code (version 1.92.2)
    • VS Code at C:\Users\jake\AppData\Local\Programs\Microsoft VS Code
    • Flutter extension version 3.100.0

[√] Connected device (4 available)
    • sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 15 (API 35) (emulator)
    • Windows (desktop)            • windows       • windows-x64    • Microsoft Windows [Version 10.0.22631.4460]
    • Chrome (web)                 • chrome        • web-javascript • Google Chrome 131.0.6778.86
    • Edge (web)                   • edge          • web-javascript • Microsoft Edge 131.0.2903.70

[√] Network resources
    • All expected network resources are available.
```


## 연동 매뉴얼 & 샘플코드
- KG이니시스 통합본인인증 서비스 테스트모드 설정 및 연동 가이드 [[바로가기](https://help.portone.io/content/inicis#8_%ED%85%8C%EC%8A%A4%ED%8A%B8-%EC%97%B0%EB%8F%99)]
- (**V1**) KG이니시스 통합본인인증 서비스 연동 매뉴얼 
    - [바로가기](https://developers.portone.io/opi/ko/extra/identity-verification/v1/all/readme?v=v1)
    - [Flutter SDK - Github](https://github.com/iamport/iamport_flutter)
    - [Flutter 샘플코드 - Github](https://github.com/iamport/iamport_flutter/tree/main/example)
- (**V2**) KG이니시스 통합본인인증 서비스 연동 매뉴얼
    - [바로가기](https://developers.portone.io/opi/ko/extra/identity-verification/readme-v2?v=v2)
    - [Flutter 샘플코드 - Github](https://github.com/portone-io/portone-sample/tree/main/flutter)


## Question?
### 1. 왜 V1, V2 두 가지 버전이 있는가?
- 모놀리식 아키텍처(V1)에서 MSA(V2)로의 전환
- V1과 V2가 언제까지 함께 운영될지 모르는 상황에서 서비스를 계속해서 발전시켜 나가기 위해,
- V1과 V2 양쪽 모두 연동 작업을 위한 추상화용 마이크로서비스인 TGS(Transaction Gateway Service)를 도입
- 즉, **포트원 내부적인 이유(개선)로 인해 두 버전이 존재하는 것**임
    > 참고: https://developers.portone.io/blog/posts/2024-03-25-tgs

### 2. V1, V2 각각의 장단점은?
- **V2** 장점
    - 신속한 업데이트 ( 최신 결제 기능을 빠르게 제공할 가능성 )
    - 안정성, 주요 정보를 풍부하게 제공

- **V2** 단점
    - flutter sdk가 없음 ( webview와 브라우저 SDK를 사용하여 구현해야함 )

- **V1** 장점
    - flutter sdk가 있음

- **V1** 단점
    - 언제까지 기능이 업데이트 될 지, 운영될지 모름
    - 그 외, V2의 장점들이 V1 에게는 단점
> 참고: https://developers.portone.io/opi/ko/integration/start/v2/readme?v=v2
