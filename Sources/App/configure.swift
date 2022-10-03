import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let cors = CORSMiddleware(
        configuration: .init(
            allowedOrigin: .all,
            allowedMethods: [
                .POST,
                .GET,
                .OPTIONS
            ],
            allowedHeaders: [
                .accept,
                .authorization,
                .contentType,
                .origin,
                .xRequestedWith,
                .userAgent,
                .accessControlAllowOrigin,
                .init("ReCaptchaToken")
            ]
        )
    )
    app.middleware.use(cors)
    
    switch app.environment {
    // Used for Heroku
    case .production:
        guard let databaseURL = Environment.get("DATABASE_URL"),
              var postgresConfig = PostgresConfiguration(url: databaseURL)
        else {
            break
        }

        let postgresTLSConfiguration: TLSConfiguration = {
            var configuration = TLSConfiguration.makeClientConfiguration()
            configuration.certificateVerification = .none
            return configuration
        }()
        postgresConfig.tlsConfiguration = postgresTLSConfiguration
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
        
    default:
        let database: String
        if app.environment == .testing {
            database = UUID().uuidString
        } else {
            database = Environment.get("DATABASE_NAME") ?? "vapor_database"
        }
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: database
        ), as: .psql)
    }

    app.migrations.add(CreateFeedbackRecords())

    // register routes
    try routes(app)
}
