Shader "KVY/02_WorldLocalSpace"
{
    Properties
    {
        _Brightness ("Brightness", Float) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct vertexInput
            {
                float4 pos : POSITION;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 world : TEXCOORD0;
                float4 local : TEXCOORD1;
            };

            half _Brightness;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;

                output.pos = UnityObjectToClipPos(input.pos);
                output.world = mul(unity_ObjectToWorld, input.pos);
                output.local = input.pos;

                return output;
            }

            fixed4 frag(vertexOutput output) : SV_TARGET
            {
                return output.local * _Brightness;
            }

            ENDCG
        }
    }
}
