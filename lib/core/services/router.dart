import 'package:education_app/core/common/view/page_under_construction_screen.dart';
import 'package:education_app/core/extension/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/view/sign_in_screen.dart';
import 'package:education_app/src/auth/presentation/view/sign_up_screen.dart';
import 'package:education_app/src/dashboard/presentation/view/dashboard.dart';
import 'package:education_app/src/onboarding/data/datasources/onboarding_local_datasources.dart';
import 'package:education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
