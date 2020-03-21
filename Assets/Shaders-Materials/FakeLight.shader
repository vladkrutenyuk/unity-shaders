Shader "KVY/FakeLight"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1)
        _ShadowColor("Shadow Color", Color) = (0, 0, 0)
        _SunPos("Sun Position", Range(0,1)) = 0
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

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
            };

            fixed3 _Color;
            fixed3 _ShadowColor;
            half _SunPos;

            v2f vert(input i)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(i.vertex);
                o.normal = i.normal;
                
                return o;
            }
            fixed3 frag(v2f v) : SV_TARGET
            {
                return lerp(_ShadowColor, _Color, lerp(v.normal.x, 1 - v.normal.z, _SunPos));
            }

            ENDCG
        }
    }
}