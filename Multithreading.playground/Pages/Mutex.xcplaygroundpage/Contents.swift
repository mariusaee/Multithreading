import Darwin
import Foundation

class SafeThread {
    // создаем mutex
    private var mutex = pthread_mutex_t()
    
    // инициализируем mutex
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    func doSomething(complition: () -> Void) {
        // Блокируем
        pthread_mutex_lock(&mutex)
        
        // Данные, которые требуется защитить.
        complition()
        
        // Разблокируем. defer нужен для того, что бы освободить поток в случае какого-то несчастного случая. Например внезапного закрытия прилоежния.
        do {
            pthread_mutex_unlock(&mutex)
        }
    }
}

var array = [String]()
let safeThread = SafeThread()

safeThread.doSomething {
    array.append("1 thread")
    print(array)
}

array.append("2 thread")
print(array)


class SafeNSThread {
    // создаем mutex
    private let mutex = NSLock()
    
    func doSomething(complition: () -> Void) {
        // Блокируем
        mutex.lock()
        
        // Данные, которые требуется защитить.
        complition()
        
        // Разблокируем. defer нужен для того, что бы освободить поток в случае какого-то несчастного случая. Например внезапного закрытия прилоежния.
        do {
            mutex.unlock()
        }
    }
}
