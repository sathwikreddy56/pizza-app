
class MyUserEntity{
  String userId;
  String email;
  // String password;
  String name;
  bool hasActiveCart;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
  });

  //send json to the firebase database since that is the format firebase can accept
  Map<String,Object?> toDocument(){
    return {
      'userId':userId,
      'email':email,
      'name':name,
      'hasActiveCart':hasActiveCart,
    };
  }

  static MyUserEntity fromDocument(Map<String,dynamic> doc){
    return MyUserEntity(
      userId: doc['userId'], 
      email: doc['email'], 
      name: doc['name'], 
      hasActiveCart: doc['hasActiveCart']);
  }


}