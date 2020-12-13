Shader "KVY/05_LegacyDiffuse"
{
    Properties
    {
        _MainTex ("BaseColor Map", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _AOIntensity ("AO Intensity", Range(0, 2)) = 1
        _AOMap ("AO Map", 2D) = "white" {}
        _Metallic ("Metallic Intensity", Range(0, 1)) = 0
        _MetallicMap ("Metallic Map", 2D) = "white" {}
        _Roughness ("Roughness Intensity", Range(0, 1)) = 1 
        _RoughnessMap ("Roughness Map", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM 
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;

                half3x3 tangentSpace : TEXCOORD3;
                // tangent Space = { {tangent.x [0][0], bitangent.x [0][1], normal.x[0][2]},
                //                   {tangent.y [1][0], bitangent.y [1][1], normal.y[1][2]},
                //                   {tangent.z [2][0], bitangent.z [2][1], normal.z[2][2]} }
            };

            sampler2D _MainTex, _AOMap, _BumpMap, _MetallicMap, _RoughnessMap;
            float _Metallic, _Roughness, _AOIntensity;

            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0, float4 tangent : TANGENT)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv;

                o.worldPos = mul(unity_ObjectToWorld, vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(normal));

                half3 worldTangent = UnityObjectToWorldDir(tangent);
                half3 worldBitangent = cross(o.worldNormal, worldTangent) * tangent.w * unity_WorldTransformParams.w;

                o.tangentSpace[0] = half3(worldTangent.x, worldBitangent.x, o.worldNormal.x);
                o.tangentSpace[1] = half3(worldTangent.y, worldBitangent.y, o.worldNormal.y);
                o.tangentSpace[2] = half3(worldTangent.z, worldBitangent.z, o.worldNormal.z);

                return o;
            }

            fixed3 frag(v2f i) : SV_TARGET
            {
                half3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                i.worldNormal = half3
                                    (
                                    dot(i.tangentSpace[0], tangentNormal),
                                    dot(i.tangentSpace[1], tangentNormal),
                                    dot(i.tangentSpace[2], tangentNormal)
                                    );

                fixed3 col;
                col = tex2D(_MainTex, i.uv);
                col *= lerp(1, tex2D(_AOMap, i.uv), _AOIntensity);

                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldReflect = reflect(-worldViewDir, i.worldNormal);
                half4 sky = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldReflect); // sample the default reflection cubemap, using the reflection vector
                
                return lerp
                        (
                        col * lerp(1, sky, _Metallic * tex2D(_MetallicMap, i.uv)), 
                        sky, 
                        (tex2D(_RoughnessMap, i.uv) * _Roughness * 0.5) 
                        );
            }
            ENDCG
        }
    }
}
