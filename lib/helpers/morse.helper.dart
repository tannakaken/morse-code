enum MorseAtom {
  dah('−'),
  dit('·'),
  ;

  const MorseAtom(this.display);

  final String display;
}

typedef MorseCharacter = List<MorseAtom>;

const Map<String, MorseCharacter> morseDictionary = {
  "a": [MorseAtom.dah, MorseAtom.dit],
  "b": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dit, MorseAtom.dit],
  "c": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dah, MorseAtom.dit],
  "d": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dit],
  "e": [MorseAtom.dit],
  "f": [MorseAtom.dit, MorseAtom.dit, MorseAtom.dah, MorseAtom.dit],
  "g": [MorseAtom.dah, MorseAtom.dah, MorseAtom.dit],
  "h": [MorseAtom.dit, MorseAtom.dit, MorseAtom.dit, MorseAtom.dit],
  "i": [MorseAtom.dit, MorseAtom.dit],
  "j": [MorseAtom.dit, MorseAtom.dah, MorseAtom.dah, MorseAtom.dah],
  "k": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dah],
  "l": [MorseAtom.dit, MorseAtom.dah, MorseAtom.dit, MorseAtom.dit],
  "m": [MorseAtom.dah, MorseAtom.dah],
  "n": [MorseAtom.dah, MorseAtom.dit],
  "o": [MorseAtom.dah, MorseAtom.dah, MorseAtom.dah],
  "p": [MorseAtom.dit, MorseAtom.dah, MorseAtom.dah, MorseAtom.dit],
  "q": [MorseAtom.dah, MorseAtom.dah, MorseAtom.dit, MorseAtom.dah],
  "r": [MorseAtom.dit, MorseAtom.dah, MorseAtom.dit],
  "s": [MorseAtom.dit, MorseAtom.dit, MorseAtom.dit],
  "t": [MorseAtom.dah],
  "u": [MorseAtom.dit, MorseAtom.dit, MorseAtom.dah],
  "v": [MorseAtom.dit, MorseAtom.dit, MorseAtom.dit, MorseAtom.dah],
  "w": [MorseAtom.dit, MorseAtom.dah, MorseAtom.dah],
  "x": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dit, MorseAtom.dah],
  "y": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dah, MorseAtom.dah],
  "z": [MorseAtom.dah, MorseAtom.dah, MorseAtom.dit, MorseAtom.dit],
  '1': [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  '2': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  '3': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  '4': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  '5': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '6': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '7': [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '8': [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '9': [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  '0': [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  '.': [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  ',': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  ':': [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '?': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '!': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  '_': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  '+': [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  '-': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  '×': [MorseAtom.dah, MorseAtom.dit, MorseAtom.dit, MorseAtom.dah],
  '^': [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  '/': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  '@': [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  '(': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  ')': [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  '\n': [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  ' ': [],
};

MorseCharacter? charToMorse(String char) {
  if (morseDictionary.containsKey(char)) {
    return morseDictionary[char];
  } else {
    return null;
  }
}

typedef MorseSequence = List<MorseCharacter>;

MorseSequence? charsToMorse(List<String> chars) {
  MorseSequence result = [];
  for (var char in chars) {
    var morse = charToMorse(char);
    if (morse == null) {
      return null;
    }
    result.add(morse);
  }
  return result;
}

MorseSequence? stringToMorse(String str) {
  return charsToMorse(str.split(''));
}

const morseUnitMilliseconds = 200;
const morseLongMilliseconds = morseUnitMilliseconds * 3;
const morseBetweenDurationMilliseconds = morseUnitMilliseconds * 3;

String reverseKey(MorseCharacter morseCharacter) {
  return morseCharacter.map((atom) => atom.display).join();
}

Map<String, String> makeReverseDictionary(
    Map<String, MorseCharacter> dictionary) {
  final Map<String, String> result = {};
  dictionary.forEach((key, morseCharacter) {
    result[reverseKey(morseCharacter)] = key;
  });
  return result;
}

final reverseDictionary = makeReverseDictionary(morseDictionary);

String? morseToChar(MorseCharacter morseCharacter) {
  return reverseDictionary[reverseKey(morseCharacter)];
}
