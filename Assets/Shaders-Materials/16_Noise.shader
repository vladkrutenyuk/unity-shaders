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
                float3 worldPos : TEXCOORD0;
            };

            fixed3 _Color;

            v2f Vertex (float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);

                return o;
            }

            float3 random(float3 value)
            {
                //make value smaller to avoid artefacts
                float3 smallValue = sin(value);
                //get scalar value from 3d vector
                float rand = dot(smallValue, float3(12.9898, 78.233, 37.719));
                //make value more random by making it bigger and then taking teh factional part
                rand = frac(sin(rand) * 143758.5453);

                return rand;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                fixed3 value = i.worldPos;
                return random(value);
            }
            ENDCG
        }
    }
}
