import Foundation
import Vapor

struct AsyncAdminAuthenticator: AsyncBasicAuthenticator {

    typealias User = App.AdminUser

    func authenticate(basic: Vapor.BasicAuthorization, for request: Vapor.Request) async throws {
        guard let adminLogin = Environment.get("ADMIN_LOGIN"),
              let adminPassword = Environment.get("ADMIN_PASSWORD")
        else { return }
        if basic.username == adminLogin && basic.password == adminPassword {
            request.auth.login(User(user: adminLogin))
        }
    }
}
