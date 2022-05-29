import 'dart:io';

import 'package:fl_bloc_list/core/bloc/post_bloc.dart';
import 'package:fl_bloc_list/core/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(
        client: HttpClient(),
      )..add(const PostFetch()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrool);
  }

  _onScrool() {
    if (_isBottom) context.read<PostBloc>().add(const PostFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..dispose()
      ..removeListener(_onScrool);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            switch (state.status) {
              case PostStatus.failure:
                return Center(
                  child: Text(
                    'Hata',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              case PostStatus.success:
                if (state.posts.isEmpty) {
                  return Center(
                    child: Text(
                      'Post Bulunamadı...',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return index >= state.posts.length
                        ? const IndicatorWidget()
                        : ListPostItem(post: state.posts[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  controller: _scrollController,
                );
              default:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Lütfen bekleyiniz...'),
                      CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    ],
                  ),
                );
            }
          },
        ));
  }
}

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          )),
    );
  }
}

class ListPostItem extends StatelessWidget {
  const ListPostItem({Key? key, required this.post}) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          '${post.id}',
          style: Theme.of(context).textTheme.caption,
        ),
        isThreeLine: true,
        title: Text(post.title),
        subtitle: Text(post.body),
      ),
    );
  }
}
