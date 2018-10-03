using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public class Terrain : TileMap
{
    private const int width = 20;
    private const int height = 15;

    Vector2 offset = new Vector2(36, 36);

    Vector2[][] neighborTable = new Vector2[][] { 
        new Vector2[] { 
            new Vector2(+1,  0), // SE
            new Vector2(+1, -1), // NE
            new Vector2(0, -1), // N
            new Vector2(-1, -1), // NW
            new Vector2(-1,  0), // SW
            new Vector2(0, +1) // S
        }, 
        new Vector2[] { 
            new Vector2(+1, +1), // SE
            new Vector2(+1,  0), // NE
            new Vector2(0, -1), // N
            new Vector2(-1,  0), // NW
            new Vector2(-1, +1), // SW
            new Vector2( 0, +1) // S 
        }
    };
    
    private Godot.Dictionary<int, Tile> tiles = new Godot.Dictionary<int, Tile>();

    private Godot.AStar grid = new Godot.AStar();

    private List<Vector2> path = new List<Vector2>();

    private Unit unit;
    public override void _Ready()
    {
        unit = (Unit) GetNode("../Sprite");
        GenerateTiles();
        GeneratePoints();
        GeneratePointConnections(); 
    }

    public List<Vector2> FindPathByPosition(Vector2 startPosition, Vector2 endPosition)
    {
        Vector2 startCell = WorldToMap(startPosition);
        Vector2 endCell = WorldToMap(endPosition);
        return FindPathByCell(startCell, endCell);
    }

    public List<Vector2> FindPathByCell(Vector2 startCell, Vector2 endCell)
    {
        Vector3[] path3D = grid.GetPointPath(FlattenV(startCell), FlattenV(endCell));
        List<Vector2> path2D = new List<Vector2>();
        foreach (Vector3 p in path3D)
        {
            path2D.Add(new Vector2(p.x, p.y));
            if (path2D.Count == 0)
            {
                path2D.RemoveAt(0);
            }
        }
        return path2D;
    }

    public List<Vector2> GetReachableCellsU(Unit unit)
    {
        List<Vector2> reachable = GetReachableCells(WorldToMap(unit.GetPosition()), unit.GetMovesMax());
        return reachable;
    }

    public List<Vector2> GetReachableCells(Vector2 startCell, int range)
    {
        List<Vector2> reachable = new List<Vector2>();
        Vector3 startCube = V2ToV3(startCell);

        foreach (Vector2 cell in GetUsedCells())
        {
            Vector3 cube = V2ToV3(cell);
            float diff_x = Mathf.Abs(startCube.x - cube.x);
            float diff_y = Mathf.Abs(startCube.y - cube.y);
            float diff_z = Mathf.Abs(startCube.z - cube.z);
            if(Mathf.Max(Mathf.Max(diff_x, diff_y), diff_z) > range || tiles[FlattenV(cell)].isBlocked)
            {
                continue;
            }
            reachable.Add(cell);
        }
        return reachable;
    }

    public Vector2 MapToWorldCentered(Vector2 cell)
    {
        return MapToWorld(cell) + offset;
    }

    public Vector2 WorldToWorldCentered(Vector2 position)
    {
        return MapToWorldCentered(WorldToMap(position));
    }

    public Unit GetUnit() 
    {
        return unit;
    }

    private void GenerateTiles()
    {
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int id = Flatten(x, y);
                tiles[id] = new Tile(new Vector2(x, y), GetCell(x, y));
            }
        }
    }

    private void GeneratePoints()
    {
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                Vector2 cell = new Vector2(x, y);
                int id = Flatten(x, y);
                grid.AddPoint(id, new Vector3(x, y, 0));
            }
        }
    }

    private void GeneratePointConnections()
    {
         for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                Vector2 cell = new Vector2(x, y);
                ConnectWithNeigbors(cell);
            }
        }
    }

    private void ConnectWithNeigbors(Vector2 cell)
    {
        int id = FlattenV(cell);
        List<Vector2> neighbors = new List<Vector2>();
        foreach (Vector2 n in neighbors) 
        {
            int nId = Flatten(n.x, n.y);
            if (CheckBoundaries(n) && !grid.ArePointsConnected(id, nId)) 
            {
                if (!tiles[id].isBlocked && !tiles[nId].isBlocked) 
                {
                    grid.ConnectPoints(id, nId);
                }
            }
        }
    }

    private List<Vector2> GetNeighbors(Vector2 cell)
    {
        List<Vector2> neighbors = new List<Vector2>();
        int parity = (int) cell.x & 1;

        foreach (Vector2 n in neighborTable[parity]) 
        {
            neighbors.Add(cell + n);
        }
        return neighbors;
    }

    private Vector2 V3ToV2(Vector3 v3)
    {
        float y = v3.x;
        float x = v3.z + (v3.x - ((int) v3.x & 1)) / 2;
        return new Vector2(x, y);
    }

    private Vector3 V2ToV3(Vector2 v2) {
        float x = v2.x;
        float z = v2.y - (v2.x - ((int) v2.x & 1)) / 2;
        float y = -x - z;
        return new Vector3(x, y, z);
    }

    private int Flatten(int x, int y)
    {
        return y * width + x;
    }

    private int Flatten(double x, double y)
    {
        return (int) (y * width + x);
    }
    
    private int FlattenV(Vector2 cell)
    {
        return (int) (cell.y * width + cell.x);
    }

    private bool CheckBoundaries(Vector2 cell) 
    {
        return cell.x >= 0 && cell.y >= 0 && cell.x < width && cell.y < height;
    }
}
