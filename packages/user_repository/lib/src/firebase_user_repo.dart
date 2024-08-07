import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/user_repository.dart';
import 'user_repo.dart';

class FirebaseUserRepo implements UserRepository{
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

  // Constructor
  FirebaseUserRepo({FirebaseAuth? firebaseAuth,}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if(firebaseUser == null){
        yield MyUser.empty;
      }else{
        yield await userCollection
        .doc(firebaseUser.uid).get()
        .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
      }
    });
  }
  @override
  Future<void> signIn(String email, String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async{
    try{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);
      myUser.userId = user.user!.uid;
      return myUser;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> logOut() async{
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try{
      await userCollection.doc(myUser.userId).set(myUser.toEntity().toDocument());
    }catch(e){
      rethrow;
    }
  }


  

}