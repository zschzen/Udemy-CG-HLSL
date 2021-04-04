Shader "Custom/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineTex ("Outline texture", 2D) = "white" {}
        [MaterialToggle] UseOutlineTex("Use outline tex", Float) = 1
        [Space(10)]
        _OutColor("Outline Color", Color) = (1,1,1,1)
        _OutValue("Outline value", Range(0.0, 0.2)) = 0.1
    }
    SubShader
    {
        // OUTLINE
        Pass
        {
            Tags
            {
                "RenderType"="Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma multi_compile _ USEOUTLINETEX_ON

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 uvv : TEXCOORD1;
            };

            uniform sampler2D _MainTex;
            uniform sampler2D _OutlineTex;
            uniform float4    _MainTex_ST;
            uniform float4    _OutColor;
            uniform float     _OutValue;

            inline float4 outline(const float4 vertPos, const float outValue)
            {
                const float    increment = 1 + outValue;
                const float4x4 scale = float4x4
                (
                    increment, 0, 0, 0,
                    0, increment, 0, 0,
                    0, 0, increment, 0,
                    0, 0, 0, increment
                );

                return mul(scale, vertPos);
            }

            v2f vert(const appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                const float4 vertPos = outline(v.vertex, _OutValue);
                o.vertex = UnityObjectToClipPos(vertPos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvv = ComputeScreenPos(o.vertex);
                return o;
            }

            float4 frag(const v2f i) : Color
            {
                float4 col = float4(1, 1, 1, tex2D(_MainTex, i.uv).a);

                #ifdef USEOUTLINETEX_ON
                    float2 coords = i.uvv.xy / i.uvv.z;
                    coords.x += _Time * 15.0;
                    col *= _OutColor * tex2D(_OutlineTex, coords);
                #else
                col *= _OutColor;
                #endif

                return col;
            }
            ENDCG
        }

        // TEXURE PASS
        Pass
        {
            Tags
            {
                "RenderType"="Transparent+1"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            uniform sampler2D _MainTex;
            uniform float4    _MainTex_ST;

            v2f vert(const appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(const v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}