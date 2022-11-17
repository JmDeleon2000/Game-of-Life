using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;

public class DataCapture : MonoBehaviour
{
    [SerializeField] string filename;
    [SerializeField] string folder;

    Queue<List<int>> writeQueue = new Queue<List<int>> ();

    public void BeginRecording() => StartCoroutine(
        writer(folder + "/" + filename, 
        writeQueue));
    
    public void EndRecording() => StopAllCoroutines();
    
    public void save(List<int> record) => writeQueue.Enqueue(record);

    IEnumerator writer(string path, Queue<List<int>> WriteQueue)
    {
        using (StreamWriter sw = File.CreateText(path))
        {
            while (true)
            {
                yield return new WaitWhile(() => WriteQueue.Count > 0);
                if (writeQueue.Count > 0)
                {
                    string s = "";
                    foreach (int point in WriteQueue.Dequeue())
                        s += point + ",";
                    //Debug.Log(s);
                    sw.WriteLine(s);
                }
                //yield return new WaitForSecondsRealtime(0.1f);
            }
        }
    }
}
