/// {@template api_repository}
/// A fake API repository.
/// {@endtemplate}
class ApiRepository {
  /// {@macro api_repository}
  const ApiRepository();

  /// Fetches todos.
  List<String> fetchTodos() => [
    'Make homework',
    'Go to shop',
    'Cook the dinner',
  ];
}
