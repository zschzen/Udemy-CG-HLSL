Shader "Custom/Pattern"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Value1("Value 1", Range(0, 10)) = 1
        _Value2("Value 2", Range(0, 1)) = 0
        _Value3("Value 3", Range(1, 10)) = 2
        _Value4("Value 4", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        //Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "../_CGINC/Rotate.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            uniform float4 _Color;
            uniform float  _Value1;
            uniform float  _Value2;
            uniform float  _Value3;
            uniform float  _Value4;

            v2f vert(const appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.uv;
                o.uv = rotate(v.uv, _Value4);
                return o;
            }

            float shape(const float x, const float y)
            {
                const float left = step(0.1 * _Value1, x);
                const float bottom = step(0.1 * _Value1, y);
                const float up = step(0.1 * _Value1, 1 - y);
                const float right = step(0.1 * _Value1, 1 - x);

                return left * bottom * up * right;
            }

            float4 frag(v2f i) : COLOR
            {
                if(_Value1 == 0) discard;

                //float2 translation = float2(cos(_Time.y), sin(_Time.y));
                //i.uv += translation;

                i.uv *= _Value3 - _Value2;
                float cube = shape(frac(i.uv.x), frac(i.uv.y));

                clip(-cube);
                //if (cube >= 1) discard;

                cube = abs(1 - cube);
                return cube * _Color;// * i.uv.y * i.uv.x;
            }
            ENDCG
        }
    }
}