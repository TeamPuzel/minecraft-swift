
// MARK: - Dependencies

import GLAD        // OpenGL function loading.
import SDL2        // Windowing, audio, context and input.

// MARK: - Program

/// The main enum. It only really exists because Swift has no
/// actual `@main` functions yet sadly.
@main
enum Main {
    
    /// The OpenGL context provided by SDL.
    static var context: SDL_GLContext!
    /// The `Event` struct, used for responding to events such as
    /// keyboard input or window resizing.
    static var event: SDL_Event!
    /// The game state, currently not implemented.
    static var state: State!
    
    /// The main function. It must not be async -
    /// OpenGL is not easy to work with from multiple threads.
    /// Another issue is that SDL uses obj-c on macOS
    /// to provide the window and other features. This is a problem because
    /// tasks related to UI *must* be done on the main thread.
    /// This can of course be solved with `@MainActor` but at the cost of
    /// increased complexity and some performance.
    static func main() {
        
        // MARK: - Init SDL
        
        // This will be adjusted in the future
        // in case more subsystems are necessary (like audio).
        SDL_Init(SDL_INIT_VIDEO)
        defer { SDL_Quit() }
        
        let window = SDL_CreateWindow(
            "Minecraft",
            Int32(SDL_WINDOWPOS_CENTERED_MASK),
            Int32(SDL_WINDOWPOS_CENTERED_MASK),
            800, 600, SDL_WINDOW_ALLOW_HIGHDPI.rawValue |
            SDL_WINDOW_RESIZABLE.rawValue |
            SDL_WINDOW_OPENGL.rawValue
        )
        defer { SDL_DestroyWindow(window) }
        
        self.event = SDL_Event() // create the event struct for later.
        
        // MARK: - OpenGL context
        
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                            Int32(SDL_GL_CONTEXT_PROFILE_CORE.rawValue))
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
        
        self.context = SDL_GL_CreateContext(window)
        
        
        // MARK: Load OpenGL pointers
        // This will try to load OpenGL function pointers.
        // If successful driver information will be logged,
        // otherwise print an error and exit.
        do {
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
        }
        
        // MARK: Set up the VertexArray
        // This is a weird feature specific to OpenGL and
        // supposedly it actually makes performance worse.
        // This is done automatically in the compatibility profile
        // however I'm using the core profile.
        // It's perfectly fine to just have one of these and
        // set the VertexAttribPointer manually each time.
        do {
            var vertexArray: GLuint = 0
            glad_glGenVertexArrays(1, &vertexArray)
            glad_glBindVertexArray(vertexArray)
            glad_glEnableVertexAttribArray(0)
        }
        
        // MARK: Initialize shaders
        // Shaders are implemented as a subsystem in a file.
        // Rather than bothering with an unnecessary OOP structure
        // for something that exists for the entire lifetime anyway
        // it's just a single file with `fileprivate` access control.
        Shaders.initialize()
        
        // TODO: Initialise state
        
        // MARK: OpenGL test
        
        var triangle = GL.VertexBuffer([
            GL.Vertex2D(x: -0.5, y: -0.5),
            GL.Vertex2D(x:  0.0, y:  0.5),
            GL.Vertex2D(x:  0.5, y: -0.5)
        ])
        
        glad_glVertexAttribPointer(
            0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            Int32(MemoryLayout<Float32>.stride * 2),
            nil
        )
        
        glad_glClearColor(0.0, 0.0, 0.0, 1.0)
        
        // MARK: - Main loop
        
    loop:
        while true {
            // Handle all new events.
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
        // At this point all the `defer` statements will execute
        // and the program can safely exit.
        
    }
}
