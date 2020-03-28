Shader "KVY/06_FakeLitMetall"
{
    Properties
    {
        _MainTex ("Base Color", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Color ("BaseColor", Color) = (1, 1, 1)
        _Roughness ("Glossiness", Range(0, 1)) = 1

        //_remap1 ("remap1", Float) = 0
        _remap2 ("Reflex", Range(0, 2)) = 1
        _pow ("Reflex Power", Range(0, 20)) = 1

        _SunX("Sun X", Range(-1, 1)) = 1
        _SunY("Sun Y", Range(-1, 1)) = 0
        _SunZ("Sun Z", Range(-1, 1)) = 0

        _SunColor ("Sun Color", Color) = (1, 1, 1)
        _ShadowColor ("Shadow Color", Color) = (0, 0, 0)
        _SunIntensity ("Sun Intensity", Range(0, 2)) = 1
        _ShadowContrast ("Shadow Contrast", Range(0, 2)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM 
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Libs/FunctionLib.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;

                half3x3 tangentSpace : TEXCOORD3;
                half3 normal : NORMAL;
            };

            sampler2D _MainTex, _BumpMap;
            half _Roughness, _SunIntensity, _ShadowContrast;
            fixed3 _SunColor, _Color, _ShadowColor;

            half _SunX, _SunY, _SunZ;
            float3 _Sun()
            {
                return float3(_SunX, _SunY, _SunZ);
            };

            half _remap2, _pow;

            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0, float4 tangent : TANGENT)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv;

                o.worldPos = mul(unity_ObjectToWorld, vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal);
                o.normal = o.worldNormal;

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

                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldReflect = reflect(-worldViewDir, i.worldNormal);
                half4 sky = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldReflect); // sample the default reflection cubemap, using the reflection vector

                fixed3 col = _Color * tex2D(_MainTex, i.uv);

                fixed3 lightData = dot(normalize(i.worldNormal), normalize(_Sun()));
                lightData = contrast(lightData, _ShadowContrast) * _SunIntensity;
                fixed3 light = lerp(_ShadowColor, _SunColor, lightData);

                fixed3 col_light = col * light;
                fixed3 rim = pow(1 - dot(worldViewDir, i.worldNormal), 4) + 0.1;
                fixed3 reflex = saturate(dot(normalize(_Sun()), normalize(worldReflect))) * _SunColor;

                fixed3 col_light_rim = lerp(col_light, sky, rim * _Roughness);

                fixed3 final = 1;
                final = col_light_rim + pow(remap(reflex, 0, 1, 0, _remap2), _pow);
                return final;
            }
            ENDCG
        }
    }
}
