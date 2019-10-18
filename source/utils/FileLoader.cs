using Godot;
using System;
using System.Linq;
using Godot.Collections;

public class FileLoader
{
    public static Array<FileData> LoadDirectory(string path, string[] extentions, bool loadResource)
    {
        return GetDirectoryData(path, new Array<FileData>(), extentions, loadResource);
    }

    private static Array<FileData> GetDirectoryData(string path, Array<FileData> directoryData, string[] extentions, bool loadResource)
    {
        var directory = new Directory();
        
        if (!(directory.Open(path) == Error.Ok))
        {
            GD.Print("FileLoader: failed to load " + path + ", return null (Open");
            return null;
        }

        if (!(directory.ListDirBegin(true, true) == Error.Ok))
        {
            GD.Print("FileLoader: failed to load " + path + ", return null (ListDirBegin)");
            return null;
        }

        var subPath = "";

        while (true)
        {
            subPath = directory.GetNext();

            if (subPath.Equals(".") || subPath.Equals("..") || subPath.BeginsWith("_"))
            {
                continue;
            }
            else if (subPath.Empty())
            {
                break;
            }
            else if (directory.CurrentIsDir())
            {
                directoryData = GetDirectoryData(directory.GetCurrentDir() + "/" + subPath, directoryData, extentions, loadResource);
            }
            else
            {
                if (!extentions.Contains(subPath.GetFile().Extension()))
                {
                    continue;
                }

                var fileData = GetFileData(directory.GetCurrentDir() + "/" + subPath, loadResource);
                directoryData.Add(fileData);
            }
        }
        
        directory.ListDirEnd();

        return directoryData;
    }

    private static FileData GetFileData(string path, bool loadResource)
    {
        FileData fileData = new FileData();
        
        fileData.id = path.GetFile().BaseName();
        fileData.path = path;
        
        if (loadResource)
        {
            fileData.data = GD.Load(path);

            if (fileData.data == null)
            {
                GD.Print("FileLoader: could not load resource: " + path);
            }
        }
        else
        {
            fileData.data = null;
        }

        return fileData;
    }
}
