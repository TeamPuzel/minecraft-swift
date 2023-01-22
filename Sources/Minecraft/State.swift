
import Distributed

final distributed actor State {
    
    init(actorSystem: ActorSystem) {
        self.actorSystem = actorSystem
    }
    
}

// Actor configuration, just makes it run locally for now.
extension State {
    typealias ActorSystem = LocalTestingDistributedActorSystem
}