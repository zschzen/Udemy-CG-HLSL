Shader "Custom/Math"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Hologram("Hologram", 2D) = "white" {}

        [HDR] _Color("Color", Color) = (1,1,1,1)

        _Frequency("Freq", Range(1, 30)) = 1
        _Speed("Speed", Range(1, 5)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Transparent"
        }

        Blend SrcAlpha One

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
                float2 huv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Hologram;
            float4    _MainTex_ST;
            float4    _Color;
            float     _Frequency;
            float     _Speed;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.huv = v.uv;
                o.huv.y += _Time * _Speed;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                fixed4 holo = tex2D(_Hologram, i.huv);
                //col.a *= sqrt(i.uv.y);
                //col.a *= abs(tan(i.uv.y * _Frequency));
                holo.a *= abs(sin(i.huv.y * _Frequency)); // sin = better blending
                return col * holo;
            }
            ENDCG
        }
    }
}