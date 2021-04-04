Shader "Custom/Magma"
{
    Properties
    {
        _RockTex ("Rock Texture", 2D) = "white" {}
        _MagmaTex ("Magma Texture", 2D) = "white" {}
        _DisTex ("Distortion Texture", 2D) = "white" {}
        [Space(10)]
        _DistValue("Distortion", Range(0, 10)) = 3
        _DistSpeed("Distortion Speed", Range(-0.4, 0.4)) = 0.1
        [Space(10)]
        _WaveSpeed("WaveSpeed", Range(0,5)) = 1
        _WaveFreq("Wave Frequency", Range(0,5)) = 1
        _WaveAmpl("Wave Amplitude", Range(0,1)) = 0.2
    }
    SubShader
    {
        // MAGMA ------------------------------
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
            };

            sampler2D _MagmaTex;
            sampler2D _DisTex;
            float4    _MagmaTex_ST;

            uniform float _DistValue;
            uniform float _DistSpeed;

            uniform float _WaveSpeed;
            uniform float _WaveFreq;
            uniform float _WaveAmpl;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex.y += sin((-worldPos.z + (_Time.y * _WaveSpeed)) * _WaveFreq) * _WaveAmpl;
                o.vertex.y += cos((-worldPos.x + (_Time.y * _WaveSpeed)) * _WaveFreq) * _WaveAmpl;
                
                o.uv = TRANSFORM_TEX(v.uv, _MagmaTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half        distortion = tex2D(_DisTex, i.uv + (_Time * _DistSpeed)).r;
                const float newValue = distortion / _DistValue;
                i.uv.x = newValue;
                i.uv.y = newValue;

                fixed4 col = tex2D(_MagmaTex, i.uv);
                return col;
                //float4(i.uv.x += distortion, i.uv.y += distortion, 0, 0)
            }
            ENDCG
        }

        // ROCK ------------------------------

        Pass
        {
            Tags
            {
                "Queue" ="Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha

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
            };

            sampler2D _RockTex;
            float4    _RockTex_ST;

            uniform float _WaveSpeed;
            uniform float _WaveFreq;
            uniform float _WaveAmpl;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex.y += sin((-worldPos.z + (_Time.y * _WaveSpeed)) * _WaveFreq) * _WaveAmpl;
                o.vertex.y += cos((-worldPos.x + (_Time.y * _WaveSpeed)) * _WaveFreq) * _WaveAmpl;
                
                o.uv = TRANSFORM_TEX(v.uv, _RockTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_RockTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}