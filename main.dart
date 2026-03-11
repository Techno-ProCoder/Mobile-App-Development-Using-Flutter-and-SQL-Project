// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
final Logger _logger = Logger('FormPage');
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  DateTime dob = DateTime.now();
  String gender = 'Male';

  // Text Editing Controllers
  final TextEditingController _dobController = TextEditingController();

  // Async method to submit the form
  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Backend API URL (replace with Person B's IP and port)
      var url = 'http://10.0.2.2:5000/submit'; // Replace with correct URL

      try {
        final response = await http.post(Uri.parse(url), body: {
          'name': name,
          'email': email,
          'phone': phone,
          'dob': dob.toIso8601String(),
          'gender': gender,
        });

        if (response.statusCode == 200) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Data Submitted Successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bad Request'),
            content: Text('The Request Is Malformed. Please Check The Input Data And Try Again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Unauthorized'),
            content: Text('You Are not Authorized To Access This Resource. Please Log In.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 403) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Forbidden'),
      content: Text('You Do Not Have Permission To Perform This Action.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
} else if (response.statusCode == 404) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Not Found'),
      content: Text('The Requested Resource Was Not Found On The Server. Please Try Again Later.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
} else if (response.statusCode == 500) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Server Error'),
            content: Text('An Internal Server Error Occurred. Please Try Again Later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 503) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Service Unavailable'),
      content: Text('The service Is Temporarily Unavailable. Please Try Again Later.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
} else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Failure'),
                content: const Text('Failed To Submit Data. Please Try Again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
       _logger.severe('Error: $e'); 
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Name';
                  }
                  return null;
                },
                onSaved: (value) => name = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Email Address';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please Enter A Valid Email Address';
                  }
                  return null;
                },
                onSaved: (value) => email = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Phone Number';
                  }
                  return null;
                },
                onSaved: (value) => phone = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date Of Birth'),
                controller: _dobController,
                readOnly: true,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: dob,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null && selectedDate != dob) {
                    setState(() {
                      dob = selectedDate;
                      _dobController.text = '${dob.toLocal()}'.split(' ')[0];
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    gender = newValue ?? 'Male';
                  });
                },
                onSaved: (value) => gender = value ?? 'Male',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}