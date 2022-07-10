import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/my_list_tile.dart';

import '../../../../control/cubit/cubit.dart';

class AddCustomPlayListSongs extends StatefulWidget {
  const AddCustomPlayListSongs({
    Key? key,
    required this.list,
    required this.playlistID,
  }) : super(key: key);
  final List<SongModel> list;
  final String playlistID;

  @override
  State<AddCustomPlayListSongs> createState() => _AddCustomPlayListSongsState();
}

class _AddCustomPlayListSongsState extends State<AddCustomPlayListSongs> {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (BuildContext context, Object? state) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          elevation: 0.0,
          title: const Text('Add Songs'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(MusicApp.mediaQuery!.size.width * 0.03),
          decoration: BoxDecoration(
            color: AppColors.blackColor2,
            borderRadius: BorderRadius.all(
              Radius.circular(MusicApp.mediaQuery!.size.width * 0.03),
            ),
          ),
          child: widget.list.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) => MyListTile(
                      trailingIcon: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: MusicApp.mediaQuery!.size.width * 0.06,
                          color: AppColors.whiteColor,
                        ),
                        onPressed: () {
                          if (kDebugMode) {
                            print(widget.list[index].songID);
                            print(widget.playlistID);
                          }

                          cubit.addSongsToPlayList(
                              widget.list[index], widget.playlistID);

                          setState(() {
                            widget.list.removeAt(index);
                          });
                        },
                      ),
                      hasTrailingIcon: true,
                      title: widget.list[index].songName ?? '',
                      subTitle: widget.list[index].artist ?? '',
                      image: widget.list[index].songImage ?? ''),
                  itemCount: widget.list.length,
                  padding: const EdgeInsets.all(10.0),
                )
              : Center(
                  child: Text(
                  'More songs coming soon',
                  style: TextStyle(
                      fontSize: MusicApp.mediaQuery!.size.width * 0.05,
                      color: AppColors.whiteColor),
                )),
        ),
      ),
    );
  }
}
