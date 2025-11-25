import 'package:confetti_app/core/network/dio_client.dart';
import 'package:confetti_app/features/auth/data/models/user_model.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/users_response_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    final result = await client.get(
      '${ApiConfig.baseUrl}/api/users',
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2N2I5MDk3MDJlMGVmOGI0ZWQ3YzhjMTciLCJyb2xlIjoiU1VQRVJfUk9MRSIsInByb2ZpbGUiOiI2N2I5MDZhYWFkZjhkMTAwYmRiMzlmMTciLCJpYXQiOjE3NjQxMDk0ODIsImV4cCI6MTc2NDExNjY4Mn0.Ffj6Ggbkq6oSbuVKBblKKqQULR7NgcInVCCG-eq7toc',
      },
    );

    return result.fold(
      (failure) {
        AppLogger.error('Failed to fetch users: ${failure.message}');
        throw Exception(failure.message);
      },
      (data) {
        final apiResponse = GetUsersResponse.fromJson(data);
        AppLogger.info(
          'UserRemoteDataSource: Successfully fetched users. Response: $apiResponse',
        );
        final users =
            apiResponse.data?.map((user) {
              final userJson = user.toJson();

              return UserModel(
                id: userJson["_id"],
                name: userJson["name"],
                email: userJson["email"],
                image: userJson["image"],
                imagePublicId: userJson["imagePublicId"],
                status: userJson["status"],
                deleted: userJson["deleted"],
                google: userJson["google"],
                createdAt: DateTime.parse(userJson["createdAt"]),
                updatedAt: DateTime.parse(userJson["updatedAt"]),
              );
            }).toList();

        return users ?? [];
      },
    );
  }
}
