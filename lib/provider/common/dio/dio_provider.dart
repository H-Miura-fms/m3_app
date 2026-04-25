import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/dio/custom_dio.dart';

final dioProvider = Provider<Dio>((ref) => MyDio());
