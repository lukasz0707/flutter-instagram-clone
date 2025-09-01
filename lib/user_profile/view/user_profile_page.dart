import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/selector/selector.dart';
import 'package:flutter_instagram_clone/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserProfileBloc(
              userId: userId,
              postsRepository: context.read<PostsRepository>(),
              userRepository: context.read<UserRepository>(),
            )
            ..add(const UserProfileSubscriptionRequested())
            ..add(const UserProfilePostsCountSubscriptionRequested())
            ..add(const UserProfileFollowingsCountSubscriptionRequested())
            ..add(const UserProfileFollowersCountSubscriptionRequested()),
      child: UserProfileView(
        userId: userId,
      ),
    );
  }
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});

  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late ScrollController _nestedScrollController;

  @override
  void initState() {
    _nestedScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _nestedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);

    // TODO(lukasz): dodane na szybko circularProgress bo wyświetlało się uknkown przez chwile na początku
    // Check if the user data is in the initial state
    final userState = context.select((UserProfileBloc bloc) => bloc.state);
    if (userState.status == UserProfileStatus.initial ||
        userState.status == UserProfileStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _nestedScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: MultiSliver(
                  children: [
                    const UserProfileAppBar(),
                    if (!user.isAnonymous) ...[
                      UserProfileHeader(
                        userId: widget.userId,
                      ),
                      SliverPersistentHeader(
                        pinned: !ModalRoute.of(context)!.isFirst,
                        delegate: _SliverAppBarDelegate(
                          const TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            indicatorWeight: 1,
                            tabs: [
                              Tab(
                                icon: Icon(Icons.grid_on),
                                iconMargin: EdgeInsets.zero,
                              ),
                              Tab(
                                icon: Icon(Icons.person_outline),
                                iconMargin: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              UserPostsPage(),
              UserProfileMentionedPostsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserPostsPage extends StatelessWidget {
  const UserPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UserProfileMentionedPostsPage extends StatelessWidget {
  const UserProfileMentionedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);
    final isOwner = context.select((UserProfileBloc bloc) => bloc.isOwner);

    return SliverPadding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      sliver: SliverAppBar(
        centerTitle: false,
        pinned: !ModalRoute.of(context)!.isFirst,
        floating: ModalRoute.of(context)!.isFirst,
        title: Row(
          children: [
            Flexible(
              flex: 12,
              child: Text(
                user.displayUsername,
                style: context.titleLarge?.copyWith(
                  fontWeight: AppFontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Assets.icons.verifiedUser.svg(
                width: AppSize.iconSizeSmall,
                height: AppSize.iconSizeSmall,
              ),
            ),
          ],
        ),
        actions: [
          if (!isOwner)
            const UserProfileActions()
          else ...[
            const UserProfileAddMediaButton(),
            if (ModalRoute.of(context)?.isFirst ?? false) ...const [
              Gap.h(AppSpacing.md),
              UserProfileSettingsButton(),
            ],
          ],
        ],
      ),
    );
  }
}

class UserProfileActions extends StatelessWidget {
  const UserProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {},
      child: Icon(Icons.adaptive.more_outlined, size: AppSize.iconSize),
    );
  }
}

class UserProfileSettingsButton extends StatelessWidget {
  const UserProfileSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () => context
          .showListOptionsModal(
            options: [
              ModalOption(child: const LocaleModalOption()),
              ModalOption(child: const ThemeSelectorModalOption()),
              ModalOption(child: const LogoutModalOption()),
            ],
          )
          .then((option) {
            if (option == null) return;
            void onTap() => option.onTap(context);
            onTap.call();
          }),
      child: Assets.icons.setting.svg(
        height: AppSize.iconSize,
        width: AppSize.iconSize,
        colorFilter: ColorFilter.mode(
          context.adaptiveColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class LogoutModalOption extends StatelessWidget {
  const LogoutModalOption({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Tappable.faded(
      onTap: () => context.confirmAction(
        fn: () {
          context.pop();
          context.read<AppBloc>().add(const AppLogoutRequested());
        },
        title: l10n.logOutText,
        content: l10n.logOutConfirmationText,
        noText: l10n.cancelText,
        yesText: l10n.logOutText,
      ),
      child: ListTile(
        title: Text(
          l10n.logOutText,
          style: context.bodyLarge?.apply(color: AppColors.red),
        ),
        leading: const Icon(Icons.logout, color: AppColors.red),
      ),
    );
  }
}

class UserProfileAddMediaButton extends StatelessWidget {
  const UserProfileAddMediaButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // final user = context.select((AppBloc bloc) => bloc.state.user);
    return Tappable.faded(
      onTap: () => context
          .showListOptionsModal(
            title: l10n.createText,
            options: createMediaModalOptions(
              context: context,
              reelLabel: l10n.reelText,
              postLabel: l10n.postText,
              storyLabel: l10n.storyText,
              enableStory: true,
              goTo: (route, {extra}) => context.pushNamed(route, extra: extra),

              // onStoryCreated: (path) {
              //   context.read<CreateStoriesBloc>().add(
              //     CreateStoriesStoryCreateRequested(
              //       author: user,
              //       contentType: StoryContentType.image,
              //       filePath: path,
              //       onError: (_, __) {
              //         toggleLoadingIndeterminate(enable: false);
              //         openSnackbar(
              //           SnackbarMessage.error(
              //             title: l10n.somethingWentWrongText,
              //             description: l10n.failedToCreateStoryText,
              //           ),
              //         );
              //       },
              //       onLoading: toggleLoadingIndeterminate,
              //       onStoryCreated: () {
              //         toggleLoadingIndeterminate(enable: false);
              //         openSnackbar(
              //           SnackbarMessage.success(
              //             title: l10n.successfullyCreatedStoryText,
              //           ),
              //           clearIfQueue: true,
              //         );
              //       },
              //     ),
              //   );
              //   context.pop();
              // },
            ),
          )
          .then((option) {
            if (option == null) return;
            void onTap() => option.onTap(context);
            onTap.call();
          }),
      child: const Icon(
        Icons.add_box_outlined,
        size: AppSize.iconSize,
      ),
    );
  }
}
