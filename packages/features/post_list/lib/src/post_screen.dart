import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';

import 'get_post_cubit.dart';
import 'get_post_state.dart';

typedef OnCreatePostScreenNavigated = Future<PostScreenStatus> Function();

enum PostScreenStatus {
  normal,
  postCreated,
}

class PostScreen extends StatefulWidget {
  static const routName = 'PostScreenRoute';
  final OnCreatePostScreenNavigated onCreatePostScreenNavigated;
  final PostScreenStatus status;

  const PostScreen({
    Key? key,
    required this.onCreatePostScreenNavigated,
    this.status = PostScreenStatus.normal,
  }) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.status == PostScreenStatus.postCreated) {
      BlocProvider.of<GetPostCubit>(context).getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPostCubit(
          postRepository: RepositoryProvider.of<PostRepository>(context))
        ..getPosts(),
      child: PostScreenBody(
        onCreatePostScreenNavigated: widget.onCreatePostScreenNavigated,
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPostCubit, GetPostState>(
      builder: (context, state) {
        if (state is GetPostLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetPostSuccess) {
          final posts = state.posts;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostItem(post: post);
              },
            ),
          );
        } else if (state is GetPostFail) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return Container();
      },
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200.0,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                post.imgUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostScreenBody extends StatelessWidget {
  const PostScreenBody({
    Key? key,
    required this.onCreatePostScreenNavigated,
  }) : super(key: key);

  final OnCreatePostScreenNavigated onCreatePostScreenNavigated;

  @override
  Widget build(BuildContext context) {
    GetPostCubit cubit = BlocProvider.of<GetPostCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            onPressed: () async {
              final PostScreenStatus result =
                  await onCreatePostScreenNavigated();
              if (result == PostScreenStatus.postCreated) {
                print('hehehehehe');
                cubit.getPosts();
              }
              if (result == PostScreenStatus.normal) {
                print('huhuhuhuhu');
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: PostList(),
          ),
        ],
      ),
    );
  }
}
