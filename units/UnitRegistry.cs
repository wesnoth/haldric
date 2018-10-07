using System;
using Godot;
using System.Xml;

public class UnitRegistry
{
	// FIXME: check back as c# support gets shaken out to see if Godot's dictionary starts working
	static readonly System.Collections.Generic.Dictionary<String, XmlDocument> registry = new System.Collections.Generic.Dictionary<String, XmlDocument>();

	private UnitRegistry() { }

	public static void LoadDir(String path)
	{
		foreach (String dir in System.IO.Directory.EnumerateDirectories(path))
        {
            LoadDir(dir);
        }

		foreach (String file in System.IO.Directory.EnumerateFiles(path))
		{
			LoadFile(file);
		}
	}

	public static void LoadFile(String file)
	{
		
		XmlDocument xml = new XmlDocument();
		xml.Load(file);
		String type = xml.DocumentElement.SelectSingleNode("/unit_type/type").InnerText;

		if (!registry.ContainsKey(type))
		{
			registry.Add(type, xml);
		}
		else
		{
			GD.Print("Unit type ", type, " already exists!");
		}
	}

	public static Unit Create(String type, int side, int x, int y)
	{
		if (registry.ContainsKey(type))
		{
			Unit unit = (Unit)((PackedScene)ResourceLoader.Load("res://units/Unit.tscn")).Instance();
			unit.SetAttributes((XmlDocument)registry[type].Clone());
			unit.SetTexture((Texture)ResourceLoader.Load(registry[type].SelectSingleNode("/unit_type/image").InnerText));
			unit.SetSide(side);
			return unit;
		}

		GD.Print("Unknown unit type ", type, "!");
		return null;
	}
}
