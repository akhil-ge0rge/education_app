import 'package:education_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const routeName = '/dashboard';
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text(
          'Dash Board',
          style:
              context.theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
