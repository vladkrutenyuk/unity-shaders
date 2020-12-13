Shader "KVY/TemplateVF"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Pixel

            #include "UnityCG.cginc"

            struct v2f
            {   
                float4 svPos : SV_POSITION;
            };

            fixed3 _Color;

            v2f Vertex (float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);

                return o;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
