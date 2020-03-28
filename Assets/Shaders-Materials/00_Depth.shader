Shader "KVY/00_Depth"
{
    Properties
    {
        _DepthStart ("Depth Start", Float) = 1.0
        _DepthEnd ("Depth End", Float) = -50.0
    }

    SubShader
    {
        Pass
        {
            ZWrite On

            CGPROGRAM

            #pragma vertex Vertex
            #pragma fragment Pixel

            struct v2f
            {
                float4 svPos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float depth : TEXCOORD1; 
            };

            float _DepthStart, _DepthEnd;
                 
            v2f Vertex(float4 localPos : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;
                
                o.svPos = UnityObjectToClipPos(localPos);
                o.uv = uv;
                o.depth = o.svPos.z;

                return o;
            }

            fixed3 Pixel(v2f i, out float outDepth : SV_DEPTH) : SV_TARGET
            {
                //fixed3 col = smoothstep(_DepthStart, _DepthEnd, i.depth);
                outDepth =  i.svPos.z;
                return i.depth;
            }

            ENDCG
        }
    }
}