Shader "KVY/Pyramid_ColorInterpolation"
{
    Properties
    {
        _ColorZ1 ("Color Z1", Color) = (0, 0, 1)
        _ColorZ2 ("Color Z2", Color) = (1, 0, 1)
        _ColorX1 ("Color X1", Color) = (0, 1, 1)
        _ColorX2 ("Color X2", Color) = (1, 1, 1)
        _Value("Value", Range(0, 1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Pixel

            #include "UnityCG.cginc"
            #include "Assets/Shaders-Materials/Libs/HSVLibrary.cginc"

            struct input    
            {
                float4 localPos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {   
                float4 svPos : SV_POSITION;
                float2 uv : TEXCOORD0;

                half3 localPos : TEXCOORD1;
                half3 worldPos : TEXCOORD2;
            };

            fixed3 _ColorZ1, _ColorZ2, _ColorX1, _ColorX2;
            float _Value;

            v2f Vertex (input i)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(i.localPos);
                o.uv = i.uv;

                o.localPos = i.localPos;
                o.worldPos = mul(unity_ObjectToWorld, i.localPos);

                return o;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {

                fixed weightZ1 = dot(normalize(i.localPos.xy), float2(0, 1));
                weightZ1 = saturate(weightZ1);
                fixed weightZ2 = dot(normalize(i.localPos.xy), float2(0, -1));
                weightZ2 = saturate(weightZ2);
                fixed weightX1 = dot(normalize(i.localPos.xy), float2(1, 0));
                weightX1 = saturate(weightX1);
                fixed weightX2 = dot(normalize(i.localPos.xy), float2(-1, 0));
                weightX2 = saturate(weightX2);

                fixed3 colZ = _ColorZ1 * weightZ1 + _ColorZ2 * weightZ2;
                fixed3 colX = _ColorX1 * weightX1 + _ColorX2 * weightX2;

                half3 colZ_hsv = rgb2hsv(colZ);
                half3 colX_hsv = rgb2hsv(colX);

                fixed3 col = lerp(colX_hsv, colZ_hsv, weightZ1 + weightZ2);

                col = hsv2rgb(col);

                return col;
            }
            ENDCG
        }
    }
}
