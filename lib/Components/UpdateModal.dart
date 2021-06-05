import 'dart:convert';
import 'dart:io';

import 'package:chatsen/Consts.dart';
import 'package:dart_downloader/DownloadManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';

class GithubRelease {
  final String repositoryPath;
  Version? version;

  String get downloads => 'https://github.com/$repositoryPath/releases/download/$version';

  GithubRelease({
    required this.repositoryPath,
    String? versionName,
  }) {
    version = Version.parse(versionName);
  }
}

class GithubReleaseProvider {
  final String repositoryPath;

  const GithubReleaseProvider(this.repositoryPath);

  Future<List<GithubRelease>> getReleases() async {
    var response = await http.get(Uri.parse('https://api.github.com/repos/$repositoryPath/tags'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    var result = <GithubRelease>[];

    for (var tagData in jsonResponse) {
      try {
        result.add(
          GithubRelease(
            repositoryPath: repositoryPath,
            versionName: tagData['name'],
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    return result;
  }
}

class UpdateModal extends StatelessWidget {
  final Version currentVersion;
  final GithubRelease latestRelease;

  static Future<bool> hasUpdate() async {
    if (kPlayStoreRelease) return false;
    var releases = await GithubReleaseProvider('chatsen/chatsen').getReleases();
    releases.sort((a1, a2) => a1.version!.compareTo(a2.version));
    var packageInfo = await PackageInfo.fromPlatform();
    var currentReleaseVersion = Version.parse('${packageInfo.version}+${packageInfo.buildNumber}');
    var lastRelease = releases.last;
    return currentReleaseVersion < lastRelease.version;
  }

  static void searchForUpdate(BuildContext context) async {
    if (kPlayStoreRelease) return;

    var releases = await GithubReleaseProvider('chatsen/chatsen').getReleases();
    releases.sort((a1, a2) => a1.version!.compareTo(a2.version));

    var packageInfo = await PackageInfo.fromPlatform();
    var currentReleaseVersion = Version.parse('${packageInfo.version}+${packageInfo.buildNumber}');
    var lastRelease = releases.last;

    if (currentReleaseVersion < lastRelease.version) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: UpdateModal(
              currentVersion: currentReleaseVersion,
              latestRelease: lastRelease,
            ),
          ),
        ),
      );
    }
  }

  const UpdateModal({
    Key? key,
    required this.currentVersion,
    required this.latestRelease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<DownloadManager, DownloadManagerState>(
        builder: (context, state) => WidgetBlur(
          child: Material(
            color: Theme.of(context).canvasColor.withAlpha(196),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 1.0, color: Theme.of(context).dividerColor),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 32.0, height: 2.0, color: Theme.of(context).dividerColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var download in state.downloads)
                        BlocBuilder<Download, DownloadState>(
                          buildWhen: (state1, state2) => true,
                          bloc: download,
                          builder: (context, state) => InkWell(
                            onTap: () async {
                              if (state is DownloadCompleted) await OpenFile.open(state.file!.path);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${state is DownloadCompleted ? 'Downloaded' : 'Downloading'} update ${latestRelease.version}'),
                                    SizedBox(height: 8.0),
                                    if (state is DownloadContentState)
                                      LinearProgressIndicator(
                                        value: state.curBytes / state.maxBytes,
                                      ),
                                    if (state is DownloadCompleted) ...[
                                      SizedBox(height: 8.0),
                                      Text('Tap here to install update'),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (state.downloads.isEmpty) ...[
                        Text('An update is available', style: Theme.of(context).textTheme.subtitle1),
                        Text('$currentVersion -> ${latestRelease.version}', style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              // TODO: Check Android version and open link in browser for API <= 19: (await DeviceInfoPlugin().androidInfo).version.sdkInt
                              onPressed: () async => BlocProvider.of<DownloadManager>(context).add(
                                DownloadManagerAdd(
                                  url: '${latestRelease.downloads}/${Platform.isAndroid ? 'Android.apk' : 'iOS.ipa'}',
                                  file: File('${(await getApplicationDocumentsDirectory()).path}/${Platform.isAndroid ? 'Android.apk' : 'iOS.ipa'}'),
                                ),
                              ),
                              label: Text('Update now'),
                              icon: Icon(Icons.system_update),
                            ),
                            SizedBox(width: 8.0),
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(height: 1.0, color: Theme.of(context).dividerColor),
              ],
            ),
          ),
        ),
      );
}


                            // if (Platform.isAndroid)
                            //   TextButton.icon(
                            //     onPressed: () async {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         SnackBar(
                            //           content: Text('The update is being downloaded in the background, it may take a while...'),
                            //           behavior: SnackBarBehavior.floating,
                            //         ),
                            //       );

                            //       Navigator.of(context).pop();

                            //       try {
                            //         var url = '${latestRelease.downloads}/Android.apk';
                            //         var bytes = (await http.get(Uri.parse(url))).bodyBytes;

                            //         var savePath = (await getApplicationDocumentsDirectory()).path;
                            //         var fileName = url.split('/').last;
                            //         await File('$savePath/$fileName').writeAsBytes(bytes, flush: true);
                            //         await OpenFile.open('$savePath/$fileName');
                            //       } catch (e) {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(
                            //             content: Text('An error has occured while downloading the update: $e'),
                            //             behavior: SnackBarBehavior.floating,
                            //           ),
                            //         );
                            //       }
                            //     },
                            //     label: Text('4.1 Test'),
                            //     icon: Icon(Icons.add_shopping_cart_outlined),
                            //   ),
