using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Conways : MonoBehaviour
{
    [SerializeField] Material material;
    [SerializeField] MeshRenderer renderer;
    [SerializeField] DataCapture capture;



    private void Awake()
    {
        tex = new Texture2D(1920, 1080,
            TextureFormat.RGB24, false);
        capture.BeginRecording();
    }

    [SerializeField] int threshold = 100;
    [SerializeField] int maxiter = 1000;

    int iter = 0;

    MaterialPropertyBlock _MPB; 
    MaterialPropertyBlock MPB
    {
        get
        {
            if (_MPB == null)
                _MPB = new MaterialPropertyBlock();
            return _MPB;
        }
    }

    List<int> record = new List<int>();

    Texture2D tex; 
    int xOffId = Shader.PropertyToID("_Offsetx");
    int yOffId = Shader.PropertyToID("_Offsety");
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        tex.ReadPixels(new Rect(0, 0, source.width, source.height), 0, 0);

        RenderTexture.active = source;
        //Camera.main.Render();
        Color32[] data = tex.GetPixels32();
        int count = 0;
        foreach (Color32 col in data) 
        {
            if (col.r * col.g * col.b > 0) 
                count++;
        }
        record.Add(count);
        iter++;
        if (count < threshold || iter > maxiter)
        {
            iter = 0;

            MPB.SetFloat(xOffId, Random.Range(0.0f, 1.0f));
            MPB.SetFloat(yOffId, Random.Range(0.0f, 1.0f));

            renderer.SetPropertyBlock(MPB);
            capture.save(new List<int>(record));
            record.Clear();

            Graphics.Blit(source, source, renderer.material);
        }



        Graphics.Blit(source, destination, material);
    }
}
