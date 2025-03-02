import 'package:chatsen/modal/components/modal_header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chatsen/l10n/app_localizations.dart';

import '../components/tile.dart';

class CreditedPerson {
  final String url;
  final String name;
  final String description;
  final String avatarUrl;

  const CreditedPerson({
    required this.url,
    required this.name,
    required this.description,
    required this.avatarUrl,
  });
}

List<CreditedPerson> credits = const [
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097853110543716422/Wk0hfra.jpg',
    description: 'Logo designer',
    name: 'ayyybubu',
    url: 'https://twitch.tv/ayyybubu',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097853110543716422/Wk0hfra.jpg',
    description: 'Vietnamese translation',
    name: '21mtd',
    url: 'https://twitch.tv/21mtd',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097854071873998868/image.png',
    description: 'Korean translation',
    name: 'badpixel134',
    url: 'https://twitch.tv/badpixel134',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097864604983500820/IMG_0827.jpg',
    description: 'Russian translation',
    name: 'copperrum',
    url: 'https://twitch.tv/copperrum',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097872548542283836/IMG_2004.jpg',
    description: 'German translation',
    name: 'LosFarmosCTL',
    url: 'https://twitch.tv/losfarmosctl',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097872819020369940/pfp.png',
    description: 'Greek translation',
    name: 'rix',
    url: 'https://twitch.tv/rix_ow',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097889786712313926/5DE7BB29-22F9-4B02-8069-872B5F1F8008.jpg',
    description: 'Hindi translation',
    name: 'captkayy',
    url: 'https://twitch.tv/captkayy',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097894994506961016/SupCut.png',
    description: 'Spanish translation',
    name: 'supdos',
    url: 'https://twitch.tv/supdos',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097925179029585970/ImageGlass_6wULGSK0yA.png',
    description: 'Brazilian Portugese translation',
    name: 'Boleto',
    url: 'https://twitch.tv/boletodosub',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1097936569781993622/roko.jpg',
    description: 'Italian translation',
    name: 'Symphonystars',
    url: 'https://twitch.tv/symphonystars',
  ),
  CreditedPerson(
    avatarUrl: 'https://cdn.discordapp.com/attachments/1097848618091806730/1100949775710425088/B2E92DCA-B52C-4CBF-9365-A8E5AD35BB77.jpg',
    description: 'Canadian English translation',
    name: 'oakley',
    url: 'https://twitch.tv/oakleydog13',
  ),
];

class CreditsModal extends StatelessWidget {
  const CreditsModal({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          ModalHeader(title: AppLocalizations.of(context)!.credits),
          // Tile(
          //   title: 'Midori',
          //   subtitle: 'French translation',
          //   prefix: CircleAvatar(
          //     backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/25180625?v=4'),
          //   ),
          //   onTap: () => launchUrl(Uri.parse('https://google.com'), mode: LaunchMode.externalApplication),
          // ),
          for (final credit in credits)
            Tile(
              title: credit.name,
              subtitle: credit.description,
              prefix: CircleAvatar(
                backgroundImage: NetworkImage(credit.avatarUrl),
              ),
              onTap: () => launchUrl(Uri.parse(credit.url), mode: LaunchMode.externalApplication),
            ),
        ],
      );
}
