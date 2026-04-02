class CharacterState {
  final bool isTalking;
  final String quote;

  const CharacterState({this.isTalking = false, this.quote = ''});

  static const idle = CharacterState();
}
