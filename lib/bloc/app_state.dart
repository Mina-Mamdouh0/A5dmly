abstract class AppStates{}

class InitialState extends AppStates{}

class LoadingLoginScreen extends AppStates{}
class SuccessLoginScreen extends AppStates{}
class ErrorLoginScreen extends AppStates{
  final String error;
  ErrorLoginScreen(this.error);
}

class LoadingSignUpScreen extends AppStates{}
class SuccessSignUpScreen extends AppStates{}
class ErrorSignUpScreen extends AppStates{
  final String error;
  ErrorSignUpScreen(this.error);
}

class LoadingGetDataUser extends AppStates{}
class SuccessGetDataUser extends AppStates{}
class ErrorGetDataUser extends AppStates{
  final String error;
  ErrorGetDataUser(this.error);
}

class LoadingUploadOrder extends AppStates{}
class SuccessUploadOrder extends AppStates{}
class ErrorUploadOrder extends AppStates{
  final String error;
  ErrorUploadOrder(this.error);
}

class LoadingGetOrderUsers extends AppStates{}
class SuccessGetOrderUsers extends AppStates{}
class ErrorGetOrderUsers extends AppStates{
  final String error;
  ErrorGetOrderUsers(this.error);
}

class LoadingGetOrderTechnical extends AppStates{}
class SuccessGetOrderTechnical extends AppStates{}
class ErrorGetOrderTechnical extends AppStates{
  final String error;
  ErrorGetOrderTechnical(this.error);
}

class LoadingGetOrderFinishUsers extends AppStates{}
class SuccessGetOrderFinishUsers extends AppStates{}
class ErrorGetOrderFinishUsers extends AppStates{
  final String error;
  ErrorGetOrderFinishUsers(this.error);
}

class LoadingGetOrderFinishTechnical extends AppStates{}
class SuccessGetOrderFinishTechnical extends AppStates{}
class ErrorGetOrderFinishTechnical extends AppStates{
  final String error;
  ErrorGetOrderFinishTechnical(this.error);
}

class LoadingGetOrderConfirmTechnical extends AppStates{}
class SuccessGetOrderConfirmTechnical extends AppStates{}
class ErrorGetOrderConfirmTechnical extends AppStates{
  final String error;
  ErrorGetOrderConfirmTechnical(this.error);
}

class LoadingEditInfo extends AppStates{}
class SuccessEditInfo extends AppStates{}
class ErrorEditInfo extends AppStates{
  final String error;
  ErrorEditInfo(this.error);
}

class LoadingRatApp extends AppStates{}
class SuccessRatApp extends AppStates{}
class ErrorRatApp extends AppStates{
  final String error;
  ErrorRatApp(this.error);
}

class LoadingOrderConfirm extends AppStates{}
class SuccessOrderConfirm extends AppStates{}
class ErrorOrderConfirm extends AppStates{
  final String error;
  ErrorOrderConfirm(this.error);
}

class LoadingAddNotification extends AppStates{}
class SuccessAddNotification extends AppStates{}
class ErrorAddNotification extends AppStates{
  final String error;
  ErrorAddNotification(this.error);
}

class LoadingGetNotification extends AppStates{}
class SuccessGetNotification extends AppStates{}
class ErrorGetNotification extends AppStates{
  final String error;
  ErrorGetNotification(this.error);
}

class SignOutState extends AppStates{}
class ChangeImageState extends AppStates{}

class SuccessFinishOrder extends AppStates{}
class ErrorFinishOrder  extends AppStates{}


