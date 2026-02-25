import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson should return expected UserModel', () {
      // Arrange
      final json = {'id': 1, 'name': 'Vinicios', 'email': 'vinicios@email.com'};

      final expectedUser = UserModel(
        id: 1,
        name: 'Vinicios',
        email: 'vinicios@email.com',
      );

      // Act
      final result = UserModel.fromJson(json);

      // Assert
      expect(result, equals(expectedUser));
    });
    test('fromJson should return valid model when json is correct', () {
      // Arrange
      final json = {'id': 1, 'name': 'Vinicios', 'email': 'vinicios@email.com'};

      // Act
      final result = UserModel.fromJson(json);

      // Assert
      expect(result.id, 1);
      expect(result.name, 'Vinicios');
      expect(result.email, 'vinicios@email.com');
    });

    test('fromJson should allow null id', () {
      // Arrange
      final json = {'name': 'Vinicios', 'email': 'vinicios@email.com'};

      // Act
      final result = UserModel.fromJson(json);

      // Assert
      expect(result.id, null);
      expect(result.name, 'Vinicios');
      expect(result.email, 'vinicios@email.com');
    });

    test('toJson should return correct map without id', () {
      // Arrange
      final user = UserModel(
        id: 1,
        name: 'Vinicios',
        email: 'vinicios@email.com',
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json, {'name': 'Vinicios', 'email': 'vinicios@email.com'});
    });
  });
}
