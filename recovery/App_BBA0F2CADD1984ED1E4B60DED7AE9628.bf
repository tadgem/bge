using System;
using sokol;
namespace bge_core;

static class Application
{
	static Gfx.Desc _desc = .();
	static Gfx.PassAction _pass = .();
	static Gfx.Shader shader = .();
	static Gfx.Pipeline pipeline = .();
	static Gfx.Bindings bindings = .();
	public static String s_app_name;


	internal static void Init()
	{
		System.Console.WriteLine($"App Name : {s_app_name} : Init()");

		_desc.context = Glue.sgcontext();
		Gfx.setup(&_desc);
		_pass.colors[0] = .{ action = .CLEAR, value = .{ r=0, g=0, b=0, a=1 } };

		float[21] vertices = .(
		    // positions            // colors
		     0.0f,  0.5f, 0.5f,     1.0f, 0.0f, 0.0f, 1.0f,
		     0.5f, -0.5f, 0.5f,     0.0f, 1.0f, 0.0f, 1.0f,
		    -0.5f, -0.5f, 0.5f,     0.0f, 0.0f, 1.0f, 1.0f
		);
		Gfx.BufferDesc bufferDesc = .();
		bufferDesc.data = Gfx.asRange<float>(vertices);
		Gfx.Buffer buffer = Gfx.makeBuffer(&bufferDesc);

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

		Gfx.PipelineDesc pipelineDesc = .();
		pipelineDesc.shader = shader;
		pipelineDesc.layout.attrs[0].format = Gfx.VertexFormat.FLOAT3;
		pipelineDesc.layout.attrs[1].format = Gfx.VertexFormat.FLOAT4;
		pipeline = Gfx.makePipeline(&pipelineDesc);

		bindings.vertex_buffers[0] = buffer;
	}

	static void OnFrame()
	{
		let g = _pass.colors[0].value.g + 0.0001f;
		_pass.colors[0].value.g = g > 1.0f ? 0.0f : g;
		Gfx.beginDefaultPass(&_pass, App.width(), App.height());
		Gfx.applyPipeline(pipeline);
		Gfx.applyBindings(&bindings);
		Gfx.draw(0, 3, 1);
		Gfx.endPass();
		Gfx.commit();
	}

	static void OnEvent(App.Event* _event)
	{

	}

	static void OnFail(char8* msg)
	{
		Console.WriteLine(msg);
	}

	public static void Run(String appName)
	{
		s_app_name = appName;
		System.Console.WriteLine($"App Name : {s_app_name} : Run()");
		App.Desc desc = .();

		desc.init_cb = => Init;
		desc.frame_cb = => OnFrame;
		desc.event_cb = => OnEvent;
		desc.cleanup_cb = => Shutdown;
		desc.fail_cb = => OnFail;
		desc.window_title = s_app_name;
		App.run(&desc);
	}

	public static void Shutdown()
	{
		System.Console.WriteLine($"App Name : {s_app_name} : Shutdown()");
		Gfx.shutdown();
	}

	
}