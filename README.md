# Attendly - Ứng dụng điểm danh thông minh

Attendly là một ứng dụng di động được phát triển bằng Flutter, giúp quản lý điểm danh trong lớp học một cách hiệu quả và thông minh. Ứng dụng hỗ trợ hai vai trò chính: giáo viên và học sinh.

## Tính năng chính

### Cho học sinh
- Quét mã QR để điểm danh
- Chọn ảnh mã QR từ thư viện
- Xem thông tin điểm danh
- Đăng nhập/đăng ký tài khoản

### Cho giáo viên
- Tạo và quản lý lớp học
- Tạo phiên điểm danh với mã QR
- Xem danh sách học sinh đã điểm danh
- Quản lý thông tin lớp học

## Yêu cầu hệ thống

- Flutter SDK (phiên bản mới nhất)
- Dart SDK (phiên bản mới nhất)
- Android Studio hoặc VS Code với Flutter extension
- Git

## Cài đặt

1. Clone repository:
```bash
git clone https://github.com/phamchien789vn/Attendly-FE-Flutter.git
cd Attendly-FE-Flutter
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Cấu hình API:
```
Vào file lib/utils/api_constants.dart. Cấu hình lại hằng số "baseUrl"
```

4. Chạy ứng dụng:
```bash
flutter run
```

## Cấu trúc dự án

```
lib/
├── utils/              # Các hằng số và cấu hình
│   └── api_constants.dart
├── models/             # Các model dữ liệu
│   ├── classroom.dart
│   ├── session.dart
│   ├── user.dart
│   └── jwt_payload.dart
├── providers/          # State management
│   └── auth_provider.dart
├── screens/            # Các màn hình
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── student_screen.dart
│   ├── teacher_screen.dart
│   └── classroom_detail_screen.dart
├── services/           # Các service API
│   ├── auth_service.dart
│   ├── attendance_service.dart
│   └── classroom_service.dart
├── widgets/            # Các widget tái sử dụng
│   └── session_list.dart
├── main.dart           # Entry point của ứng dụng
└── routes.dart         # Định nghĩa các route

pubspec.yaml       # Cấu hình dependencies và assets
```

## Công nghệ sử dụng

- Flutter
- Provider (State Management)
- HTTP (API calls)
- Mobile Scanner (QR code scanning)
- Google ML Kit (Barcode scanning)
- Image Picker (Gallery access)