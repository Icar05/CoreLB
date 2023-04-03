//
//  File.swift
//  
//
//  Created by Галяткин Александр on 11.03.2023.
//



import Foundation
import AVFoundation

public enum SoundCaf: String{
    case DoubleClick      =  "DoubleClick"
    case MouseOff         =  "MouseOff"
    case MouseOn          =  "MouseOn"
    case RecorderClick    =  "RecorderClick"
    case Response         =  "Response"
    case Ring             =  "Ring"
    case SimpleResponse   =  "SimpleResponse"
    case SwitchOff        =  "SwitchOff"
    case SwitchOn         =  "SwitchOn"
    case Tap              =  "Tap"
}

public extension SoundCaf{
    
    static func responseSound() -> SoundCaf {
        return .Response
    }
    
    static func simpleResponceSound() -> SoundCaf{
        return .SimpleResponse
    }
    
    static func actionSound() -> SoundCaf{
        return .MouseOff
    }
    
    static func switchSound() -> SoundCaf{
        return .SwitchOff
    }
}



public final class EasyPlayer{
    
    
    
    private var volume: Float = 0.5
    
    private var sound: SoundCaf? = nil
    
    private var player: AVAudioPlayer? = nil
    
    
    public init(){}
    
    
    public func initPlayer(_ sound: SoundCaf){
        self.sound = sound
        
        do {
            guard let path = Bundle.module.path(forResource: sound.rawValue, ofType: "mp3") else {
                print("Sound file not found")
                return
            }
            
            let storedURL = URL(fileURLWithPath: path)
            self.player   = try AVAudioPlayer(contentsOf: storedURL, fileTypeHint: AVFileType.mp3.rawValue)
            self.player?.volume = volume
        } catch let error {
            print("Player: error: \(error) ")
        }
    }
    
    public func stop(){
        player?.stop()
    }
    
    public func play(){
        guard let player = player else {
            return
        }

        player.play()
    }

    
}
