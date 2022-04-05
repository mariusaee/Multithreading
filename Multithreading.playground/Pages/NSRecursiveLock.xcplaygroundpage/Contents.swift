import Foundation
import Darwin

class RecursiveMutexThread {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstTask() {
        pthread_mutex_lock(&mutex)
        secondTask()
        do {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func secondTask() {
        pthread_mutex_lock(&mutex)
        print("Finish")
        do {
            pthread_mutex_unlock(&mutex)
        }
    }
}

let recirsive = RecursiveMutexThread()
recirsive.firstTask()


// NSRecursiveLock
let recursiveLock = NSRecursiveLock()

class RecursiveNSThread: Thread {
    override func main() {
        recursiveLock.lock()
        print("Thread acqired lock")
        secondTask()
        do {
            recursiveLock.unlock()
        }
        print("Exit main")
    }
    
    func secondTask() {
        recursiveLock.lock()
        print("Thread acqired lock")
        do {
            recursiveLock.unlock()
        }
        print("Exit secondTask")
    }
}

let nsThread = RecursiveNSThread()
nsThread.start()
