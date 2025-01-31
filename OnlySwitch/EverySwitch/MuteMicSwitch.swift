//
//  MuteMicSwitch.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2022/1/7.
//

import Foundation

let MicVolumeKey = "MicVolumeKey"
class MuteMicSwitch:SwitchProvider {
    var type: SwitchType = .muteMicrophone
    weak var delegate: SwitchDelegate?
    func currentStatus() -> Bool {
        let result = VolumeCMD.getInput.runAppleScript()
        if result.0 {
            let volume:String = result.1 as! String
            let volumeValue:Int = Int(volume) ?? 50
            UserDefaults.standard.set(volume, forKey: MicVolumeKey)
            UserDefaults.standard.synchronize()
            return volumeValue == 0
        } else {
            return false
        }
    }
    
    func currentInfo() -> String {
        return ""
    }
    
    func operationSwitch(isOn: Bool) async -> Bool {
        if isOn {
            let cmd = VolumeCMD.setInput + "0"
            return cmd.runAppleScript().0
        } else {
            var volumeValue = UserDefaults.standard.integer(forKey: MicVolumeKey)
            volumeValue = (volumeValue == 0) ? 50 : volumeValue
            let cmd = VolumeCMD.setInput + String(volumeValue)
            return cmd.runAppleScript().0
        }
    }
    
    func isVisable() -> Bool {
        return true
    }
    
    
}
