//
//  MorseCoder.swift
//  Runner
//
//  Created by 田中健策 on 2024/03/07.
//

import Foundation

enum MorseAtom: Int {
    case dit = 0
    case dah = 1
}

typealias MorseCharacter = Array<MorseAtom>

let MORSE_DICTIONARY: Dictionary<String, MorseCharacter> = [
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
  "1": [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  "2": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  "3": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  "4": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  "5": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "6": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "7": [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "8": [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "9": [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  "0": [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  ".": [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  ",": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  ":": [
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "?": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "!": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah
  ],
  "_": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  "+": [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  "-": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  "×": [MorseAtom.dah, MorseAtom.dit, MorseAtom.dit, MorseAtom.dah],
  "^": [
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  "/": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  "@": [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  "(": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit
  ],
  ")": [
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah
  ],
  "\n": [
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dah,
    MorseAtom.dit,
    MorseAtom.dit
  ],
  " ": [],
];

func charToMorse(char: String) -> MorseCharacter? {
    if MORSE_DICTIONARY.keys.contains(char) {
        return MORSE_DICTIONARY[char]
    }
    return nil
}

typealias MorseSequence = Array<MorseCharacter>

func charsToMorse(chars: Array<String>) -> MorseSequence? {
    var result: MorseSequence = []
    for char in chars {
        if let morseChar = charToMorse(char: char) {
            result.append(morseChar)
        } else {
            return nil
        }
    }
    return result
}

func stingToMorse(string: String) -> MorseSequence? {
    return charsToMorse(chars: string.split(separator: "").map({(substring) in
        return String(substring)
    }))
}

let MORSE_UNIT_SECONDS = 0.2
let MORSE_LONG_SECONDS = MORSE_UNIT_SECONDS * 3
let MORSE_BETWEEN_DURATION_SECONDS = MORSE_UNIT_SECONDS * 3
let MORSE_LONG_BETWEEN_DURATION_SECONDS = MORSE_UNIT_SECONDS * 7
