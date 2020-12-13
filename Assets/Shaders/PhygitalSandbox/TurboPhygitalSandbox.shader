Shader "KVY/TurboPhygitalSandbox"
{
    Properties
    {   
        _HeightMap ("Height Map", 2D) = "white" {}
        
        _FirstTex ("Texture 1", 2D) = "white" {}
        
        _Edge1Level ("Edge 1 Level", Range(0, 1)) = 0
        _Edge1Smoothness ("Edge 1 Smoothness", Range(0, 0.5)) = 0
        
        _SecondTex ("Texture 2", 2D) = "white" {}
        
        _Edge2Level ("Edge 2 Level", Range(0, 1)) = 0
        _Edge2Smoothness ("Edge 2 Smoothness", Range(0, 0.5)) = 0
        
        _ThirdTex ("Texture 3", 2D) = "white" {}  
      
        _Color ("Tint Color", Color) = (1, 1, 1)
        _Sharpness ("Triplanar Sharpenss", Range(2, 64)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "UnityCG.cginc"
            
            half _Edge1Level;
            half _Edge1Smoothness;
            
            half _Edge2Level;
            half _Edge2Smoothness;
            
            sampler2D _HeightMap;
            sampler2D _FirstTex;
            sampler2D _SecondTex;
            sampler2D _ThirdTex;
            
            fixed3 _Color;
            half _Sharpness;

            struct v2f
            {   
                float4 svPos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 worldNormal : NORMAL;
                float2 uv: TEXCOORD1;
            };

            v2f Vertex (float4 localPos : POSITION, float3 localNormal : NORMAL, float2 uv: TEXCOORD0)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);
                o.uv = uv;

                o.worldNormal = normalize(UnityObjectToWorldNormal(localNormal));

                return o;
            }

            fixed3 Fragment (v2f i) : SV_Target
            {
                half heightMap = tex2D(_HeightMap, i.uv).r;
                _Edge1Level = clamp(_Edge1Level, 0, _Edge2Level + _Edge2Smoothness);
                _Edge2Level = clamp(_Edge2Level, _Edge1Level + _Edge1Smoothness, 1);
                half mask1to2 = smoothstep(_Edge1Level, _Edge1Level + _Edge1Smoothness, heightMap);
                half mask2to3 = smoothstep(_Edge2Level, _Edge2Level + _Edge2Smoothness, heightMap);
                 
                fixed3 col_front1 = tex2D(_FirstTex, i.worldPos.xy) * (1 - mask1to2);
                fixed3 col_side1 = tex2D(_FirstTex, i.worldPos.zy) * (1 - mask1to2);
                fixed3 col_top1 = tex2D(_FirstTex, i.worldPos.xz) * (1 - mask1to2);
                
                fixed3 col_front2 = tex2D(_SecondTex, i.worldPos.xy) * mask1to2 * (1 - mask2to3);
                fixed3 col_side2 = tex2D(_SecondTex, i.worldPos.zy) * mask1to2 * (1 - mask2to3);
                fixed3 col_top2 = tex2D(_SecondTex, i.worldPos.xz) * mask1to2 * (1 - mask2to3);
                
                fixed3 col_front3 = tex2D(_ThirdTex, i.worldPos.xy) * mask2to3;
                fixed3 col_side3 = tex2D(_ThirdTex, i.worldPos.zy) * mask2to3;
                fixed3 col_top3 = tex2D(_ThirdTex, i.worldPos.xz) * mask2to3;
                
                fixed3 col_front = col_front1 + col_front2 + col_front3;
                fixed3 col_side = col_side1 + col_side2 + col_side3;
                fixed3 col_top = col_top1 + col_top2 + col_top3;

                // upd normals after displacement
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
