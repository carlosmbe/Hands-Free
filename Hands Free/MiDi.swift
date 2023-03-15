//
//  MiDi.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 04/12/2022.
//

import AudioToolbox


public class Time_Control:Thread{

    var wait_time:Int //In seconds
    public var can_send:Bool = true

    init(_ wait_time:Int) {
        self.wait_time = wait_time
    }

    public override func start() {
        super.start()

        self.can_send = false
        Thread.self.sleep(forTimeInterval: TimeInterval(self.wait_time))
        self.can_send = true
    }
}

var control = Time_Control(0)

public func playMajorChord(root: UInt8 = 60, finger: String){
    
    if control.can_send{
        //Start the time controller with 1 second
        control = Time_Control(1)
        control.start()
        
        let thirdMin = root + 4
        let fifth = root + 7
        
        let chord : [UInt8] = [root,thirdMin,fifth]
        createPlayer(chord: chord)
        ChordInstance.ChordTitle = "\(finger)"
    }

}

func createPlayer(chord : [UInt8]){
    var musicPlayer : MusicPlayer? = nil
    var player = NewMusicPlayer(&musicPlayer)
    
    createMusicSequence(chord: chord)
    
    player = MusicPlayerSetSequence(musicPlayer!, createMusicSequence(chord: chord))
    player = MusicPlayerStart(musicPlayer!)
}

func createMusicSequence(chord: [UInt8] ) -> MusicSequence {
    // create the sequence
    var musicSequence: MusicSequence?
    var status = NewMusicSequence(&musicSequence)
    if status != noErr {
        print(" bad status \(status) creating sequence")
    }
    
    /*
     var tempoTrack: MusicTrack?
     if MusicSequenceGetTempoTrack(musicSequence!, &tempoTrack) != noErr {
     assert(tempoTrack != nil, "Cannot get tempo track")
     }
     //MusicTrackClear(tempoTrack, 0, 1)
     if MusicTrackNewExtendedTempoEvent(tempoTrack!, 0.0, 128.0) != noErr {
     print("could not set tempo")
     }
     if MusicTrackNewExtendedTempoEvent(tempoTrack!, 4.0, 256.0) != noErr {
     print("could not set tempo")
     }
     
     */
    // add a track
    var track: MusicTrack?
    status = MusicSequenceNewTrack(musicSequence!, &track)
    if status != noErr {
        print("error creating track \(status)")
    }
    
    // now make some notes and put them on the track
    var beat: MusicTimeStamp = 0.0
    
    for note: UInt8 in chord {
        var mess = MIDINoteMessage(channel: 0,
                                   note: note,
                                   velocity: 64,
                                   releaseVelocity: 0,
                                   duration: 1.0 )
        
        status = MusicTrackNewMIDINoteEvent(track!, beat, &mess)
        
        if status != noErr {    print("creating new midi note event \(status)") }
    }
    
    CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence!))
    
    return musicSequence!
}


