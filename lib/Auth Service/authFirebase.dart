
import 'package:chatmet/Auth%20Service/database_service.dart';
import 'package:chatmet/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  //login

  Future LoginUserWithEmailandPassword(String email,String password)async{


    try{

      User user =(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user !=null)
      {
        return true;
      }
    } on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }


  Future registerUserWithEmailandPassword(String fullName,String email,String password)async{


    try{

      User user =(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user !=null)
        {
          await DatabaseService(uid: user.uid).savingUserData(fullName, email);
          return true;
        }
    } on FirebaseAuthException catch(e)
    {
      return e.message;
    }
}

Future signout () async{
    try{
      await helperFunction.saveUserLoggedInStatus(false);
      await helperFunction.saveUserNameSF("");
      await helperFunction.saveUserEmail ("");
      await firebaseAuth.signOut();
    }catch(e)
  {
    return null;
  }
}
}

