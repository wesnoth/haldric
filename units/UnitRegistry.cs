using System;
using Godot;
using System.Xml;
using System.Xml.Schema;

public class UnitRegistry
{
	private const String XSD = "units/Units.xsd";

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
		XmlReaderSettings settings = new XmlReaderSettings();
		settings.ValidationType = ValidationType.Schema;
		settings.ValidationFlags |= XmlSchemaValidationFlags.ReportValidationWarnings;
		settings.ValidationEventHandler += ValidationHandler;
		settings.Schemas.Add(String.Empty, XSD);

		XmlDocument xml = new XmlDocument();
		xml.Load(XmlReader.Create(file, settings));

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

	static void ValidationHandler(object sender, ValidationEventArgs args)
	{
		if (args.Severity == XmlSeverityType.Warning)
		{
			GD.Print("The following validation warning occurred: " + args.Message);
		}
		else if (args.Severity == XmlSeverityType.Error)
		{
			GD.Print("The following critical validation errors occurred: " + args.Message);
		}
	}

	public static Unit Create(String type, int side, int x, int y)
	{
		if (registry.ContainsKey(type))
		{
			Unit unit = (Unit)((PackedScene)ResourceLoader.Load("res://units/Unit.tscn")).Instance();
			unit.SetAttributes((XmlDocument)registry[type].Clone());
			unit.SetTexture((Texture)ResourceLoader.Load("res://" + registry[type].SelectSingleNode("/unit_type/image").InnerText));
			unit.SetSide(side);
			return unit;
		}

		GD.Print("Unknown unit type ", type, "!");
		return null;
	}
}
