import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to get the current user's ID
// final currentUserIdProvider = Provider<String?>((ref) {
//   final auth = FirebaseAuth.instance;
//   return auth.currentUser?.uid;
// });

final currentUserIdProvider =
    StateNotifierProvider<CurrentUserUserIdNotifier, String?>(
        (ref) => CurrentUserUserIdNotifier());

final currentUserImageProvider =
    StateNotifierProvider<CurrentUserImageNotifier, String?>(
        (ref) => CurrentUserImageNotifier());

final currentUserUserNameProvider =
    StateNotifierProvider<CurrentUserUserNameNotifier, String?>(
        (ref) => CurrentUserUserNameNotifier());

final currentUserEmailProvider =
    StateNotifierProvider<CurrentUserEmailNotifier, String?>(
        (ref) => CurrentUserEmailNotifier());

class CurrentUserImageNotifier extends StateNotifier<String?> {
  CurrentUserImageNotifier() : super(null);

  Future<void> fetchImageUrl() async {
    final auth = FirebaseAuth.instance;
    // final currentUserId = ref.read(currentUserIdProvider);
    final db = FirebaseFirestore.instance;
    try {
      final userDoc =
          await db.collection('users').doc(auth.currentUser!.uid).get();

      if (userDoc.exists) {
        final imageUrl = userDoc['image_url'] as String?;
        print('Fetched image URL: $imageUrl');
        state = imageUrl;
        if (imageUrl != null) {
          state = imageUrl;
        } else {
          print('Image URL is null');
        }
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching image URL: $e');
    }
  }
}

class CurrentUserEmailNotifier extends StateNotifier<String?> {
  CurrentUserEmailNotifier() : super(null);

  Future<void> fetchEmail() async {
    final auth = FirebaseAuth.instance;
    // final currentUserId = ref.read(currentUserIdProvider);
    final db = FirebaseFirestore.instance;
    try {
      final userDoc =
          await db.collection('users').doc(auth.currentUser!.uid).get();

      if (userDoc.exists) {
        final email = userDoc['email'] as String?;
        print('Fetched email: $email');
        state = email;
        if (email != null) {
          state = email;
        } else {
          print('email URL is null');
        }
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching email: $e');
    }
  }
}

class CurrentUserUserNameNotifier extends StateNotifier<String?> {
  CurrentUserUserNameNotifier() : super(null);

  Future<void> fetchUsername() async {
    final auth = FirebaseAuth.instance;
    // final currentUserId = ref.read(currentUserIdProvider);
    final db = FirebaseFirestore.instance;
    try {
      final userDoc =
          await db.collection('users').doc(auth.currentUser!.uid).get();

      if (userDoc.exists) {
        final username = userDoc['username'] as String?;
        print('Fetched username URL: $username');
        state = username;
        if (username != null) {
          state = username;
        } else {
          print('username URL is null');
        }
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }
}

class CurrentUserUserIdNotifier extends StateNotifier<String?> {
  CurrentUserUserIdNotifier() : super(null);

  Future<void> fetchId() async {
    final auth = FirebaseAuth.instance;
    state = auth.currentUser?.uid;
  }
}
// StateProvider to hold the image URL
// final imageUrlProvider = StateProvider<String?>((ref) => null);

// FutureProvider to fetch the current user's image URL

// printProvider() async {
//   final db = FirebaseFirestore.instance;

//   try {
//     DocumentSnapshot userDoc = await db
//         .collection('users')
//         .doc(currentUserIdProvider.toString())
//         .get();

//     if (userDoc.exists &&
//         userDoc.data() != null &&
//         userDoc['image_url'] != null) {
//       final String imageUrl = userDoc['image_url'];
//       // Safely access the state property using null-aware chaining (?.):
//        ref.read(currentImageUrlProvider).state = imageUrl;  
//     }
//   } catch (e) {
//     print("Error fetching image URL: $e");
//   }
// }

// final String currentUserImageUrl = printProvider();
// final currentUserImageUrlProvider = Provider<String?>((ref) {
//   final String currentUserImageUrl = printProvider();
//   return currentUserImageUrl;
// });
