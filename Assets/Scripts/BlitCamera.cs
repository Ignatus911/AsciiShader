using UnityEngine;

public class BlitCamera : MonoBehaviour
{
    [SerializeField]
    private Material material;

    private void Update()
    {
        material.SetFloat("Width", Screen.width);
        material.SetFloat("Height", Screen.height);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
