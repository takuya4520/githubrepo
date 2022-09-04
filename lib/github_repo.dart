class GitHubRepository {
  GitHubRepository({
    required this.fullName,
    required this.description,
    required this.language,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
  });

  var fullName;
  var description;
  var language;
  var htmlUrl;
  var stargazersCount;
  var watchersCount;
  var forksCount;

  factory GitHubRepository.fromMap(Map<String, dynamic> map) {
    return GitHubRepository(
      fullName: map['full_name'],
      description: map['description'],
      language: map['language'],
      htmlUrl: map['html_url'],
      stargazersCount: map['stargazers_count'],
      watchersCount: map['watchers_count'],
      forksCount: map['forks_count'],
    );
  }
}
