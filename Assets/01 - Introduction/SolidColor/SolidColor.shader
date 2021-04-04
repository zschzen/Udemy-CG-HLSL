Shader "Custom/SolidColor"
{
    Properties
    {
        _Color("Tint", Color) = (1, 1, 1, 1)
    }

    Subshader
    {
        Pass
        {
            CGPROGRAM

            // diretiva de compilação
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            
            struct vertexInput
            {
                fixed4 vertex : POSITION;        // object space
            };

            struct vertexOutput
            {
                fixed4 position : SV_POSITION;  // projection-space
                fixed4 color : COLOR;           // pixel color
            };

            fixed4 _Color;
            
            // VERTEX SHADER
            vertexOutput vertexShader(vertexInput i)
            {
                vertexOutput o;
                //o.position = UnityObjectToClipPos(i.vertex);    // object-space to projection-space also mul(UNITY_MATRIX_MVP, i.vertex)
                float x = i.vertex.x;
                float y = i.vertex.y;
                float z = i.vertex.z;
                float w = 1; // coordenada homogenea

                i.vertex = float4(x, y, z, w);
                
                o.position = mul(unity_ObjectToWorld, i.vertex); // UNITY_MATRIX_M
                o.position = mul(UNITY_MATRIX_V, o.position);
                o.position = mul(UNITY_MATRIX_P, o.position); // frustum based
                o.color = _Color;
                return o;
            }

            // FRAGMENT SHADER
            /*fixed4 fragmentShader(vertexOutput o) : SV_TARGET
            {
                return o.color;
            }*/

            struct pixelOutput
            {
                fixed4 pixel : SV_TARGET;   
            };

            pixelOutput fragmentShader(vertexOutput o)
            {
                pixelOutput p;
                p.pixel = saturate(o.color * sin(_Time.y));

                return p;
            }
            
            ENDCG
        }
    }
    Fallback "Mobile/VertexLit"
}