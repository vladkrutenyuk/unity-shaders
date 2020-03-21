Shader "KVY/Checkerboard Pattern"
{
    Properties
    {
        _Color1 ("First Color", Color) = (0, 0, 0)
        _Color2 ("Second Color", Color) = (1, 1, 1)
        _Scale ("Pattern Scale", Range(0, 10)) = 1
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
                half3 worldPos : TEXCOORD0;
            };

            fixed3 _Color1, _Color2;
            half _Scale;

            v2f Vertex(float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);

                return o;
            }

            fixed3 Pixel(v2f i) : SV_Target
            {
                half3 adjustedWorldPos = floor(i.worldPos * _Scale);
                fixed chessboard = adjustedWorldPos.x + adjustedWorldPos.y + adjustedWorldPos.z;
                chessboard = frac(chessboard / 2) * 2;
                
                return lerp(_Color1, _Color2, chessboard);
            }
            ENDCG
        }
    }
}
