Shader "KVY/Triplanar Mapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1, 1, 1)
        _Sharpness ("Sharpenss", Range(2, 64)) = 1
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
                float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed3 _Color;
            half _Sharpness;

            v2f Vertex (float4 localPos : POSITION, float3 localNormal : NORMAL)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);

                o.worldNormal = normalize(UnityObjectToWorldNormal(localNormal));

                return o;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                float2 uv_front = TRANSFORM_TEX(i.worldPos.xy, _MainTex);
                float2 uv_side = TRANSFORM_TEX(i.worldPos.zy, _MainTex);
                float2 uv_top = TRANSFORM_TEX(i.worldPos.xz, _MainTex);

                fixed3 col_front = tex2D(_MainTex, uv_front);
                fixed3 col_side = tex2D(_MainTex, uv_side);
                fixed3 col_top = tex2D(_MainTex, uv_top);

                fixed3 weights = abs(i.worldNormal);

                weights = pow(weights, _Sharpness);

                weights = weights / (weights.x + weights.y + weights.z);

                col_front *= weights.z;
                col_side *= weights.x;
                col_top *= weights.y;

                fixed3 col = col_front + col_side + col_top;
                col *= _Color;

                return col;
            }
            ENDCG
        }
    }
}
