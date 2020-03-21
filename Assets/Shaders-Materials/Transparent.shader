Shader "KVY/Transparent"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _AlphaCutout("Alpha cutout", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Trasnparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct input
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _AlphaCutout;

            v2f vert(input i)
            {
                v2f output;

                output.pos = UnityObjectToClipPos(i.vertex);
                output.uv = i.uv;

                return output;
            }

            fixed4 frag(v2f v) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, v.uv * _MainTex_ST.xy + _MainTex_ST.zw);
                // clip(col.a - _AlphaCutout);
                return col;
            }

            ENDCG
        }
    }
}
