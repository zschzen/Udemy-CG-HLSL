Shader "Unlit/Displacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Height("Height Scale", Range(0.005, 0.08)) = 0.02
        _HeightMap("Height Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 sPos : TEXCOORD1;  
            };

            sampler2D _MainTex;
            float4    _MainTex_ST;
            sampler2D _HeightMap;
            half      _Height;

            v2f vert(appdata v)
            {
                v2f    o;
                float4 heightMap = tex2Dlod(_HeightMap, float4(v.uv.xy, 0, 0));
                v.vertex.y += heightMap.b * _Height;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.sPos = ComputeScreenPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return saturate(i.sPos);
            }
            ENDCG
        }
    }
}