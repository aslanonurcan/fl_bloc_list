part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  final List<Post> posts;
  final bool hasReachedMax;
  final PostStatus status;

  const PostState(
      {this.posts = const <Post>[],
      this.hasReachedMax = false,
      this.status = PostStatus.initial});

  @override
  List<Object> get props => [posts, hasReachedMax, status];

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PostInitial extends PostState {}
