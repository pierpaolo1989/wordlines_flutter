import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldlines_mobile/home/home_page.dart';
import 'package:worldlines_mobile/login/auth_provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return const HomePage();
      },
    );
  }
}
