Shader "KVY/TemplateVF - Pos & Normal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            struct input    
            {
                float4 localPos : POSITION;
                float2 uv : TEXCOORD0;
                float3 localNormal : TEXCOORD1;
            };

            struct v2f
            {   
                float4 svPos : SV_POSITION;
                float2 uv : TEXCOORD0;

                half3 localPos : TEXCOORD1;
                half3 worldPos : TEXCOORD2;
                half3 localNormal : TEXCOORD3;
                half3 worldNormal : TEXCOORD4;
            };

            sampler2D _MainTex;
            fixed3 _Color;

            v2f Vertex (input i)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(i.localPos);
                o.uv = i.uv;

                o.localPos = i.localPos;
                o.worldPos = mul(unity_ObjectToWorld, o.localPos);
                o.localNormal = i.localNormal;
                o.worldNormal = UnityObjectToWorldNormal(i.localNormal);

                return o;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                fixed3 col = _Color * tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
