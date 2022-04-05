import Foundation

//let queue = DispatchQueue(label: "Queue", attributes: .concurrent)
//// Указываем количество потоков в нашей очереди - 2. Значит одновременно будут выполняться две задачи в разных потоках.
//let semaphore = DispatchSemaphore(value: 0)
//queue.async {
//    semaphore.wait() //value - 1. Мы заняли один поток. Теперь мы можем принять еще только один поток.
//    sleep(3)
//    print("method 1 in \(Thread.current.description)")
//    semaphore.signal() //value + 1
//}
//
//queue.async {
//    semaphore.wait()
//    sleep(3)
//    print("method 2 in \(Thread.current.description)")
//    semaphore.signal()
//}
//
//queue.async {
//    semaphore.wait()
//    sleep(3)
//    print("method 3 in \(Thread.current.description)")
//    semaphore.signal()
//}
//
////---
//
//let semaphoreTwo = DispatchSemaphore(value: 0)
//
//DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
//    semaphoreTwo.wait(timeout: DispatchTime.distantFuture)
//
//    print("Block \(id) in \(Thread.current)")
//    sleep(1)
//
//    semaphoreTwo.signal()
//}

class SemaphoreTest {
    private let semaphore = DispatchSemaphore(value: 2)
    var array = [Int]()
    
    func work(_ id: Int) {
        semaphore.wait()
        
        array.append(id)
        print("\(array.count) in \(Thread.current)")
        
        semaphore.signal()
    }
    
    func startAllThreads() {
        DispatchQueue.global().async {
            self.work(111)
        }
        
        DispatchQueue.global().async {
            self.work(2)
        }
        
        DispatchQueue.global().async {
            self.work(3)
        }
        
        DispatchQueue.global().async {
            self.work(4)
        }
        
        DispatchQueue.global().async {
            self.work(111)
        }
        
        DispatchQueue.global().async {
            self.work(2)
        }
        
        DispatchQueue.global().async {
            self.work(3)
        }
        
        DispatchQueue.global().async {
            self.work(434563643)
        }
        DispatchQueue.global().async {
            self.work(3456436)
        }
        
        DispatchQueue.global().async {
            self.work(512)
        }
        
        DispatchQueue.global().async {
            self.work(111234)
        }
        
        DispatchQueue.global().async {
            self.work(5232)
        }
        
        DispatchQueue.global().async {
            self.work(31234)
        }
        
        DispatchQueue.global().async {
            self.work(43)
        }
    }
}

let semaTest = SemaphoreTest()
semaTest.startAllThreads()
