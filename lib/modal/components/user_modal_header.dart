import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatsen/modal/components/modal_header.dart';
import 'package:flutter/material.dart';

import '../../api/chatsen/chatsen_user.dart';

class UserModalHeader extends StatelessWidget {
  final ChatsenUser user;

  const UserModalHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: CachedNetworkImageProvider(user.bannerImageURL ?? user.offlineImageURL ?? user.profileImageURL),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).colorScheme.background.withOpacity(0.75),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(8.0),
                          clipBehavior: Clip.antiAlias,
                          elevation: 8.0,
                          child: Ink.image(
                            image: CachedNetworkImageProvider(user.profileImageURL),
                            width: 64.0,
                            height: 64.0,
                            child: InkWell(
                              onTap: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SelectableText.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: user.displayName, style: Theme.of(context).textTheme.titleLarge),
                              TextSpan(text: '#${user.id}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75))),
                            ],
                          ),
                        ),
                        SelectableText.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people_alt, color: Theme.of(context).textTheme.bodyMedium!.color, size: Theme.of(context).textTheme.bodyMedium!.fontSize),
                                    Text(' ${user.followers.totalCount}', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              const WidgetSpan(child: SizedBox(width: 16.0)),
                              WidgetSpan(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.remove_red_eye, color: Theme.of(context).textTheme.bodyMedium!.color, size: Theme.of(context).textTheme.bodyMedium!.fontSize),
                                    Text(' ${user.profileViewCount}', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const ModalHeader(),
            ],
          ),
          if (user.stream != null)
            Stack(
              children: [
                Positioned.fill(
                  child: Ink.image(
                    image: CachedNetworkImageProvider(user.stream!.previewImageURL.replaceAll('{width}', '1920').replaceAll('{height}', '1080')),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(child: Container(color: Theme.of(context).colorScheme.background.withOpacity(0.75))),
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(8.0),
                            clipBehavior: Clip.antiAlias,
                            elevation: 8.0,
                            child: Ink.image(
                              image: CachedNetworkImageProvider(user.stream!.game.avatarURL),
                              fit: BoxFit.cover,
                              width: 64.0,
                              height: 64.0,
                              child: InkWell(
                                onTap: () {},
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: SelectableText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: '${user.broadcastSettings.title}\n', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  TextSpan(text: '${user.stream!.game.name}\n', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).textTheme.titleMedium!.color!.withOpacity(0.75))),
                                  WidgetSpan(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.timelapse, color: Theme.of(context).textTheme.bodyMedium!.color, size: Theme.of(context).textTheme.bodyMedium!.fontSize),
                                        Text(' ${DateTime.now().difference(user.stream!.createdAt)}'.split('.').first, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 16.0)),
                                  WidgetSpan(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.remove_red_eye, color: Theme.of(context).textTheme.bodyMedium!.color, size: Theme.of(context).textTheme.bodyMedium!.fontSize),
                                        Text(' ${user.stream!.viewersCount}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
}
