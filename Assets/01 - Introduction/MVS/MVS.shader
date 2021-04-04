Shader "Custom/MVS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        [KeywordEnum(On, Multiply, Off, Default)] _UseColor("Use color", Float) = 1.0 // supports 9 enums in total
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
            // shader feature don`t include unused vars on compile time. multicompile always compile
            #pragma shader_feature _USECOLOR_ON _USECOLOR_OFF _USECOLOR_MULTIPLY

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4    _MainTex_ST;
            float4    _Color;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col;

                #ifdef _USECOLOR_OFF
                    col = tex2D(_MainTex, i.uv);
                #elif _USECOLOR_ON
                    col = _Color;
                #elif _USECOLOR_MULTIPLY
                    col = tex2D(_MainTex, i.uv) * _Color;
                #endif

                return col;
            }
            ENDCG
        }
    }
}