
import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
class StateMachine<Output,Context> {
    private var _output:Output? = nil
    internal var output:Output {
        get {
            guard let safeOutput = _output else {
                fatalError("Missing output in StateMachine")
            }
            return safeOutput
        }
        set {
            _output = newValue
            outputStreamContinuation.yield(output)
        }
    }
    
    private var outputStreamContinuation:AsyncStream<Output>.Continuation!
    internal var outputStream: AsyncStream<Output>!
    
    internal init(state: any StateInterface<Output,Context>, context: Context) {
        self.outputStream = AsyncStream(bufferingPolicy: .bufferingNewest(1)) { [unowned self] (continuation: AsyncStream<Output>.Continuation) -> Void in
            self.outputStreamContinuation = continuation
        }
        self.outputStreamContinuation.onTermination = {
            @Sendable
            [unowned self] result in
            self.outputStreamContinuation = nil
        }
        let stateChangeContext = StateChangeContext<Output, Context>(context: context, changeState: self.enter)
        
        self._output = state.enter(changeContext: stateChangeContext)
    }
    
    private func enter(_ nextState:any StateInterface<Output,Context>, _ context:Context) {
        let stateChangeContext = StateChangeContext<Output, Context>(
            context: context,
            changeState: self.enter
        )
        self.output = nextState.enter(changeContext: stateChangeContext)
    }
    
}




