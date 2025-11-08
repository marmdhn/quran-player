# 📖 Qur’an Player App

Aplikasi **Qur’an Player** berbasis Flutter yang memungkinkan pengguna mendengarkan lantunan **murattal Al-Qur’an** dari
berbagai **reciter (qari)** dengan navigasi yang sederhana dan pemutar audio yang interaktif.
Dibangun menggunakan **Flutter stable**, dengan arsitektur modular berbasis **Provider**, **GetIt**, dan **just_audio**.

---

## 🚀 Fitur Utama

* 🎧 **Audio Player Real-time** menggunakan [`just_audio`](https://pub.dev/packages/just_audio)
* ⏯ **Kontrol Play / Pause / Seek**
* 🔁 **Auto-next Surah** setelah audio selesai
* 👤 **Daftar Reciter (Qari)** dengan gambar dan nama
* 📜 **Daftar Surah per Reciter**
* 🧩 **State Management:** Provider
* ⚙️ **Dependency Injection:** GetIt
* 🛠 **Routing Terpusat:** `AppRoutes`

---

## 📁 Struktur Proyek

```
lib/
 ├── core/
 │   ├── config/
 │   │   ├── colors.dart
 │   │   ├── constants.dart
 │   │   └── env.dart
 │   ├── di/locator.dart
 │   ├── utils/size_config.dart
 │   └── services/
 │       ├── api_instance.dart
 │       └── api_service.dart

 ├── data/
 │   ├── models/
 │   │   ├── ayah_model.dart
 │   │   ├── reciter_model.dart
 │   │   └── surah_model.dart
 │   ├── repository/quran_repository.dart
 │   └── static/reciter_images.dart

 ├── presentation/
 │   ├── screens/
 │   │   ├── reciter/
 │   │   │   ├── reciter_screen.dart
 │   │   │   └── widgets/playing_now.dart
 │   │   ├── surah_list/surah_list_screen.dart
 │   │   └── quran_player/
 │   │       ├── quran_player_screen.dart
 │   ├── shared/widgets/
 │   │   ├── reciter_avatar.dart
 │   │   └── loading_indicator.dart
 │   └── view_models/
 │       ├── audio_player_view_model.dart
 │       ├── reciter_view_model.dart
 │       └── surah_view_model.dart

 ├── routes/
 │   ├── app_routes.dart
 │   ├── route_config.dart
 │   └── route_generator.dart

 ├── provider/provider.dart
 └── main.dart

assets/
 ├── images/
 │   ├── ornaments/
 │   └── reciters/
 └── lottie/
```

---

## 🧭 Alur Navigasi Aplikasi

```text
Splash Screen
   ↓
Reciter List Screen
   ↓ (pilih qari)
Surah List Screen
   ↓ (pilih surah)
Qur’an Player Screen
```

Setiap tahap dikelola dengan `AppRoutes` agar navigasi tetap konsisten dan mudah dipelihara.

---

## ⚙️ Implementasi Teknis

### 1. **State Management – Provider**

Masing-masing `ViewModel` mengatur state UI dan data:

| ViewModel              | Tanggung Jawab                                   |
|------------------------|--------------------------------------------------|
| `ReciterViewModel`     | Menyimpan data reciter & pilihan aktif           |
| `SurahViewModel`       | Mengatur daftar surah berdasarkan reciter        |
| `AudioPlayerViewModel` | Mengontrol audio playback, posisi, dan auto-next |

Contoh penggunaan di UI:

```dart

final player = context.watch<AudioPlayerViewModel>();

IconButton
(
icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow),
onPressed: player.togglePlay
,
);
```

---

### 2. **Dependency Injection – GetIt**

Semua dependency diregistrasi di `locator.dart`:

```dart

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<QuranRepository>(() => QuranRepository());
}
```

Akses dari mana pun:

```dart

final quranRepo = getIt<QuranRepository>();
```

---

### 3. **Audio Playback – just_audio**

Audio player diatur di `AudioPlayerViewModel` dengan listener untuk memantau state:

```dart
 AudioPlayerViewModel() {
  audioPlayer.processingStateStream.listen((state) {
    if (state == ProcessingState.completed) {
      isSurahFinished = true;
      notifyListeners();
    }
  });
}
```

---

### 4. **Routing – AppRoutes**

Navigasi antar halaman terpusat agar lebih maintainable:

```dart
class AppRoutes {
  static const reciterList = '/reciterList';
  static const surahList = '/surahList';
  static const quranPlayer = '/quranPlayer';
}
```

---

## ▶️ Cara Menjalankan

1. Clone repo:

   ```bash
   git clone https://github.com/marmdhn/quran-player.git
   cd quran-player
   ```
2. Install dependencies:

   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:

   ```bash
   flutter run
   ```

> Pastikan emulator atau device fisik sudah aktif.

---

## 🎨 Preview (UI Overview)

| Tampilan          | Deskripsi                                        |
|-------------------|--------------------------------------------------|
| **Reciter List**  | Daftar qari lengkap dengan foto & nama           |
| **Surah List**    | Menampilkan daftar surah sesuai reciter          |
| **Qur’an Player** | Kontrol audio, progress bar, dan auto-next surah |

> Simpan screenshot di `/screenshots/` untuk dokumentasi visual.

---

## 💡 Catatan Profesional

* Kode ditulis dengan prinsip **clean architecture** dan **separation of concerns**.
* Menggunakan kombinasi **Provider + GetIt** untuk efisiensi dan maintainability.
* `AudioPlayerViewModel` dapat diuji unit-test dengan mudah karena logic playback terpisah dari UI.
* Desain responsif berkat `SizeConfig`.

---

## 🧾 Lisensi

Proyek ini bersifat open-source dan digunakan untuk keperluan demonstrasi teknikal.

---
