using Godot;
using Godot.Collections;
using System;

public class Hex : Node
{
    // public enum Direction { N, NE, SE, S, SW, NW }
    public enum Direction { S, SW, NW, N, NE, SE }
    
    public static Dictionary<Direction, string> Directions = new Dictionary<Direction, string>() 
    {
        {Direction.S, "s"},
        {Direction.SW, "sw"},
        {Direction.NW, "nw"},
        {Direction.N, "n"},
        {Direction.NE, "ne"},
        {Direction.SE, "se"},
    };

    private static Vector2[][] neighborTable = {
        // ODD COL
        new Vector2[] {
            new Vector2(0, 1), // S
            new Vector2(-1, 1), // SW
            new Vector2(-1, 0), // NW
            new Vector2(0, -1), // N
            new Vector2(1, 0), // NE
            new Vector2(1, 1), // SW
        },
        new Vector2[] {
            new Vector2(0, 1), // S
            new Vector2(-1, 0), // SW
            new Vector2(-1, -1), // NW
            new Vector2(0, -1), // N
            new Vector2(1, -1), // NE
            new Vector2(1, 0), // SE
        },
        // EVEN COL
    };

    public static Vector2[] GetNeighbors(Vector2 cell)
    {
        Vector2[] neighbors = new Vector2[6];
        
        for (int i = 0; i < 6; i++)
        {
            neighbors[i] = GetNeighbor(cell, i);
        }

        return neighbors;
    }
    
    public static Vector2 GetNeighbor(Vector2 cell, int direction)
    {
        var parity = (int) cell.x & 1;
        var dir = neighborTable[parity][direction];
        return new Vector2(cell.x + dir.x, cell.y + dir.y);
    }

    public static Vector2 Cube2Quad(Vector3 cube)
    {
        var col = cube.x;
        var row = cube.z + (cube.x + ((int) cube.x & 1)) / 2;
        return new Vector2(col, row);
    }

    public static Vector3 Quad2Cube(Vector2 quad)
    {
        var x = quad.x;
        var z = quad.y - (quad.x + ((int) quad.x & 1)) / 2;
        var y = -x-z;
        return new Vector3(x, y, z);
    }
}
