import 'package:equatable/equatable.dart';

class BlockedTerm extends Equatable {
  final String pattern;
  final bool regex;
  final bool caseSensitive;

  BlockedTerm({
    required this.pattern,
    required this.regex,
    required this.caseSensitive,
  });

  BlockedTerm copyWith({
    String? pattern,
    bool? regex,
    bool? caseSensitive,
  }) =>
      BlockedTerm(
        pattern: pattern ?? this.pattern,
        regex: regex ?? this.regex,
        caseSensitive: caseSensitive ?? this.caseSensitive,
      );

  @override
  List<Object?> get props => [pattern, regex, caseSensitive];
}
