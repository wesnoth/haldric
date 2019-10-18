using Godot;
using Godot.Collections;
using System;

public class Terrain : Godot.Object
{

    public string BaseCode { get { return code[0]; }  }
    public string OverlayCode { get { return code[1]; } }

    public Array<string> Code { get { return code; } }
        
    private int layer = 0;
    private Array<string> code = new Array<string>();
    private Array<string> type = new Array<string>();

    private string name = "";

    private bool recruitOnto = false;
    private bool recruitFrom = false;

    private bool givesIncome = false;
    private bool heals = false;

    private bool submerge = false;

    public Terrain(Array<TerrainType> terrains)
    {
        int i = 0;

        foreach (var terrain in terrains)
        {
            name = terrain.name;

            layer = terrain.layer;

            code.Add(terrain.code);
            type.Add(terrain.type);

            recruitOnto = terrain.recruitOnto;
            recruitFrom = terrain.recruitFrom;

            givesIncome = terrain.givesIncome;

            heals = terrain.heals;

            submerge = terrain.submerge;

            i++;
        }
    }
}
