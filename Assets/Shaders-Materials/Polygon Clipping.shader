Shader "KVY/Polygon Clipping"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Pixel

            #include "UnityCG.cginc"

            struct v2f
            {   
                float4 svPos : SV_POSITION;
                float3 localPos : TEXCOORD0;
            };

            fixed3 _Color;

            uniform float2 _points[100];
            uniform uint _pointsCount; 

            v2f Vertex (float4 localPos : POSITION)
            {
                v2f o;

                o.svPos = UnityObjectToClipPos(localPos);
                o.localPos = localPos;

                return o;
            }

            float isLeftOfLine(float2 pos, float2 linePoint1, float2 linePoint2)
            {
                float2 lineDirection = linePoint2 - linePoint1;
                float2 lineNormal = float2(-lineDirection.y, lineDirection.x);
                float2 toPos = pos - linePoint1;

                float side = dot(toPos, lineNormal);
                side = step(0, side);

                return side;
            }

            fixed3 Pixel (v2f i) : SV_Target
            {
                float2 linePoint1 = float2(0, 0);
                float2 linePoint2 = float2(1, 1);
                float2 linePoint3 = float2(0, -2);

                float outsidePolygon = 0;

                [loop]
                for(uint index; index < _pointsCount; index++)
                {
                    outsidePolygon += isLeftOfLine(i.localPos.xz, _points[index], _points[(index + 1) % _pointsCount]);
                }

                clip(-outsidePolygon);

                return _Color;
            }
            ENDCG
        }
    }
}
