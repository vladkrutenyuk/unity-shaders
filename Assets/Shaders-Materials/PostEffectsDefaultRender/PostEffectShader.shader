Shader "Hidden/PostEffect"
{
    Properties
    {
        _MainTex("Render Image", 2D) = "white" {}
        _Value("Value", Range(0, 1)) = 0
        _ValueUV("Value UV", Range(0, 1)) = 0
    }
    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

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
            };

            sampler2D _MainTex;
            float _Value, _ValueUV;

            v2f Vertex (float4 localPos : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.uv = uv;

                return o;
            }

            fixed4 Pixel (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                uv = uv + float2(0, sin(i.svPos.x/10 + _Time[2] * 5)/50);

                fixed4 col = tex2D(_MainTex, lerp(i.uv, uv + distance(i.svPos, float2(500, 500)) * 0.0005, _ValueUV));
                
                return lerp(col, 1 - col, _Value);
            }
            ENDCG
        }
    }
}
