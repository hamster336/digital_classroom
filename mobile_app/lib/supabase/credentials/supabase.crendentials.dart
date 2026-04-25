// ignore_for_file: constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials {
  static const String APIKEY =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzZWJhdXhxcHJwc3Rkdm13d3NlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5Njc3MDIsImV4cCI6MjA4MzU0MzcwMn0.ze_g3A3NdAVGp56q_dU75mo7o921HgwCTTdNp6K6FFY';
  static const String APIURL = 'https://ksebauxqprpstdvmwwse.supabase.co';

  static SupabaseClient get client => Supabase.instance.client;
}
