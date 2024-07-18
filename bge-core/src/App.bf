using System;
using sokol;
namespace bge_core;

static class Application
{
	
	public static String s_app_name;


	private static void Init()
	{
		System.Console.WriteLine($"App Name : {s_app_name} : Init()");

		Renderer.Init();
	}

	private static void OnFrame()
	{
		Renderer.Render();
	}

	private static void OnEvent(App.Event* _event)
	{

	}

	private static void OnFail(char8* msg)
	{
		Console.WriteLine(msg);
	}

	private static App.Desc CreateAppDescription()
	{
		App.Desc desc = .();

		desc.init_cb = => Init;
		desc.frame_cb = => OnFrame;
		desc.event_cb = => OnEvent;
		desc.cleanup_cb = => Shutdown;
		desc.fail_cb = => OnFail;
		desc.window_title = s_app_name;

		return desc;
	}
	public static void Run(String appName)
	{
		s_app_name = appName;
		System.Console.WriteLine($"App Name : {s_app_name} : Run()");
		App.Desc app_description = CreateAppDescription();
		App.run(&app_description);
	}

	public static void Shutdown()
	{
		System.Console.WriteLine($"App Name : {s_app_name} : Shutdown()");
		Gfx.shutdown();
	}

	
}