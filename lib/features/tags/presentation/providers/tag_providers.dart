import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/tags/data/models/tag_model.dart';
import 'package:noteflow/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:noteflow/features/tags/domain/repositories/tag_repository.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) => TagRepositoryImpl());
final tagListProvider = FutureProvider<List<TagModel>>((ref) => ref.watch(tagRepositoryProvider).getTags());
