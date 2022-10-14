Shader "rikovmike/colorFilterPalette"
{
    Properties{
        _MainTex("Texture", 2D) = "white" { }
        _color1("Color 1",Color)=(0,0,0,0)
        _Dither1("Dither 1-2", 2D) = "white" {}
        _color2("Color 2",Color) = (170,0,170,0)
        _Dither2("Dither 2-3", 2D) = "white" {}
        _color3("Color 3",Color) = (0,170,170,0)
        _Dither3("Dither 3-4", 2D) = "white" {}
        _color4("Color 4",Color) = (170,170,170,0)
    }
        SubShader{
            Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_TexelSize;
        float4 _color1;
        float4 _color2;
        float4 _color3;
        float4 _color4;
        sampler2D _Dither1;
        sampler2D _Dither2;
        sampler2D _Dither3;
        float4 _Dither1_TexelSize;
        float4 _Dither2_TexelSize;
        float4 _Dither3_TexelSize;


        struct v2f {
            float4  pos : SV_POSITION;
            float2  uv : TEXCOORD0;
            float4 screenPosition : TEXCOORD1;
        };

        float4 _MainTex_ST;

        v2f vert(appdata_base v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            return o;
        }

        half4 frag(v2f i) : COLOR
        {
                fixed4 main = tex2D(_MainTex, i.uv);
                fixed lum = Luminance(main.rgb);
                fixed3 result = fixed3(0,0,0);
                
                if (lum <= 0.15) result.rgb = _color1;
                if (lum > 0.15) {
                    float2 ditherCoordinate = float2(i.uv[0] * _MainTex_TexelSize.z / _Dither1_TexelSize.z, i.uv[1] * _MainTex_TexelSize.w / _Dither1_TexelSize.w);
                    result.rgb = tex2D(_Dither1, ditherCoordinate).rgb;
                }
                
                if (lum > 0.2) result.rgb = _color2;
                if (lum > 0.35) {
                    float2 ditherCoordinate = float2(i.uv[0] * _MainTex_TexelSize.z / _Dither2_TexelSize.z, i.uv[1] * _MainTex_TexelSize.w / _Dither2_TexelSize.w);
                    result.rgb = tex2D(_Dither2, ditherCoordinate).rgb;
                }

                if (lum > 0.4) result.rgb = _color3;
                if (lum > 0.6) {
                    float2 ditherCoordinate = float2(i.uv[0] * _MainTex_TexelSize.z / _Dither3_TexelSize.z, i.uv[1] * _MainTex_TexelSize.w / _Dither3_TexelSize.w);
                    result.rgb = tex2D(_Dither3, ditherCoordinate).rgb;
                }

                if (lum > 0.65) result.rgb = _color4;
                return fixed4(result, 1);

        }
        ENDCG

            }
    }
        Fallback "VertexLit"
}