Shader "KVY/HeatMap"
{
    Properties
    {
        _HeatTex ("Heat Map", 2D) = "white" {}
        _uvY ("Uv-Y", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags {"Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha // Alpha blend

        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Pixel

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 svPos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            
            uniform float4 _Points[50]; // (x, z, radius, intensity)
            uniform uint _PointsLength;

            sampler2D _HeatTex;
            half _uvY;

            v2f Vertex (float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.worldPos = mul(unity_ObjectToWorld, localPos);

                return o;
            }

            fixed4 Pixel (v2f input) : SV_Target
            {
                half totalHeat = 0;

                [loop]
				for (uint i = 0; i < _PointsLength; i++)
				{
					half radius = _Points[i].z;
                    half intensity = _Points[i].w;
                    half dist = distance(input.worldPos.xz, _Points[i].xy);

					half heat = 1 - saturate(dist / radius);
                    heat *= intensity;

                    totalHeat += heat;
				}

                totalHeat = clamp(totalHeat, 0.1, 0.99);

                half4 color = tex2D(_HeatTex, fixed2(totalHeat, _uvY));
                return color;
            }
            ENDCG
        }
    }
}
