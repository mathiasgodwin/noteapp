import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

import 'package:noteapp_server/src/web/routes/root.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  ///

  Future<bool> sendVerificationEmail({
    required String emailAddress,
    required String verificationCode,
  }) async {
    bool? isSent;

    final username = "your@domain.com";
    final password = "password word";
    final smtpServer = SmtpServer(
      "smtp-relay.sendinblue.com",
      port: 111,
      username: username,
      password: password,
    );

    final message = Message()
      ..recipients.add(emailAddress)
      ..from = Address(username, "Comapany\'s name")
      ..subject = "Verification code"
      ..text = "Hi, \n This is your verification code: ${verificationCode}.";
    try {
      final sendReport = await send(message, smtpServer);
      isSent = true;
    } on MailerException catch (e) {
      isSent = false;
    }
    return isSent;
  }

  auth.AuthConfig.set(
    auth.AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        final isSent = await sendVerificationEmail(
            emailAddress: email, verificationCode: validationCode);
        return isSent;
      },
      sendPasswordResetEmail: (session, userInfo, validationCode) async {
        // Add password reset email logic.

        ///  The function require that we return a bool
        /// if the email was sent or not. return `true` for demo
        return Future.value(true);
      },
    ),
  );

  ///

  // Start the server.
  await pod.start();
}
