using UnityEngine;

[ExecuteInEditMode]
public class PostEffectScript : MonoBehaviour
{
    [SerializeField] Material _material;
    public void OnRenderImage(RenderTexture src, RenderTexture dest) 
    {
        // WORKS ONLY ON STANDART RENDER PIPELINE !!!
        Graphics.Blit(src, dest, _material);
    }
}
