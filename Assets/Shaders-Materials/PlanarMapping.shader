Shader "KVY/Planar Mapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f Vertex (float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);
                o.uv = TRANSFORM_TEX(o.worldPos.xz, _MainTex);

                return o;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                fixed3 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
