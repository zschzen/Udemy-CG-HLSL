Shader "Unlit/ZWrite"
{
    Properties
    {
        _Color("Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha // transparent and semi-transparent. enable alpha channel
        ZWrite Off // used for semi-transparent objects 
        // ZWrite On // (DEFAULT) used for opaque objects 
        Cull Off
        
        TAGS { "RenderType" = "Transparent" "Queue"="Transparent"}
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                return _Color;
            }
            ENDCG
        }
    }
}
