using UnityEngine;

[ExecuteInEditMode]
public class PolygonClipping : MonoBehaviour
{
    [SerializeField] private MeshRenderer _meshRenderer;
    [SerializeField] private Transform[] _vertex;

    private void Start()
    {
        UpdateMaterial();
    }

    private void Update() 
    {
        UpdateMaterial();
    }

    private void UpdateMaterial()
    {      
        Vector4[] pointsVector4 = new Vector4[100];

        for (int i = 0; i < _vertex.Length; i++)
        {
            pointsVector4[i] = new Vector2(_vertex[i].localPosition.x, _vertex[i].localPosition.z);
        }

        _meshRenderer.material.SetInt("_pointsCount", _vertex.Length);
        _meshRenderer.material.SetVectorArray("_points", pointsVector4);
    }
}
