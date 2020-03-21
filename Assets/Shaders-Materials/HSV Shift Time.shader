Shader "KVY/HSV Shift Time"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Lerp("Lerp", Range(0, 1)) = 0
        _MultTime("Mult Time", Range(-10, 10)) = 1
        _MultUV("Mult UV", Range(0, 100)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #include "Libs/HSVLibrary.cginc"

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
            half _Lerp, _MultTime, _MultUV;

            v2f vert(input i)
            {
                v2f output;

                output.pos = UnityObjectToClipPos(i.vertex);
                output.uv = i.uv;

                return output;
            }

            fixed4 frag(v2f v) : SV_TARGET
            {
                fixed3 col = tex2D(_MainTex, v.uv);
                half3 hsv = rgb2hsv(col.rgb);
                hsv.x = v.uv.y * _MultUV + _Time.y * _MultTime;
                fixed3 newCol = hsv2rgb(hsv);
                col = lerp(col, newCol, _Lerp);
                return float4(col, 1);

                // ----------------------------------- HUE by UV
                // fixed3 col = hue2rgb(v.uv);
                // return fixed4(col, 1);

                // ----------------------------------- HSV by UV
                // fixed3 col = hsv2rgb(float3(v.uv.y - v.uv.x, v.uv.x, v.uv.y));
                // return fixed4(col, 1);
            }

            ENDCG
        }
    }
}
