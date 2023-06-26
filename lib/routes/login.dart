import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniclip_mobile/resource.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      print(account?.email);
      print(account?.id);
      print(account?.displayName);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    });

    _googleSignIn.signInSilently();

    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("ERRROOOOOOOOR");
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login godul'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: (Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Name',
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (Set<MaterialState> states) {
                    final Color color = states.contains(MaterialState.error)
                        ? Theme.of(context).colorScheme.error
                        : Colors.purple;
                    return TextStyle(color: color, letterSpacing: 1.3);
                  },
                ),
              ),
              validator: (String? value) {
                if (value == null || value == '') {
                  return 'Enter name';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',

                // The MaterialStateProperty's value is a text style that is orange
                // by default, but the theme's error color if the input decorator
                // is in its error state.
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (Set<MaterialState> states) {
                    final Color color = states.contains(MaterialState.error)
                        ? Theme.of(context).colorScheme.error
                        : Colors.purple;
                    return TextStyle(color: color, letterSpacing: 1.3);
                  },
                ),
              ),
              validator: (String? value) {
                if (value == null || value == '') {
                  return 'Enter password';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  try {
                    var data = await login(
                        nameController.text, passwordController.text);
                    await _storage.write(key: 'token', value: data.token);
                    Navigator.pushNamed(context, '/');
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: const Text('Error from backend'),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form is invalid')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            TextButton(
                onPressed: () async {
                  await _handleSignIn();
                },
                child: const Text('Login with google'))
          ]),
        )),
      ),
    );
  }
}
