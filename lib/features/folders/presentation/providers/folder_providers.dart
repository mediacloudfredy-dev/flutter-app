import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/folders/data/models/folder_model.dart';
import 'package:noteflow/features/folders/data/repositories/folder_repository_impl.dart';
import 'package:noteflow/features/folders/domain/repositories/folder_repository.dart';

final folderRepositoryProvider = Provider<FolderRepository>((ref) => FolderRepositoryImpl());
final folderListProvider = FutureProvider<List<FolderModel>>((ref) => ref.watch(folderRepositoryProvider).getFolders());
