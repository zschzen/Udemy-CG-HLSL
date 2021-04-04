Shader "Custom/TextureUV"
{
    Properties
    {
        _Color("Tint", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white"{}
        [NoScaleOffset] _BumpMap("Normal Map", 2D) = "bump" {}
    }

    Subshader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vertShader
            #pargma fragment fragShader

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;     // propertie
            uniform float4 _MainTex_ST;     // offset
            float4 _Color;
            
            struct vertInput {
                float4 vertex : POSITION;   // NAME : SEMANTICA
                float2 uv : TEXCOORD0;
            };

            struct vertOutput {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            vertOutput vertShader(vertInput i)
            {
                vertOutput o;
                o.position = UnityObjectToClipPos(i.vertex);
                //o.uv = i.uv;
                //o.uv = (i.uv * _MainTex_ST.xy + _MainTex_ST.zw); // apply tilling / offset
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
                return o;
            }
            
            fixed4 fragShader(vertOutput o) : SV_TARGET
            {
                fixed col = tex2D(_MainTex, o.uv) * _Color;

                return col;
            }
            
            ENDCG
        }
    }
    FALLBACK "Mobile/VertexLit"
}