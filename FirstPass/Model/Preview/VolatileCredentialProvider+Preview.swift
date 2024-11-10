import Foundation

#if DEBUG

extension VolatileCredentialProvider {
    convenience init(credentials: [Credential]) {
        self.init()
        for credential in credentials {
            self.setCredential(credential)
        }
    }
}

#endif
