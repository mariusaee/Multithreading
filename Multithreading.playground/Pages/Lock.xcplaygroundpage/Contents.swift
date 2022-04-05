import Darwin
import Foundation

class ReadAndWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
   
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        set {
            pthread_rwlock_unlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

class SpinLock {
    private var lock = OS_SPINLOCK_INIT
    func doSomething(completion: () -> Void) {
        OSSpinLockLock(&lock)
        completion()
        OSSpinLockUnlock(&lock)
    }
}

class unfairLock {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}

class SynchronizeLock {
    private let lock = NSObject()
    
    var array = [Int]()
    
    func some() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}

