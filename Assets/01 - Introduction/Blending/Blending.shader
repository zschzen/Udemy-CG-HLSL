Shader "Unlit/Blending"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR] _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        ZWrite Off // working with transparencies
        //Blend SrcAlpha OneMinusSrcAlpha   // Traditional
        //Blend One OneMinusSrcAlpha        // premultiplied
        //Blend One One                     // additive
        //Blend OneMinusDstColor One        // soft additive
        //Blend DstColor Zero                 // multiply
        //Blend DstColor SrcColor             // 2x multiply
        //Blend SrcColor One                  // overlay
        //Blend OneMinusSrcColor One                  // soft light
        Blend Zero OneMinusSrcColor            // subtract
        
        //BlendOp Add // Default value
        //BlendOp Sub 
        //BlendOp Max 
        BlendOp Min 
        //BlendOp RevSub
        
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
