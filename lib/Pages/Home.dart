import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

EdgeInsets kPadding = const EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 8.0,
);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    http.get(
      Uri.parse('https://api.twitch.tv/helix/streams?first=100'),
      headers: {
        'Authorization': 'Bearer x',
        'Client-Id': 'x',
      },
    ).then((response) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        data = List<Map<String, dynamic>>.from(json['data']);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 128.0 * 8.0),
            child: ListView(
              children: [
                SizedBox(height: kPadding.vertical * 1.0),
                Padding(
                  padding: kPadding,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chatsen',
                            style: Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Text(
                            'DISCOVERY',
                            style: TextStyle(color: Colors.grey),
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const Spacer(),
                      // IconButton(
                      //   icon: const Icon(Icons.device_unknown),
                      //   onPressed: () {},
                      //   iconSize: 20.0,
                      //   splashRadius: 20.0,
                      //   padding: const EdgeInsets.all(8.0),
                      //   color: Colors.grey,
                      //   constraints: const BoxConstraints(),
                      // ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                        iconSize: 20.0,
                        splashRadius: 20.0,
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: kPadding,
                  child: Material(
                    borderRadius: BorderRadius.circular(16.0),
                    // color: Theme.of(context).cardColor,
                    // color: Colors.red,
                    elevation: 1.0,
                    child: SizedBox(
                      height: 48.0,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // prefixIcon: ,
                                hintText: 'Search',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      for (var entry in [
                        // 'ALL',
                        // 'NSP',
                        // 'XCI',
                        // 'NRO',
                        // 'NSO',
                        // 'NCA'
                        'ALL',
                        'FOLLOWING',
                        'TRENDING'
                      ]) ...[
                        ChoiceChip(
                          label: Text(entry),
                          selected: entry == 'ALL',
                        ),
                        SizedBox(width: kPadding.horizontal / 2.0),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: kPadding,
                  child: GridView.extent(
                    childAspectRatio: 16.0 / 12.75,
                    mainAxisSpacing: kPadding.vertical,
                    crossAxisSpacing: kPadding.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    maxCrossAxisExtent: 256.0,
                    children: [
                      for (var stream in data) ...[
                        Column(
                          key: ObjectKey(stream),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              elevation: 1.0,
                              borderRadius: BorderRadius.circular(16.0),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16.0 / 9.0,
                                    child: Ink.image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        (stream['thumbnail_url'] as String).replaceAll('{width}', '1920').replaceAll('{height}', '1080'),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: kPadding / 2.0,
                                      child: Material(
                                        elevation: 1.0,
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Padding(
                                          padding: kPadding / 2.0,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Material(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(16.0),
                                                clipBehavior: Clip.antiAlias,
                                                elevation: 1.0,
                                                child: SizedBox(
                                                  width: kPadding.vertical / 2.0,
                                                  height: kPadding.vertical / 2.0,
                                                ),
                                              ),
                                              SizedBox(
                                                width: kPadding.horizontal / 8.0,
                                              ),
                                              Text('${stream['viewer_count']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: kPadding.vertical / 2.0),
                            Expanded(
                              child: Text(
                                stream['title'],
                                style: Theme.of(context).textTheme.subtitle1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stream['user_name']}',
                                // '${stream['user_name']} live playing ${stream['game_name']} for ${stream['viewer_count']} viewers',
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
