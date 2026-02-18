# PlayTrack - Community Sports Tournament Tracker

A complete Flutter application for improving visibility of community sports tournaments. PlayTrack provides real-time score updates, player statistics, leaderboards, and tournament management features.

## 🎯 Features Overview

### 1. **Splash Screen**
- Beautiful app logo and branding
- Auto-navigation based on authentication status
- Seamless loading experience

### 2. **Authentication System**
- **User Login**: Sign in to view tournaments
- **Admin Login**: Access tournament management tools
- **Registration**: Create new user accounts
- **Role-Based Access Control**: Different features for admin vs users

### 3. **Home Screen**
- Dashboard with ongoing & upcoming tournaments
- Quick navigation to live scores, leaderboards, player stats
- Featured tournament banners
- Real-time data updates

### 4. **Tournament Details**
- Comprehensive tournament information
- List of all matches in tournament
- Team registration functionality
- Prize pool and scheduling details

### 5. **Live Scores** ⚡
- Real-time match score updates via Firestore
- Sport-specific score formats (Football goals, Cricket runs/wickets, etc.)
- Live status indicators
- Quick access to detailed match info

### 6. **Match Details**
- Full game information with live scores
- Match timeline/events (goals, wickets, etc.)
- Admin controls to update scores
- Venue details and timing

### 7. **Player Statistics**
- Browse players by team
- Sport-specific stats (goals, runs, points, assists, etc.)
- Search and filter players
- Performance tracking

### 8. **Leaderboard** 🏆
- Real-time team rankings
- Points-based standings
- Win/Loss/Draw records
- Top 3 team badges

### 9. **Tournament Registration**
- Register new or existing teams
- Form validation
- Spot availability tracking
- Easy registration flow

### 10. **Admin Dashboard**
- Create tournaments
- Manage teams and players
- Create and update matches
- Update match scores and status

## 📁 Project Structure

```
lib/
├── main.dart
├── config/
│   ├── routes.dart
│   └── theme.dart
├── models/
│   ├── user.dart
│   ├── tournament.dart
│   ├── team.dart
│   ├── match.dart
│   ├── player.dart
│   └── registration.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/
│   └── app_providers.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── admin_login_screen.dart
│   ├── home_screen.dart
│   ├── tournament_detail_screen.dart
│   ├── live_scores_screen.dart
│   ├── match_detail_screen.dart
│   ├── player_stats_screen.dart
│   ├── leaderboard_screen.dart
│   ├── tournament_registration_screen.dart
│   └── admin_dashboard_screen.dart
├── widgets/
└── utils/
    ├── constants.dart
    └── sample_data.dart
```

## 🔧 Tech Stack

- **Flutter** 3.10+ with Null Safety
- **Firebase Authentication** for user management
- **Cloud Firestore** for real-time database
- **Riverpod** (^2.6.3) for state management
- **Material Design 3** for UI

## 📚 Firestore Collections

### Users
```
users/{uid}
├── email: string
├── name: string
├── role: 'admin' | 'user'
├── phoneNumber: string?
├── createdAt: timestamp
└── isActive: boolean
```

### Tournaments
```
tournaments/{id}
├── name: string
├── sport: 'Football' | 'Cricket' | 'Basketball' | 'Volleyball'
├── status: 'upcoming' | 'ongoing' | 'completed'
├── startDate: timestamp
├── endDate: timestamp
├── location: string
├── maxTeams: number
├── registeredTeams: array
├── prizePool: string
└── createdAt: timestamp
```

### Teams
```
teams/{id}
├── name: string
├── coach: string
├── playerIds: array
├── wins: number
├── losses: number
├── draws: number
├── points: number
└── createdAt: timestamp
```

### Players
```
players/{id}
├── name: string
├── sport: string
├── teamId: string
├── jerseyNumber: number
├── position: string
├── stats: object (flexible per sport)
├── dateOfBirth: timestamp
└── createdAt: timestamp
```

### Matches
```
matches/{id}
├── tournamentId: string
├── teamAId: string
├── teamBId: string
├── sport: string
├── scoreTeamA: object
├── scoreTeamB: object
├── status: 'scheduled' | 'ongoing' | 'completed'
├── startTime: timestamp?
├── endTime: timestamp?
├── venue: string
├── events: array<MatchEvent>
└── createdAt: timestamp
```

### Registrations
```
registrations/{id}
├── tournamentId: string
├── teamId: string
├── status: 'pending' | 'approved' | 'rejected'
├── registeredAt: timestamp
└── notes: string?
```

## ⚙️ Setup Instructions

### Prerequisites
- Flutter 3.10.7+
- Firebase project with Auth & Firestore enabled
- Git

### Step 1: Clone Repository
```bash
git clone <repo-url>
cd playtrack
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Configure Firebase
```bash
flutterfire configure
```
Select your Firebase project when prompted.

### Step 4: Run Application
```bash
flutter run
```

## 📱 Usage

### For Users
1. Sign up with email/password
2. Browse ongoing & upcoming tournaments
3. Check live scores in real-time
4. View player statistics
5. Check tournament leaderboards
6. Register team for tournaments

### For Admins
1. Login with admin credentials
2. Create new tournaments
3. Add teams and players
4. Create matches
5. Update live scores
6. Manage tournament status

## 🔐 Security Rules

Recommended Firestore security rules to enforce role-based access:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    match /{document=**} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 🎨 Theme Customization

Edit `lib/config/theme.dart` to customize colors:
```dart
static const Color primaryColor = Color(0xFF1976D2);
static const Color accentColor = Color(0xFFFF6F00);
```

## 📊 Sample Data

Initialize sample data for testing:
```dart
await SampleData.initializeAll();
```

This creates:
- 3 sample tournaments
- 5 sample teams
- 7 sample players
- 3 sample matches

## 🚀 Features Implemented

✅ Complete authentication system  
✅ Real-time Firestore integration  
✅ Riverpod state management  
✅ StreamBuilder for live updates  
✅ Role-based access control  
✅ Admin dashboard  
✅ Tournament management  
✅ Live score tracking  
✅ Player statistics  
✅ Leaderboard rankings  
✅ Team registration  
✅ Material Design 3 UI  
✅ Null-safe Dart code  
✅ Clean architecture  

## 🔄 State Management (Riverpod)

Key providers:
- `authServiceProvider`: Firebase Auth service
- `firebaseUserProvider`: Current user stream
- `isAuthenticatedProvider`: Auth state boolean
- `allTournamentsProvider`: All tournaments stream
- `ongoingMatchesProvider`: Live matches stream
- `currentUserProfileProvider`: Current user data

## 🐛 Troubleshooting

**Firebase not connecting:**
- Run `flutterfire configure` again
- Check `firebase_options.dart` is present
- Verify Firebase project credentials

**Hot reload issues:**
- Use `flutter run` with `-v` flag for verbose output
- Try hot restart or full rebuild
- Clear build cache: `flutter clean`

**Firestore data not showing:**
- Check security rules allow read access
- Verify collection names (case-sensitive)
- Check network connectivity
- Look at Firestore console for data presence

## 📖 Code Standards

- Follow Dart style guide
- Add comments for complex logic
- Use meaningful variable names
- Type everything (null-safe)
- Handle errors gracefully

## 🤝 Contributing

1. Create feature branch
2. Make your changes
3. Test thoroughly
4. Submit pull request

## 📄 License

MIT License - Use freely for personal & commercial projects

## 📞 Support

Issues or questions? Check:
- Code comments and documentation
- Sample data implementation
- Official Flutter docs
- Firebase documentation

---

**Built with ❤️ for community sports visibility**

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
