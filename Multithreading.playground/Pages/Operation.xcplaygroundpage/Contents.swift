import Foundation

//print(Thread.current)

// Создаем блок кода, который будет выполнятся. Это не Operation!
let operationOne = {
    print("Start")
    print(Thread.current)
    print("Finished")
}

// Создаем очередь OperationQueue
let myQueue = OperationQueue()

// Передаем в очередь созданный блок кода. Не Operation! Это блок кода выполнятся асинхронно, не в main queue.
//myQueue.addOperation(operationOne)

print("----------------------------------------------------")

let myQueueTwo = OperationQueue()

var result: String?
let concurrentOperation = BlockOperation {
    result = "My Result"
    print(Thread.current)
}

// Если просто стартануть, то все выполнится в main
//concurrentOperation.start()
//print(result!)

// Надо положить в очередь
//myQueueTwo.addOperation(concurrentOperation)

//let MyQueueThree = OperationQueue()
//MyQueueThree.addOperation {
//    print("Test")
//    print(Thread.current)
//}

class MyThread: Thread {
    override func main() {
        print("Test main thread")
        print(Thread.current)
    }
}

let myThread = MyThread()
myThread.start()

class MyOperation: Operation {
    override func main() {
        print("Test my Operation")
        print(Thread.current)
    }
}

let myOperation = MyOperation()
//myOperation.start()

print("----------------------------------------------------")

let myOperationQueue = OperationQueue()
myOperationQueue.addOperation(myOperation)
