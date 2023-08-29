
public struct StateChangeContext<Output, Context> {
    public let context:Context
    private let changeState:(
        _ state:any StateInterface<Output,Context>,
        _ context:Context
    )->()
    
    internal init(context: Context, changeState: @escaping (_: any StateInterface<Output, Context>, _: Context) -> Void) {
        self.context = context
        self.changeState = changeState
    }
    
    public func enter(state:any StateInterface<Output,Context>) {
        self.enter(state: state, updateContext: self.context)
    }
    
    public func enter(state:any StateInterface<Output,Context>, updateContext context:Context) {
        self.changeState(state, context)
    }
}
