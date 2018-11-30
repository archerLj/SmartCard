//
//  SCTimer.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/29.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

class SCTimer {
    var block: () -> Void
    var source: DispatchSourceTimer
    
    init(block: @escaping () -> Void, source: DispatchSourceTimer) {
        self.block = block
        self.source = source
    }
    
    class func repeatingTimer(timeInterval seconds: Double, block: @escaping () -> Void) -> SCTimer {
        let source = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        let timer = SCTimer(block: block, source: source)
        timer.source.schedule(deadline: .now(), repeating: .init(1), leeway: .microseconds(100))
        timer.source.setEventHandler(handler: block)
        timer.source.resume()
        return timer
    }
    
    deinit {
        self.source.cancel()
    }
}
