//
//  ContentView.swift
//  morse-coder-watch Watch App
//
//  Created by 田中健策 on 2024/03/07.
//

import SwiftUI
import WatchConnectivity
import AVFoundation

struct ContentView: View {
    @ObservedObject var connector = PhoneConnector()
    @State private var running = false
    @State private var looping = false
    @State private var flushing = false
    @State private var timer: Timer?
    @State private var currentSequence: MorseSequence = []
    @State private var currentCharIndex = 0
    @State private var currentAtomIndex = 0
    
    private func nextFlushInterval(timeInterval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: {(_) in
            let char = currentSequence[currentCharIndex]
            let interval = switch char[currentAtomIndex] {
            case .dit:
                MORSE_UNIT_SECONDS
            case .dah:
                MORSE_LONG_SECONDS
            }
            flushing = true
            nextDurationInterval(timeInterval: interval)
        })
    }
    
    private func nextDurationInterval(timeInterval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: {(_) in
            flushing = false
            let char = currentSequence[currentCharIndex]
            if currentAtomIndex + 1 < char.count {
                currentAtomIndex += 1
                nextFlushInterval(timeInterval: MORSE_UNIT_SECONDS)
                return
            }
            currentAtomIndex = 0
            if currentCharIndex + 1 < currentSequence.count {
                currentCharIndex += 1
                nextFlushInterval(timeInterval: MORSE_BETWEEN_DURATION_SECONDS)
                return
            }
            if looping {
                currentCharIndex = 0
                nextFlushInterval(timeInterval: MORSE_LONG_BETWEEN_DURATION_SECONDS)
                return
            }
            running = false
        })
    }
    
    var body: some View {
        ZStack {
            flushing ? Color.white.edgesIgnoringSafeArea(.all) : Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("モールス信号送信")
                Button(action: {
                    currentSequence = stingToMorse(string: connector.text) ?? []
                    if currentSequence.isEmpty {
                        return
                    }
                    running = !running
                    currentCharIndex = 0
                    currentAtomIndex = 0
                    if (running) {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
                            nextFlushInterval(timeInterval: 0.01)
                        })
                    } else {
                        timer?.invalidate()
                        flushing = false
                    }
                }) {
                    HStack {
                        Text("送信")
                        Image(systemName: running ? "stop" : "play")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                    }
                }
                HStack {
                    Text("送信文字列：")
                    Text(connector.text)
                }
                Toggle("ループ", isOn: $looping)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    @Published var text = ""
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage: \(message)")
        
        //受け取ったメッセージから解析結果を取り出す。
        let result = message["code"] as! String
        DispatchQueue.main.async {
            self.text = result
        }
    }
}
