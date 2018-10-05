using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

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

	private AStar grid = new AStar();

	public override void _Ready()
	{
		GenerateTiles();
		GeneratePoints();
		GeneratePointConnections(); 
	}

	public Godot.Dictionary<int, Tile> GetTiles()
	{
		return tiles;
	}

	public IList<Vector2> FindPathByPosition(Vector2 startPosition, Vector2 endPosition)
	{
		Vector2 startCell = WorldToMap(startPosition);
		Vector2 endCell = WorldToMap(endPosition);
		return FindPathByCell(startCell, endCell);
	}

	public IList<Vector2> FindPathByCell(Vector2 startCell, Vector2 endCell)
	{
		Vector3[] path3D = grid.GetPointPath(FlattenV(startCell), FlattenV(endCell));
		IList<Vector2> path2D = path3D.Select(p => new Vector2(p.x, p.y)).ToList();
		GD.Print(path3D.Length, ", ", path2D.Count);
		return path2D;
	}

	public IList<Vector2> GetReachableCellsU(Unit unit)
	{
		IList<Vector2> reachable = new List<Vector2>();
		if (unit != null)
		{
			reachable = GetReachableCells(WorldToMap(unit.GetPosition()), unit.GetMovesMax());
		}
		return reachable;
	}

	public IList<Vector2> GetReachableCells(Vector2 startCell, int range)
	{
		IList<Vector2> reachable = new List<Vector2>();
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

	public bool AreNeighbors(Vector2 cell1, Vector2 cell2)
	{
		IList<Vector2> cell1Neighbors = GetNeighbors(cell1);
		
		foreach(Vector2 n in cell1Neighbors)
		{
			if (cell2 == n)
			{
				return true;
			}
		}
		return false;
	}
	public void UnblockCell(Vector2 cell)
	{
		tiles[FlattenV(cell)].isBlocked = false;
	}

	public void BlockCell(Vector2 cell)
	{
		tiles[FlattenV(cell)].isBlocked = true;
	}
	
	public void ConnectCell(Vector2 cell)
	{
		ConnectWithNeigbors(cell);
	}

	public void DisconnectCell(Vector2 cell)
	{
		DisconnectWithNeighbors(cell);
	}

	public Vector2 MapToWorldCentered(Vector2 cell)
	{
		return MapToWorld(cell) + offset;
	}

	public Vector2 WorldToWorldCentered(Vector2 position)
	{
		return MapToWorldCentered(WorldToMap(position));
	}

	public int Flatten(int x, int y)
	{
		return y * width + x;
	}

	public int Flatten(double x, double y)
	{
		return (int) (y * width + x);
	}
	
	public int FlattenV(Vector2 cell)
	{
		return (int) (cell.y * width + cell.x);
	}

	public bool CheckBoundaries(Vector2 cell) 
	{
		return cell.x >= 0 && cell.y >= 0 && cell.x < width && cell.y < height;
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
		IList<Vector2> neighbors = GetNeighbors(cell);
		foreach (var n in neighbors) 
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

	private void DisconnectWithNeighbors(Vector2 cell)
	{
		int id = FlattenV(cell);
		IList<Vector2> neighbors = GetNeighbors(cell);
		foreach (var n in neighbors)
		{
			int nId = FlattenV(n);
			if (CheckBoundaries(n) && grid.ArePointsConnected(id, nId))
			{
				grid.DisconnectPoints(id, nId);
			}
		}
	}

	private IList<Vector2> GetNeighbors(Vector2 cell)
	{
		IList<Vector2> neighbors = new List<Vector2>();
		int parity = (int) cell.x & 1;

		foreach (var n in neighborTable[parity]) 
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
}
