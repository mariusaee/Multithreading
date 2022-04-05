import Foundation

let timer = DispatchSource.makeTimerSource(queue: .global())

timer.setEventHandler {
    print(Date())
}

timer.schedule(deadline: .now(), repeating: 1)
timer.activate()


