Shader "KVY/08_HSV_ColorCorrection"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _HueShift("Hue Shift", Range(0, 1)) = 0
        _Saturation("Saturation", Range(-4, 5)) = 1
        _Brightness("Brightness", Range(-4, 5)) = 1
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
            half _HueShift, _Saturation, _Brightness;

            v2f vert(input i)
            {
                v2f output;

                output.pos = UnityObjectToClipPos(i.vertex);
                output.uv = i.uv;

                return output;
            }

            fixed4 frag(v2f v) : SV_TARGET
            {
                float3 col = tex2D(_MainTex, v.uv);
                float3 hsv = rgb2hsv(col);
                hsv.x += _HueShift;
                hsv.y = pow(hsv.y, _Saturation);
                hsv.z = pow(hsv.z, _Brightness);
                col = hsv2rgb(hsv);
                return fixed4(col, 1);
            }

            ENDCG
        }
    }
}
