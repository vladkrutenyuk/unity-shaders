Shader "KVY/Depth"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base Color", 2D) = "white" {}
        _DepthStart ("Depth Start", Float) = 1.0
        _DepthEnd ("Depth End", Float) = -50.0
    }

    SubShader
    {
        Pass
        {
            ZWrite On

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            struct vertexInput
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0; 
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0; 
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            float
                _DepthStart,
                _DepthEnd;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                
                output.pos = UnityObjectToClipPos(input.pos);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag(vertexOutput output) : SV_TARGET
            {
                // return _Color * smoothstep(_DepthStart, _DepthEnd, output.pos.z);
                return tex2D(_MainTex, output.uv * _MainTex_ST.xy + _MainTex_ST.zw)
                    * smoothstep(_DepthStart, _DepthEnd, output.pos.z) * _Color;
            }

            ENDCG
        }
    }
}