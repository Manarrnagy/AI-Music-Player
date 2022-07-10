import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/layout/main_layout.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/view/player/player_page.dart';
import 'package:music_app/ui/view/playlist/playlist_page.dart';
import 'package:music_app/ui/view/profile/artists_list_item.dart';
import 'package:music_app/ui/view/profile/edit_profile/edit_profile_page.dart';
import 'package:music_app/ui/view/profile/more_artist_list/artist_list_page.dart';
import 'package:music_app/ui/view/profile/more_likes_list/likes_list_page.dart';
import 'package:music_app/ui/view/profile/new_playlist/my_playlists.dart';
import 'package:music_app/ui/view/profile/new_playlist/new_playlist_dialog.dart';

import '../../../music_app.dart';
import '../login/login_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController scrollController = ScrollController();

  double _appBarTitle = 0.0;

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    scrollController.addListener(() {
      setState(() {
        _appBarTitle = scrollController.offset;
      });
    });
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateCustomPlaylistOnSuccessState) {
          Navigator.pop(context);
          cubit.getUserPlaylists();
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: _appBarTitle > MusicApp.mediaQuery!.size.height / 4.38
              ? Text(MusicApp.userModel.name!)
              : const Text(''),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                cubit.logout().then(
                      (value) => AppComponents.navigateTo(
                        context: context,
                        newRoute: LoginPage(),
                        backRoute: false,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: const [
                    Center(
                      child: Text('Logout'),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.mainColor,
                AppColors.backgroundColor,
                AppColors.backgroundColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Center(
                  child: Hero(
                    tag: 'profilePic',
                    child: MusicApp.userModel.profileImage == ''
                        ? const Icon(
                            Icons.account_circle,
                            size: 150.0,
                            color: AppColors.whiteColor,
                          )
                        : Container(
                            width: 150.0,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              MusicApp.userModel.profileImage!,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  MusicApp.userModel.name ?? '',
                  style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppComponents.roundedOutlinedButton(
                  text: 'Edit profile',
                  onTap: () {
                    AppComponents.navigateTo(
                        context: context,
                        newRoute: EditProfilePage(),
                        backRoute: true);
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.0),
                    child: Text(
                      'Followed Artists',
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 120.0,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ArtistsListItem(
                      artistImage: cubit.followedArtists[index].artistImage!,
                      artistName: cubit.followedArtists[index].artistName!,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 5.0,
                    ),
                    itemCount: cubit.followedArtists.length > 8
                        ? 8
                        : cubit.followedArtists.length,
                  ),
                ),
                if (cubit.followedArtists.length > 8)
                  AppComponents.roundedOutlinedButton(
                    text: 'More',
                    onTap: () {
                      AppComponents.navigateTo(
                          context: context,
                          newRoute: ArtistListPage(
                              list: cubit.followedArtists,
                              listName: 'Followed Artists'),
                          backRoute: true);
                    },
                  ),
                if (cubit.followedArtists.length < 8)
                  const SizedBox(
                    height: 20.0,
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.0),
                    child: Text(
                      'Likes',
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.1,
                  child: cubit.likedSongs.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cubit.likedSongs.length > 5
                              ? 5
                              : cubit.likedSongs.length,
                          itemBuilder: (context, index) => MyListTile(
                                hasTrailingIcon: false,
                                onTap: () {
                                  cubit.openSong(
                                      songModel: cubit.likedSongs[index]);
                                  cubit.getSongRating(cubit.likedSongs[index]);
                                  cubit.getSongLikes(cubit.likedSongs[index]);
                                  AppComponents.navigateTo(
                                    context: context,
                                    newRoute: Player(
                                        songModel: cubit.likedSongs[index]),
                                    backRoute: true,
                                  );
                                },
                                title: cubit.likedSongs[index].songName ?? '',
                                subTitle: cubit.likedSongs[index].artist ?? '',
                                image: cubit.likedSongs[index].songImage ?? '',
                              ))
                      : GestureDetector(
                          onTap: () {
                            AppComponents.navigateTo(
                                context: context,
                                newRoute: const MainLayout(),
                                backRoute: false);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: AppColors.whiteColor,
                                size: MusicApp.mediaQuery!.size.width * 0.2,
                              ),
                              Text(
                                'Like songs',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize:
                                        MusicApp.mediaQuery!.size.width * 0.05),
                              ),
                            ],
                          ),
                        ),
                ),
                if (cubit.likedSongs.length > 5)
                  AppComponents.roundedOutlinedButton(
                    text: 'More',
                    onTap: () {
                      AppComponents.navigateTo(
                          context: context,
                          newRoute: LikesListPage(
                              list: cubit.likedSongs, listName: 'Likes'),
                          backRoute: true);
                    },
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0),
                    child: Row(
                      children: [
                        const Text(
                          'My Playlists',
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (cubit.usersPlaylists.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              cubit.getAllSongs();
                              showNewPlaylistDialog(context: context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.whiteColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'New Playlist',
                                    style:
                                        TextStyle(color: AppColors.whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  child: cubit.usersPlaylists.isNotEmpty
                      ? MyListTile(
                          hasTrailingIcon: false,
                          onTap: () {
                            cubit.getPlaylistSongs(
                                cubit.usersPlaylists[0]['playListID']);
                            AppComponents.navigateTo(
                                context: context,
                                newRoute: CustomPlaylist(
                                  playListCardColor: Colors.purpleAccent,
                                  playListName: cubit.usersPlaylists[0]
                                      ['playListName'],
                                  playListID: cubit.usersPlaylists[0]
                                      ['playListID'],
                                ),
                                backRoute: true);
                          },
                          title: cubit.usersPlaylists[0]['playListName'],
                          subTitle: 'Playlist • ${MusicApp.userModel.name}',
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/musimood-dba21.appspot.com/o/music-tape-cassette-tape.png?alt=media&token=551f7a1f-75de-4769-8d2d-65721231fe3a',
                        )
                      : GestureDetector(
                          onTap: () {
                            showNewPlaylistDialog(context: context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.queue_music,
                                color: AppColors.whiteColor,
                                size: MusicApp.mediaQuery!.size.width * 0.2,
                              ),
                              Text(
                                'Tap here to create a playlist',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize:
                                        MusicApp.mediaQuery!.size.width * 0.05),
                              ),
                            ],
                          ),
                        ),
                ),
                if (cubit.usersPlaylists.length > 1)
                  AppComponents.roundedOutlinedButton(
                    text: 'More',
                    onTap: () {
                      AppComponents.navigateTo(
                          context: context,
                          newRoute: MyPlaylists(
                              list: cubit.usersPlaylists,
                              listName: 'My PlayLists'),
                          backRoute: true);
                    },
                  ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
