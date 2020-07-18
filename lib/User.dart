


class User
{
  String Email;
  String Password;

  User(String email, String password)
  {
    this.Email = email;
    this.Password = password;
  }


}


//try
//{
//if(email.contains('@') && email.contains('.'))
//{
//this.Email = email;
//this.Password = password;
//}
//else
//{
//throw new InvalidEmailException();
//}
//}
//on InvalidEmailException catch(e)
//{
//print(e.errMsg());
//}
//
//class InvalidEmailException implements Exception{
//  String errMsg() => 'Invalid Email';
//}

