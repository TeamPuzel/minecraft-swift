
import GLAD

// MARK: - Protocols

protocol Renderer {} // TODO: Design

protocol Vertex {}

protocol VertexBuffer: Identifiable {
    var id: UInt32 { get }
    
    mutating func bind()
    mutating func unbind()
    mutating func destroy()
}

protocol IndexBuffer: Identifiable {
    var id: UInt32 { get }
    
    mutating func bind()
    mutating func unbind()
    mutating func destroy()
}

protocol VertexArray: Identifiable {
    var id: UInt32 { get }
    
    func addBuffer(_ buffer: some VertexBuffer)
}

// MARK: - OpenGL Implementation

enum GL {
    
    struct Vertex2D: Vertex { let x, y: Float }
    
    struct VertexBuffer<T: Vertex>: Minecraft.VertexBuffer {
        
        private(set) var id: UInt32
        
        enum Style { case `static`, dynamic, stream }
        
        init(_ vertices: [T], _ style: Style = .static) {
            self.id = 0
            glad_glGenBuffers(1, &id)
            GL.checkForErrors()
            self.bind()
            glad_glBufferData(
                GLenum(GL_ARRAY_BUFFER),
                MemoryLayout<T>.stride * vertices.count,
                vertices,
                {
                    switch style {
                    case .static:  return GLenum(GL_STATIC_DRAW)
                    case .dynamic: return GLenum(GL_DYNAMIC_DRAW)
                    case .stream:  return GLenum(GL_STREAM_DRAW)
                    }
                }()
            )
            GL.checkForErrors()
        }
        
        init() {
            self.id = 0
            glad_glGenBuffers(1, &id)
            GL.checkForErrors()
            self.bind()
        }
        
        mutating func bind() {
            glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), id)
            GL.checkForErrors()
        }
        
        mutating func unbind() {
            glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        }
        
        mutating func destroy() {
            glad_glDeleteBuffers(1, &id)
        }
        
    }
    
    struct IndexBuffer<T: UnsignedInteger>: Minecraft.IndexBuffer {
        
        private(set) var id: UInt32
        
        enum Style { case `static`, dynamic, stream }
        
        init(_ indices: [T], _ style: Style = .static) {
            self.id = 0
            glad_glGenBuffers(1, &id)
            GL.checkForErrors()
            self.bind()
            glad_glBufferData(
                GLenum(GL_ELEMENT_ARRAY_BUFFER),
                MemoryLayout<T>.stride * indices.count,
                indices,
                {
                    switch style {
                    case .static:  return GLenum(GL_STATIC_DRAW)
                    case .dynamic: return GLenum(GL_DYNAMIC_DRAW)
                    case .stream:  return GLenum(GL_STREAM_DRAW)
                    }
                }()
            )
            GL.checkForErrors()
        }
        
        init() {
            self.id = 0
            glad_glGenBuffers(1, &id)
            GL.checkForErrors()
            self.bind()
        }
        
        mutating func bind() {
            glad_glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), id)
            GL.checkForErrors()
        }
        
        mutating func unbind() {
            glad_glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        }
        
        mutating func destroy() {
            glad_glDeleteBuffers(1, &id)
        }
        
    }
    
    struct VertexArray: Minecraft.VertexArray {
        
        struct Element {
            let index: UInt32
            let type: UInt32
            let isNormalized: Bool
        }
        
        private(set) var id: UInt32
        
        func addBuffer(_ buffer: some Minecraft.VertexBuffer) {
            //
        }
    }
    
}
