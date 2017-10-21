//
//  RecordingAudio.swift
//  PicturePerfect
//
//  Created by Edvin Lellhame on 8/10/15.
//  Copyright (c) 2015 edvin. All rights reserved.
//

import Foundation


class RecordingAudio : NSObject {

    var fileURL: NSURL
    var title: String

    init(fileURL: NSURL, title: String) {
        self.fileURL = fileURL
        self.title = title
    }
}