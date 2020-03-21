Shader "KVY/ColorPosLerp"
{
    Properties
    {
        _Color1 ("Lower Color", Color) = (0, 0, 0, 1)
        _Color2 ("Upper Color", Color) = (1, 1, 1, 1)
        _Origin ("Origin", Float) = 0
        _Spread ("Spread", Float) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #include "Libs/Interpolation.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct input
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 local : TEXCOORD0;
                float4 world : TEXCOORD1;
            };

            fixed4 _Color1, _Color2;
            float _Origin, _Spread;

            v2f vert(input i)
            {
                v2f output;

                output.pos = UnityObjectToClipPos(i.vertex);
                output.local = i.vertex;
                output.world = mul(unity_ObjectToWorld, i.vertex);

                return output;
            }

            fixed4 frag(v2f v) : SV_TARGET
            {
                float t = saturate((v.local.y + _Origin) / remap(_Spread, 0, 1, 0.001, 10));
                return lerp(_Color1, _Color2, t);
            }

            ENDCG
        }
    }
}  
