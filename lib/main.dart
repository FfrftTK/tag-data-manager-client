import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:reactive_forms/reactive_forms.dart';
import 'package:tag_data_manager_client/utils/network/app_dio_client.dart';

import 'entities/entities.dart';
import 'services/services.dart';

void main() {
  runApp(MyApp());
}

final dioClient = AppDioClient('http://192.168.68.106:8080');
final tagService = TagService(dioClient: dioClient);
final userService = UserService(dioClient: dioClient);
final dateFormatter = DateFormat('yyyy/MM/dd HH:mm');

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFID Tag Data Manager'),
      ),
      body: ListView.builder(
        itemCount: user.tags.length,
        itemBuilder: (_, idx) {
          final tag = user.tags[idx];
          return Card(
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('ID: ${tag.code}'),
              subtitle: Text(tag.description),
              trailing:
                  Text(dateFormatter.format(DateTime.parse(tag.createdAt))),
            ),
          );
        },
      ),
    );
  }
}

FormGroup buildForm() => fb.group({
      'username': FormControl<String>(
        validators: [Validators.required],
      ),
      'password': [Validators.required],
    });

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Padding(
            padding: EdgeInsets.all(Get.width * 0.05),
            child: ListView(
              children: [
                ReactiveTextField(
                  formControlName: 'username',
                  validationMessages: (control) => {
                    ValidationMessage.required:
                        'The username must not be empty',
//                  'unique': 'This username is already in use',
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                  ),
                ),
                SizedBox(height: Get.height * 0.005),
                ReactiveTextField(
                  formControlName: 'password',
                  obscureText: true,
                  validationMessages: (control) => {
                    ValidationMessage.required:
                        'The password must not be empty',
//                  ValidationMessage.minLength:
//                      'The password must be at least 8 characters',
                  },
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                  ),
                ),
                SizedBox(height: Get.height * 0.005),
                RaisedButton(
                  child: const Text('Sign In'),
                  onPressed: () async {
                    if (form.valid) {
                      attemptSignIn(form.value);
                      print(form.value);
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                ),
                RaisedButton(
                  child: const Text('Sign Up'),
                  onPressed: () async {
                    if (form.valid) {
                      final result = await userService.registerUser(
                        user: User(name: form.value['username']),
                        password: form.value['password'],
                      );

                      result.when(
                        success: (_) => attemptSignIn(form.value),
                        failure: print,
                      );
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> attemptSignIn(Map<String, dynamic> formValue) async {
    final username = formValue['username'];

    final result = await userService.login(
      username: username,
      password: formValue['password'],
    );

    result.when(
      success: (_) async {
        final user = await userService.findUserByName(name: username);
        user.when(success: (user) => Get.to(UserPage(user)), failure: print);
      },
      failure: print,
    );
  }
}
