Shader "KVY/Fresnel"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1)
        _FresnelColor("Fresnel Color", Color) = (0, 0, 0)
        _FresnelPower("Fresnel Power", Float) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct input
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float fresnel : TEXCOORD0;
            };

            fixed3 _Color;
            fixed3 _FresnelColor;
            half _FresnelPower;

            v2f vert(input i)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(i.vertex);

                o.normal = normalize(UnityObjectToWorldNormal(i.normal));      
                float3 viewDir = normalize(WorldSpaceViewDir(i.vertex));
                
                o.fresnel = pow(1 - dot(viewDir, o.normal), _FresnelPower);

                return o;
            }

            fixed3 frag(v2f v) : SV_TARGET
            {
                return lerp(_Color, _FresnelColor, v.fresnel);
            }

            ENDCG
        }
    }
}