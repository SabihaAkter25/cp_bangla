part of 'app_pages.dart';

abstract class Routes {
  static const DASHBOARD = _Paths.DASHBOARD;
  static const AUTH = _Paths.AUTH;
  static const ARTICLES = _Paths.ARTICLES;
  static const ARTICLE_DETAILS = _Paths.ARTICLE_DETAILS;
  static const PROBLEMS = _Paths.PROBLEMS;
  static const TOPICS = _Paths.TOPICS;
  static const ADMIN = _Paths.ADMIN;
  static const MANAGE_ARTICLES = _Paths.MANAGE_ARTICLES;
  static const MANAGE_PROBLEMS = _Paths.MANAGE_PROBLEMS;
  static const MANAGE_TOPICS = _Paths.MANAGE_TOPICS;
}

abstract class _Paths {
  static const DASHBOARD = '/dashboard';
  static const AUTH = '/auth';
  static const ARTICLES = '/articles';
  static const ARTICLE_DETAILS = '/articles/details';
  static const PROBLEMS = '/problems';
  static const TOPICS = '/topics';
  static const ADMIN = '/admin';
  static const MANAGE_ARTICLES = '/admin/articles';
  static const MANAGE_PROBLEMS = '/admin/problems';
  static const MANAGE_TOPICS = '/admin/topics';
}
