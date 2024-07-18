using System;
using sokol;
namespace bge_core;
public static class Renderer
{
	static Gfx.Desc _desc = .();
	static Debugtext.Desc _debugTextDesc = .();
	static Gfx.PassAction _pass = .();
	static Gfx.Shader shader = .();
	static Gfx.Pipeline pipeline = .();
	static Gfx.Bindings bindings = .();

	private static void InitMesh()
	{
		// Create a mesh
		float[21] vertices = .( // positions            // colors
			0.0f,  0.5f, 0.5f,     1.0f, 0.0f, 0.0f, 1.0f,
			0.5f, -0.5f, 0.5f,     0.0f, 1.0f, 0.0f, 1.0f,
			-0.5f, -0.5f, 0.5f,     0.0f, 0.0f, 1.0f, 1.0f
			);
		Gfx.BufferDesc bufferDesc = .();
		bufferDesc.data = Gfx.asRange<float>(vertices);
		Gfx.Buffer buffer = Gfx.makeBuffer(&bufferDesc);
		bindings.vertex_buffers[0] = buffer;
	}

	private static void InitShaders()
	{
		// Create a shader
		Gfx.ShaderDesc shaderDesc = .();
		switch (Gfx.queryBackend())
		{
		case .GLCORE33:
		case .GLES2:
		case .GLES3:
			shaderDesc.vs.source = @"""
#version 330
layout(location=0) in vec4 position;
layout(location=1) in vec4 color0;
out vec4 color;
void main() {
  gl_Position = position;
  color = color0;
}
""";
			shaderDesc.fs.source = @"""
#version 330
in vec4 color;
out vec4 frag_color;
void main() {
  frag_color = color;
}
""";
			break;

		case .D3D11:
			shaderDesc.attrs[0].sem_name = "POS";
			shaderDesc.attrs[1].sem_name = "COLOR";

			shaderDesc.vs.source = @"""
struct vs_in {
  float4 pos: POS;
  float4 color: COLOR;
};
struct vs_out {
  float4 color: COLOR0;
  float4 pos: SV_Position;
};
vs_out main(vs_in inp) {
  vs_out outp;
  outp.pos = inp.pos;
  outp.color = inp.color;
  return outp;
}
""";
			shaderDesc.fs.source = @"""
float4 main(float4 color: COLOR0): SV_Target0 {
  return color;
}
""";
			break;
		default:
			Console.WriteLine("Unsupported backend");
		}
		shader = Gfx.makeShader(&shaderDesc);

		Gfx.PassDesc passDesc = .();
		//passDesc.color_attachments[0] =

		Gfx.PipelineDesc pipelineDesc = .();
		pipelineDesc.shader = shader;
		pipelineDesc.layout.attrs[0].format = Gfx.VertexFormat.FLOAT3;
		pipelineDesc.layout.attrs[1].format = Gfx.VertexFormat.FLOAT4;
		pipelineDesc.alpha_to_coverage_enabled = true;
		pipeline = Gfx.makePipeline(&pipelineDesc);
	}


	public static void Init()
	{
		_desc.context = Glue.sgcontext();
		Gfx.setup(&_desc);

		_debugTextDesc.context = Glue.sdtxcontext();
		Debugtext.setup(&_debugTextDesc);

		_pass.colors[0] = . { action = .CLEAR, value = . { r = 0, g = 0, b = 0, a = 0 } };

		InitMesh();
		InitShaders();
	}

	public static void Render()
	{
		Debugtext.pos(50, 50);
		Debugtext.puts("Hello!");

		Gfx.beginDefaultPass(&_pass, App.width(), App.height());
		Debugtext.draw();
		Gfx.applyPipeline(pipeline);
		Gfx.applyBindings(&bindings);
		Gfx.draw(0, 3, 1);
		Gfx.endPass();
		Gfx.commit();
	}
}