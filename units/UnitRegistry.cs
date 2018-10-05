using System;
using Godot;

public class UnitRegistry
{
	// FIXME: Godot.Dictionary currently crashes with: "drivers/unix/stream_peer_tcp_posix.cpp:276 - Server disconnected!"
	static readonly System.Collections.Generic.Dictionary<String, System.Collections.Generic.Dictionary<String, String>> registry = new System.Collections.Generic.Dictionary<String, System.Collections.Generic.Dictionary<String, String>>();

	private UnitRegistry() { }

	public static void LoadDir(String path)
	{
		foreach (String file in System.IO.Directory.EnumerateFiles(path))
		{
			LoadFile(file);
		}
	}

	public static void LoadFile(String file)
	{
		using (XMLParser xml = new XMLParser())
		{
			xml.Open(file);

			System.Collections.Generic.Dictionary<String, String> attributes = new System.Collections.Generic.Dictionary<String, String>();
			String previous_tag = "";
			Godot.Error reading = Godot.Error.Ok;
			while (reading == Godot.Error.Ok)
			{
				if (xml.GetNodeType() == XMLParser.NodeType.Element)
				{
					previous_tag = xml.GetNodeName();
				}
				if (xml.GetNodeType() == XMLParser.NodeType.Text && xml.GetNodeData().Trim().Length() > 0)
				{
					attributes[previous_tag] = xml.GetNodeData().Trim();
				}

				reading = xml.Read();
			}

			if (!registry.ContainsKey(attributes["type"]))
			{
				registry.Add(attributes["type"], attributes);
			}
			else
			{
				GD.Print("Unit type ", attributes["type"], " already exists!");
			}
		}
	}

	public static Unit Create(String type, Terrain map, int side, int x, int y)
	{
		if (registry.ContainsKey(type))
		{
			Unit unit = (Unit)((PackedScene)ResourceLoader.Load("res://units/Unit.tscn")).Instance();
			// TODO: deep copy, or wait for Duplicate() method once Godot.Dictionary is fixed
			unit.SetAttributes(registry[type]);
			unit.SetTexture((Texture)ResourceLoader.Load(registry[type]["image"]));
			unit.SetSide(side);
			unit.SetPosition(map.MapToWorldCentered(new Vector2(x, y)));
			return unit;
		}

		GD.Print("Unknown unit type ", type, "!");
		return null;
	}
}
