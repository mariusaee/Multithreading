import Darwin
import Foundation

var avaliable = false
var condition = pthread_cond_t()
var mutex = pthread_mutex_t()

class ConditionMutexPrinter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
        
    }
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod() {
        pthread_mutex_lock(&mutex)
        print("Enter to Printer")
        while (!avaliable) {
            pthread_cond_wait(&condition, &mutex)
        }
        avaliable = false
        do {
            pthread_mutex_unlock(&mutex)
        }
        print("Exit from Printer")
    }
}

class ConditionMutexWriter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
        
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        pthread_mutex_lock(&mutex)
        print("Enter to Writer")
        avaliable = true
        pthread_cond_signal(&condition)
        do {
            pthread_mutex_unlock(&mutex)
        }
        print("Exit from Writer")
    }
}

let writer = ConditionMutexWriter()
let printer = ConditionMutexPrinter()

printer.start()
writer.start()



var nsAvaliable = false
let nsCondition = NSCondition()

class NSPrinter: Thread {
    override func main() {
        nsCondition.lock()
        print("NS enter to Printer")
        while(!nsAvaliable) {
            nsCondition.wait()
        }
        nsAvaliable = false
        nsCondition.unlock()
        print("NS exit from Printer")
    }
}

class NSWriter: Thread {
    override func main() {
        nsCondition.lock()
        print("NS enter to Writer")
        nsAvaliable = true
        nsCondition.signal()
        nsCondition.unlock()
        print("NS exit from Writer")
    }
}

let nsWriter = NSWriter()
let nsPrinter = NSPrinter()

nsPrinter.start()
nsWriter.start()


