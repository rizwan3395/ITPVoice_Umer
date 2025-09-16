import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let dtmfChannel = FlutterMethodChannel(name: "dtmf_channel", binaryMessenger: controller.binaryMessenger)

        dtmfChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard call.method == "playTone" else {
                result(FlutterMethodNotImplemented)
                return
            }

            if let args = call.arguments as? [String: Any],
               let digits = args["digits"] as? String,
               let durationMs = args["durationMs"] as? Int,
               let volume = args["volume"] as? Double {
                self.playDtmfTones(digits: digits, durationMs: durationMs, volume: Float(volume))
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid DTMF arguments", details: nil))
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func playDtmfTones(digits: String, durationMs: Int, volume: Float) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Configure audio session for playback (VOIP-friendly)
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
            return
        }

        // Placeholder: Play tones sequentially
        digits.enumerated().forEach { (index, digit) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(index * durationMs)) {
                // Map digits to DTMF audio files or synthesize tones
                let toneFileName: String? = {
                    switch digit {
                    case "0": return "dtmf_0"
                    case "1": return "dtmf_1"
                    case "2": return "dtmf_2"
                    case "3": return "dtmf_3"
                    case "4": return "dtmf_4"
                    case "5": return "dtmf_5"
                    case "6": return "dtmf_6"
                    case "7": return "dtmf_7"
                    case "8": return "dtmf_8"
                    case "9": return "dtmf_9"
                    case "*": return "dtmf_star"
                    case "#": return "dtmf_pound"
                    case "A": return "dtmf_a"
                    case "B": return "dtmf_b"
                    case "C": return "dtmf_c"
                    case "D": return "dtmf_d"
                    default: return nil
                    }
                }()

                guard let fileName = toneFileName,
                      let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
                    print("Invalid DTMF digit or missing audio file: \(digit)")
                    return
                }

                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.volume = volume
                    player.prepareToPlay()
                    player.play()
                    // Note: Duration is controlled by audio file length; adjust file or use player.stop() after durationMs
                } catch {
                    print("Failed to play DTMF tone for \(digit): \(error)")
                }
            }
        }

        // Deactivate audio session after playback
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(digits.count * durationMs)) {
            try? audioSession.setActive(false)
        }
    }
}
