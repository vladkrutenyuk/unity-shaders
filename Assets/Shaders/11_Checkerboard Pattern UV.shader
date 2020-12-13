Shader "KVY/11_CheckerboardPattern_UV"
{
    Properties
    {
        _Color1 ("First Color", Color) = (0, 0, 0)
        _Color2 ("Second Color", Color) = (1, 1, 1)
        _Scale ("Pattern Scale", Range(0, 100)) = 1
        _UVColorValue ("UV Color value", Range(0, 1)) = 1
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
                float2 uv : TEXCOORD1;

                half3 worldPos : TEXCOORD0;
            };

            fixed3 _Color1, _Color2;
            half _Scale, _UVColorValue;

            v2f Vertex(float4 localPos : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;

                o.uv = uv;
                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);

                return o;
            }

            fixed3 Pixel(v2f i) : SV_Target
            {
                half2 adjustedUV = floor(i.uv * _Scale);
                fixed chessboard = adjustedUV.x + adjustedUV.y;
                chessboard = frac(chessboard / 2) * 2;
                
                return lerp(_Color1, _Color2, chessboard) * lerp(1, half3(i.uv, 0.5), _UVColorValue);
            }
            ENDCG
        }
    }
}
