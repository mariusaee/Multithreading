import Foundation

let myOperationQueue = OperationQueue()

class OperationCancel: Operation {
    override func main() {
        if isCancelled {
            print(isCancelled)
            return
        }
        print("Test 1")
        sleep(1)
        
        if isCancelled {
            print(isCancelled)
            return
        }
        print("Test 2")
    }
}

func cancelOperation() {
    let operation = OperationCancel()
    myOperationQueue.addOperation(operation)
    operation.cancel()
}

//cancelOperation()

class WaitOperation {
    private let operationQueue = OperationQueue()
    
    func test() {
        operationQueue.addOperation {
            sleep(1)
            print("test 1 in \(Thread.current)")
        }
        
        operationQueue.addOperation {
            sleep(2)
            print("test 2 in \(Thread.current)")
        }
        operationQueue.waitUntilAllOperationsAreFinished()
        operationQueue.addOperation {
            print("test 3 in \(Thread.current)")
        }
        
        operationQueue.addOperation {
            print("test 4 in \(Thread.current)")
        }
    }
}

let waitOperation = WaitOperation()
waitOperation.test()

class WaitOperationTwo {
    private let operationQueue = OperationQueue()

    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("Test 1")
        }
        let operation2 = BlockOperation {
            sleep(2)
            print("Test 2")
        }
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
    }
}

let waitOperationTwo = WaitOperationTwo()
waitOperationTwo.test()

class CompletionBlock {
    private let operationQueue = OperationQueue()

    func test() {
        let operation = BlockOperation {
            print("Test CompletionBlock")
        }
        operation.completionBlock = {
            print("Finish CompletionBlock")
        }
        operationQueue.addOperation(operation)
    }
}

let completionBlock = CompletionBlock()
completionBlock.test()
