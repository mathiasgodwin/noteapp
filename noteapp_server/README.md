## About this guide

> Most enterprise software needs a method of authenticating its users. Depending on the type of `user`, It could be a programmer trying to access a resource through Application Programming Interface (API) or an end-user directly performing a task through forms on their website or apps.



Serverpod as a backend framework provides feature-rich authentication modules and methods for your app need. Serverpod is very suitable for building both simple and complex backends for Flutter apps. But Serverpod could be complex to set up at first and the folder structure might not be intuitive for beginners. Hence the need for this tutorial.



## What to expect in the tutorial
This tutorial is to demonstrate `Authentication` in Serverpod. This guide only explains authentication with ***Google*** and ***Email*** and how to connect both the backend (Serverpod) setup with your frontend (Flutter app).

This tutorial assumes some prior knowledge of Serverpod and Flutter. You should check [this](https://dev.to/mathiasgodwin/crud-operations-with-serverpod-a-step-by-step-guide-for-flutter-apps-925) tutorial on how to get started with Serverpod.

---

## Getting started
> _Serverpod comes with built-in user management and authentication. You can either build your custom authentication method or use the `serverpod_auth` module. The module makes it easy to authenticate with email or social sign-ins._ **from the [_doc_](https://docs.serverpod.dev/concepts/authentication#:~:text=Version%3A%201.1.0-,Authentication,-Serverpod%20comes%20with)**


You will be using the `serverpod_auth` module for this tutorial. 

You will need an understanding of `Modules` in Serverpod to be able to add authentication to your project without much problem.

Clone this simple [noteapp](https://github.com/mathiasgodwin/noteapp) project from GitHub. The cloned project has some setup that was covered in this [tutorial](https://dev.to/mathiasgodwin/crud-operations-with-serverpod-a-step-by-step-guide-for-flutter-apps-925). You will be working with the project.

You could skip the `Modules` explanation part if you have prior knowledge of how it works without missing anything.

---

## What are modules in Serverpod
As stated in the documentation: 
> _Serverpod is built around the concept of modules. A Serverpod module is similar to a Dart package but contains both server and client code and Flutter widgets. A module contains its namespace for endpoints and methods to minimize module conflicts._

This means modules in Serverpod are like your flutter packages that are reusable and publishable to [pub](https://pub.dev).

Modules in Serverpod consist of two folders, the `Client` and the `Server` folder.

Execute the command below to generate a module called `user_module` to see its structure:
```bash
serverpod create --template module user_module
```
You will get...
```bash
├── user_module
│   ├── user_module_client
│   └── user_module_server
```

#### How to set up a module
There are Four (4) steps needed to fully add an existing module to your project.

Let's go through the steps with a demonstration.

Assuming your project is called `app`:
```dart 
├── app
│   ├── app_client
│   ├── app_flutter
│   ├── app_server
```
And you want to add the `user_module`...

**1.** Database Setup

Serverpod generates a set of database tables whenever you create a new `Server` or `Module` project with the framework. These tables must be added to your database source before Serverpod could function properly. 

Your database tables live in _{name}_server/generated/_ of your Server folder. For the generated `user_module`, the database is in _user_module_server/generated/_.

Copy the content of _{name}_server/generated/tables.pgsql_ of both your current project (`app`) and module (`user_module`) into your database client and run the query to add the necessary tables, do this one after the other.


**2.** Server setup

Add the module's server (`user_moduble/user_module_server/`) to your project's server (`app/app_server/`) as a dependency.

```yaml
dependencies:
  user_module_server: ^1.x.x # Assuming it was hosted
```

Then open your project's _config/generator.yaml_ file and 
add a name known as `nickname` for your module, primarily used for referencing the module from your app. 

```yaml
modules:
  user_module:
    nickname: user
```

You will reference the module with the nickname from your Flutter app like this...

```dart
// ...
final user = client.user.name;
```

Execute the command below inside your project's server folder (`app/app_server/`) to get the module and generate the necessary files.
```bash
dart pub get
```
Then...
```bash
serverpod generate
```

**3.** Client setup

Add the module's client as a dependency on your project's client.
```yaml
dependencies:
  user_module_client: ^1.x.x
```
Then execute the command below.
```bash
dart pub get
```

**4.** Flutter app setup

Finally, a module can have Flutter package(s). The Flutter packages are usually separated. 
An example is the serverpod_auth_google_flutter package for the serverpod_auth module.

Consider adding the flutter packages to your project's flutter app (`app/app_flutter/`) as a dependency.


The preceding information is enough to get you started with this tutorial but you can Check the [documentation](https://docs.serverpod.dev/concepts/modules) for more details.


---


## Authentication
You'll be using Serverpod's [auth](https://pub.dev/packages/serverpod_auth_server) module which handles basic user information such as user profile picture or names and how to retrieve/update the information.

Before we dive in into the explanation of the Serverpod auth module, Let's have a basic understanding of how authentication works in Serverpod and how it can help us build a better backend app.

-  **Route guard**
   
Serverpod provides the logic to restrict access to an endpoint. For instance, you can require the user to log in before accessing the full features of the app or website.

For example...
```dart
class AppEndpoint extends Endpoint {
// ... 
@override
bool get requireLogin => true;
}
```

Restrictions can also be scoped. 

This means scoping allows only a type of user to access the resource, it could be an admin or any user (logged in or not logged in).

```dart
class SomeEndpoint extends Endpoint {
// ...
/// This requires that the user is a `driver` to access this endpoint
@override
Set<Scope> get requiredScopes => {Scope('driver')};
}
```

With `serverpod_auth_server`, You can update the scope of a user with...
```dart
/// Elevate the user’s scope to tell Serverpod that this user is now a `driver`
await Users.updateUserScopes(session, userId, {Scope('driver')});
```
   
-   **User profile**
   
Serverpod provides a handy `Session` object that stores information about the current user.

Access the logged-in user with the help of the `Session` object as follow...
```dart
Future<void> doSomething(Session session) async {
final isSignedIn = await session.auth.authenticatedUserId != null;
if (isSignedIn) {
 //Do something here
}
}
```
    
-  **Session managing**
    
Serverpod also provides a `SessionManager` object that tracks the user's state. The `SessionManager` can be used to sign out a user.

```dart
late SessionManager sessionManager;
late Client client;

void main() async {
// ...
client = Client(
'http://localhost:8080/',
authenticationKeyManager: FlutterAuthenticationKeyManager(),
)..connectivityMonitor = FlutterConnectivityMonitor();   
// The session manager keeps track of the signed-in state of the user. You
// can query it to see if the user is currently signed in and get information
// about the user.
sessionManager = SessionManager(
caller: client.modules.auth,
);
await sessionManager.initialize();

}
```


Now that you have the basic knowledge of how Serverpod handles `endpoint` restrictions, Let's integrate the authentication module into the cloned [noteapp](https://github.com/mathiasgodwin/noteapp) project.


You will need to start docker and Serverpod to continue.


Start docker and execute the command below inside _noteapp/noteapp_server/_ to start the necessary docker containers and to start Serverpod...

```bash
docker-compose up --build --detach
```
Then...
```bash
dart bin/main.dart
```

You should see output like this on your terminal if everything goes fine...

![Starting Severpod and docker container](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/m54s6j2md53rc4xzrrrb.png)


#### Configuring auth module
You need to configure the module before the next section.
-  **Database setup**
   	
Add the database content of `serverpod_auth_server` to your project's database. Copy the database query generated for the `serverpod_auth` module from the source [here](https://github.com/serverpod/serverpod/blob/main/modules/serverpod_auth/serverpod_auth_server/generated/tables.pgsql) into your database client and run the query.  


-  **Server setup**
    
Add serverpod_auth_server to your project's server (`noteapp/noteapp_server/`) as a dependency.

```yaml
dependencies:
  serverpod_auth_server: ^1.x.x
```

Then open _config/generator.yaml_ file and 
add `nickname` for your module. 

```yaml
modules:
  serverpod_auth:
    nickname: auth
```
    
    Execute the command below inside your server folder (`noteapp/noteapp_server/`) to get the module and generate the necessary files.
    
    ```bash
    dart pub get
    ```
    Then...
    ```bash
    serverpod generate
    ```
-  **Client setup**

Add the modules' client as a dependency on your project's client. 
```yaml
dependencies:
  user_module_client: ^1.x.x
```
Then execute the command below.
```bash
dart pub get
```   
 
-  **Flutter app setup**
    	
Add the following packages to your project Flutter app (`noteapp/noteapp_flutter/`) as a dependency.   
```yaml  
dependencies:
  # ...
  serverpod_auth_shared_flutter: ^1.x.x
  serverpod_auth_email_flutter: ^1.x.x
  serverpod_auth_google_flutter: ^1.x.x
```


Some of the tables that will appear in your database after the preceding setup are...

![After adding auth query to database](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dgzk128fywbf0zhdz68p.png)

You can now continue to add the auth methods.

#### Email Auth

You will need a `Simple Mail Transfer Protocol` (SMTP) provider and a package that can send email from Serverpod to properly set up email sign-in in your project. 

One of the email sender packages is [mailer](https://pub.dev/packages/mailer). It's actively maintained and easy to set up. Check [this](https://suragch.medium.com/how-to-send-yourself-email-notifications-from-a-dart-server-a7c16a1900d6) tutorial on how to send email from a dart server by [Suragch](https://suragch.medium.com/?source=author_recirc-----a7c16a1900d6----0---------------------4f4d6107_0109_4fb6_b989_c8633f0fd370-------) for further information.

You can use [brevo](https://brevo.com) for the SMTP provision part.

###### Setting email auth
Considering you've set up [brevo](https://brevo.com) SMTP provider, Open `noteapp_server/lib/server.dart`, and paste the email auth configuration below...
```dart
// ... other codes above

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

        ///  The function requires that we return a bool
        /// if the email was sent or not. return `true` for demo
        return Future.value(true);
      },
    ),
  );


// ... pod start code below
```




Now, restart your server.


