
import GLAD

// TODO: Documentation, possibly a better interface.

fileprivate struct ShaderSource {
    
    internal init(code: StaticString, kind: ShaderSource.Kind) {
        #if DEBUG
        assert(code.isASCII)
        #endif
        self.code = code
        self.kind = kind
    }
    
    enum Kind { case vertex, fragment }
    let code: StaticString
    let kind: Kind
    
    var rawKind: GLenum {
        get {
            return kind == .vertex ?
            GLenum(GL_VERTEX_SHADER) :
            GLenum(GL_FRAGMENT_SHADER)
        }
    }
}

fileprivate func createShader(vertex: ShaderSource, fragment: ShaderSource) -> UInt32 {
    
    func compileShader(from source: ShaderSource) -> UInt32 {
        let id = glad_glCreateShader(source.rawKind)
        let start = unsafeBitCast(source.code.utf8Start, to: UnsafePointer<Int8>?.self)
        withUnsafePointer(to: start) { pointer in
            glad_glShaderSource(id, 1, pointer, nil)
            glad_glCompileShader(id)
        }
        
        #if DEBUG
        var result: Int32 = 0
        glad_glGetShaderiv(id, GLenum(GL_COMPILE_STATUS), &result)
        if result == GL_FALSE {
            var length: CInt = 0
            glad_glGetShaderiv(id, GLenum(GL_INFO_LOG_LENGTH), &length)
            withUnsafeTemporaryAllocation(of: CChar.self, capacity: Int(length)) { cArray in
                glad_glGetShaderInfoLog(id, length, &length, cArray.baseAddress)
                print(source.kind == .vertex ? "Vertex error:" : "Fragment error:")
                print(String(cString: Array(cArray)))
            }
        }
        #endif
        
        return id
    }
    
    let program = glad_glCreateProgram()
    
    let vertex = compileShader(from: vertex)
    let fragment = compileShader(from: fragment)
    
    glad_glAttachShader(program, vertex)
    glad_glAttachShader(program, fragment)
    glad_glLinkProgram(program)
    
//    #if DEBUG
//    var result: Int32 = 0
//    glad_glGetShaderiv(program, GLenum(GL_LINK_STATUS), &result)
//    if result == GL_FALSE {
//        var length: CInt = 0
//        glad_glGetShaderiv(program, GLenum(GL_INFO_LOG_LENGTH), &length)
//        withUnsafeTemporaryAllocation(of: CChar.self, capacity: Int(length)) { cArray in
//            glad_glGetShaderInfoLog(program, length, &length, cArray.baseAddress)
//            print("Linking error:")
//            guard cArray.count > 0 else { return }
//            print(String(cString: Array(cArray)))
//        }
//    }
//    #endif
    
    glad_glValidateProgram(program)
    
    #if !DEBUG
    glad_glDetachShader(program, vertex)
    glad_glDetachShader(program, fragment)
    #endif
    
    glad_glDeleteShader(vertex)
    glad_glDeleteShader(fragment)
    
    return program
    
}

enum Shaders {
    
    enum ShaderName {
        case debug
    }
    
    static var list: [ShaderName: GLuint] = [:]
    
    static func initialize() {
        
        list[.debug] = createShader(
            vertex: debug.vertex,
            fragment: debug.fragment
        )
        
    }
    
}

// MARK: - Shaders

fileprivate struct ProgramSource { let vertex, fragment: ShaderSource }

fileprivate let debug = ProgramSource(
    vertex: ShaderSource(
        code: """
        #version 330 core
        
        layout(location = 0) in vec4 position;
        
        void main() {
            gl_Position = position;
        }
        """,
        kind: .vertex
    ),
    fragment: ShaderSource(
        code: """
        #version 330 core
        
        layout(location = 0) out vec4 color;
        
        void main() {
            color = vec4(1.0, 0.0, 0.0, 1.0);
        }
        """,
        kind: .fragment
    )
)

fileprivate enum Shader {
    case vertex(StaticString)
    case fragment(StaticString)
}
