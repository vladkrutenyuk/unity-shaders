using UnityEngine;

public class HeatMapRegions : MonoBehaviour
{
    [SerializeField] private MeshRenderer _meshRenderer;

    [Header("(x, z, radius, intensity)")]
    [SerializeField] private Vector4[] _points;

    private void Start()
    {
        SetHeatMap();
    }

    private void OnValidate() 
    {
        SetHeatMap();
    }

    private void SetHeatMap()
    {
        Vector4[] pointsVector4 = new Vector4[50];

        for (int i = 0; i < _points.Length; i++)
        {
            pointsVector4[i] = _points[i];
        }

        Shader.SetGlobalInt("_PointsLength", _points.Length);
        Shader.SetGlobalVectorArray("_Points", pointsVector4);
        // _meshRenderer.material.SetInt("_PointsLength", _points.Length);
        // _meshRenderer.material.SetVectorArray("_Points", pointsVector4);
    }
}
