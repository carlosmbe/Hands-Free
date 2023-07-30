// MiDi.swift
// Hands Free
// Created by Carlos Mbendera on 04/12/2022.
import AudioToolbox

/// This class controls the timing between consecutive MIDI sends.
public class TimeControl: Thread {
    // Time to wait before sending another MIDI message, in seconds.
    var waitTime: Int
    public var canSend: Bool = true

    init(waitTime: Int) {
        self.waitTime = waitTime
    }

    public override func start() {
        super.start()
        self.canSend = false
        Thread.self.sleep(forTimeInterval: TimeInterval(self.waitTime))
        self.canSend = true
    }
}

var control = TimeControl(waitTime: 0)

/// This function plays a major chord based on the root note and finger string.
public func playMajorChord(root: UInt8 = 60, finger: String) {
    if control.canSend {
        // Start the time controller with 1 second
        control = TimeControl(waitTime: 1)
        control.start()

        let thirdMin = root + 4
        let fifth = root + 7
        
        let chord: [UInt8] = [root, thirdMin, fifth]
        createPlayer(chord: chord)
        ChordInstance.ChordTitle = "\(finger)"
    }
}

/// This function creates a player for the given chord.
func createPlayer(chord: [UInt8]) {
    var musicPlayer: MusicPlayer? = nil
    var player = NewMusicPlayer(&musicPlayer)
    
    createMusicSequence(chord: chord)
    
    player = MusicPlayerSetSequence(musicPlayer!, createMusicSequence(chord: chord))
    player = MusicPlayerStart(musicPlayer!)
}

/// This function creates a music sequence for the given chord.
func createMusicSequence(chord: [UInt8]) -> MusicSequence {
    var musicSequence: MusicSequence?
    var status = NewMusicSequence(&musicSequence)
    if status != noErr {
        print("Bad status \(status) creating sequence")
    }

    var track: MusicTrack?
    status = MusicSequenceNewTrack(musicSequence!, &track)
    if status != noErr {
        print("Error creating track \(status)")
    }
    
    // Define and add notes to the track.
    var beat: MusicTimeStamp = 0.0
    for note: UInt8 in chord {
        var message = MIDINoteMessage(channel: 0,
                                      note: note,
                                      velocity: 64,
                                      releaseVelocity: 0,
                                      duration: 1.0)
        
        status = MusicTrackNewMIDINoteEvent(track!, beat, &message)
        if status != noErr {
            print("Error creating new midi note event \(status)")
        }
    }
    
    CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence!))
    
    return musicSequence!
}
