# 💧 RainTrack Pro
### Smart Rainwater Harvesting Monitoring App
> **Built for University Project Demo · Flutter + Provider · No Firebase required to run**

---

## 🚀 Quick Start (3 steps)

```bash
# 1. Make sure Flutter SDK is installed
flutter --version

# 2. Get packages
cd /Users/kuwarjibetha/Study/Ai_Task/RainWater
flutter pub get

# 3. Run the app (on connected device or emulator)
flutter run
```

> ✅ **The app boots with pre-loaded demo data — no login server, no Firebase needed!**
> Use **any email** and **any password (6+ characters)** to sign in.

---

## 📱 Features

| Feature | Details |
|---|---|
| 🔐 **Authentication** | Sign in / Sign up with form validation |
| 💧 **Dashboard** | Overall storage gauge + status summary + all tanks |
| 🏦 **Tank Management** | Add, view, delete tanks; set capacity & initial level |
| 📋 **Log Readings** | Record water level %, rainfall, harvested & consumed quantities |
| 📈 **Analytics** | Line chart (level trend) + bar chart (harvested vs consumed) |
| 🔎 **Tank Detail** | 14-day mini chart + full reading history |
| 👤 **Profile** | User info, system stats, sign out |
| ⚠️ **Smart Alerts** | Critical/Low/Normal/Full auto-status per tank |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                    ← App entry point
├── app.dart                     ← MaterialApp + AppColors design system
├── models/
│   └── models.dart              ← TankModel, WaterLog, AnalyticsPoint
├── providers/
│   └── rain_provider.dart       ← All state: auth, tanks, logs, analytics
├── screens/
│   ├── splash_screen.dart       ← Animated logo splash
│   ├── home_screen.dart         ← Bottom nav host
│   ├── auth/
│   │   └── login_screen.dart    ← Sign in / Sign up
│   ├── tabs/
│   │   ├── dashboard_tab.dart   ← Home dashboard
│   │   ├── tanks_tab.dart       ← Tank list + add tank sheet
│   │   ├── analytics_tab.dart   ← Charts & stats
│   │   └── profile_tab.dart     ← User profile
│   ├── tank_detail_screen.dart  ← Per-tank detail + history
│   └── log_reading_sheet.dart   ← Log water reading bottom sheet
└── widgets/
    └── widgets.dart             ← GlassCard, WaterGauge, TankCard, etc.
```

---

## 🎨 Design System

| Token | Value | Usage |
|---|---|---|
| **Primary** | `#0EA5E9` Sky Blue | Main actions, gauge fill |
| **Secondary** | `#06B6D4` Cyan | Charts, rainfall data |
| **Success** | `#10B981` Emerald | Normal/Full status |
| **Warning** | `#F59E0B` Amber | Low level status |
| **Danger** | `#EF4444` Red | Critical alerts |
| **Background** | `#070E1A` Deep Navy | App background |
| **Font** | Poppins (Google Fonts) | All text |

---

## 🧱 Architecture

```
UI (Screens/Tabs)
     ↓  context.watch<RainProvider>()
RainProvider (ChangeNotifier)
     ↓  in-memory data + demo seed
TankModel / WaterLog / AnalyticsPoint
```

- **State Management**: Provider (ChangeNotifier pattern)
- **No Network Calls**: All data is in-memory for the demo
- **Firebase Ready**: Just add `google-services.json` + run `flutterfire configure` to enable cloud sync

---

## 📊 Demo Data (Pre-loaded)

| Tank | Capacity | Level | Status |
|---|---|---|---|
| Main Rooftop Tank | 10,000 L | 72% | Normal |
| Garden Reserve | 5,000 L | 45% | Normal |
| Emergency Storage | 8,000 L | 18% | Low |
| Lab Building Tank | 3,000 L | 9% | Critical |

+ **30 days** of generated historical logs per tank for analytics charts.

---

## 🔧 Tech Stack

- **Flutter 3.x** — Cross-platform mobile framework
- **Dart 3.x** — Programming language
- **Provider 6** — State management
- **fl_chart** — Line & bar charts
- **Google Fonts** — Poppins typography
- **uuid** — Unique IDs for tanks/logs
- **intl** — Date formatting

---

*Smart Rainwater Harvesting · University Project · 2024*
