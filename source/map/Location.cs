using Godot;
using System;

public class Location : Godot.Object
{
    private Vector2 quadCell;
    private Vector3 cubeCell;

    private Vector2 position;
    
    private Terrain terrain;

    public Vector2 QuadCell {
        get { return quadCell; }
        set { quadCell = value; }
    }

    public Vector3 CubeCell {
        get { return cubeCell; }
        set { cubeCell = value; }
    }

    public Vector2 Position {
        get { return position; }
        set { position = value; }
    }

    public Terrain Terrain {
        get { return terrain; }
        set { terrain = value; }
    }
}
