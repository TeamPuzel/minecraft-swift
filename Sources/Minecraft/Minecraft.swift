
import Distributed
import GLAD
import SDL2

@main
enum Main {
    
    static var window:  OpaquePointer!
    static var context: SDL_GLContext!
    static var event:   SDL_Event!
    static var state:   State!
    
    static let actorSystem = LocalTestingDistributedActorSystem()
    
    static func main() async {
        
        // MARK: - Init SDL

        SDL_Init(SDL_INIT_VIDEO)
        defer { SDL_Quit() }
        
        self.window = SDL_CreateWindow(
            "Minecraft",
            Int32(SDL_WINDOWPOS_CENTERED_MASK),
            Int32(SDL_WINDOWPOS_CENTERED_MASK),
            800, 600, SDL_WINDOW_ALLOW_HIGHDPI.rawValue |
            SDL_WINDOW_RESIZABLE.rawValue |
            SDL_WINDOW_OPENGL.rawValue
        )
        defer { SDL_DestroyWindow(window) }
        
        // MARK: OpenGL
        
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                            Int32(SDL_GL_CONTEXT_PROFILE_CORE.rawValue))
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
        
        self.context = SDL_GL_CreateContext(window)
        
        guard gladLoadGLLoader(SDL_GL_GetProcAddress) != 0 else {
            print("Error: Could not start OpenGL".color(.red)); exit(-1)
        }
        
        print(
            """
            
            \(divider)
            Using OpenGL \(String(cString: glad_glGetString(GLenum(GL_VERSION))!))
            Vendor:   \(String(cString: glad_glGetString(GLenum(GL_VENDOR))!))
            Renderer: \(String(cString: glad_glGetString(GLenum(GL_RENDERER))!))
            GLSL:     \(String(cString: glad_glGetString(GLenum(GL_SHADING_LANGUAGE_VERSION))!))
            \(divider)
            
            """.color(.green)
        )
        
        // Initialize the shader subsystem
        Shaders.initialize()
        
        // MARK: - Init State
        
        self.state = State(actorSystem: self.actorSystem)
        
        // OpenGL test
        
        var triangle = GL.VertexBuffer([
            GL.Vertex2D(x: -0.5, y: -0.5),
            GL.Vertex2D(x:  0.0, y:  0.5),
            GL.Vertex2D(x:  0.5, y: -0.5)
        ])

        var vertexArray: GLuint = 0
        glad_glGenVertexArrays(1, &vertexArray)
        glad_glBindVertexArray(vertexArray)
        glad_glEnableVertexAttribArray(0)
        glad_glVertexAttribPointer(
            0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            Int32(MemoryLayout<Float32>.stride * 2),
            nil
        )
        
        glad_glClearColor(0.0, 0.0, 0.0, 1.0)
        
        // MARK: - Main loop
        
        self.event = SDL_Event()
        
    loop:
        while true {
            // Handle events
            while event.poll() {
                switch event.type {
                case SDL_QUIT.rawValue: break loop
                default:
                    #if DEBUG
                    print("Unknown event: \(event.type)")
                    #endif
                }
            }
            
            // Logic
            
            glad_glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            glad_glUseProgram(Shaders.list[.debug]!)
            glad_glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
            
            // TODO: Fix this
            SDL_Delay(33)
            SDL_GL_SwapWindow(window)
        }
        
        // MARK: End
        
    }
}
