import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/constants.dart';
import '../helper_function/navigation.dart';
import 'confirm_dialog.dart';

void showGuestDialog(){
  confirmDialog(Constants.globalContext(), LanguageProvider.translate("login", "must_login"),
      LanguageProvider.translate("buttons", "login"), () { 
    navPARU(LoginPage());
  });
}