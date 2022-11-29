// Yet Another Demake Shader
// Copyright (c) 2022 Mike <rikovmike> Rykov (rikovmike@gmail.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


Shader "rikovmike/YADS-ColorLimiter" {
Properties{
_MainTex("RenderTex", 2D) = "white" {}
_PaletteTex("Palette", 2D) = "white" {}
_ColorCount("Color Count", Int) = 256
[MaterialToggle] _addDither("Use Dither", Float) = 0
_DitherTex("Dither", 2D) = "white" {}
_DitherLevel("Dither Treshold", Range(0,1)) = 0.5
}
SubShader{ Lighting Off ZTest Always Cull Off ZWrite Off Fog { Mode Off }
Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
uniform sampler2D _MainTex,_PaletteTex,_DitherTex; uniform int _ColorCount; float4 _MainTex_TexelSize,_DitherTex_TexelSize,_MainTex_ST; float _DitherLevel,_addDither; struct v2f { float4  pos : SV_POSITION; float2  uv : TEXCOORD0; float4 screenPosition : TEXCOORD1; }; v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); o.uv = TRANSFORM_TEX(v.texcoord, _MainTex); return o; } half4 frag(v2f i) : COLOR { fixed3 or = tex2D(_MainTex, i.uv).rgb; fixed4 col = fixed4(0,0,0,0); fixed cd = 255.0; fixed4 pc = fixed4(0, 0, 0, 0); for (int ii = 0; ii < _ColorCount; ii++) { fixed4 c = tex2D(_PaletteTex,float2(ii,0) / float2(_ColorCount,1)); fixed d = distance(or, c); if (d < cd) {pc = col;cd = d;col = c; } } float2 diCoord = float2(i.uv[0] * _MainTex_TexelSize.z / _DitherTex_TexelSize.z, i.uv[1] * _MainTex_TexelSize.w / _DitherTex_TexelSize.w); fixed dlum = Luminance(tex2D(_DitherTex, diCoord).rgb); if (_addDither > 0 && cd > _DitherLevel && dlum < 0.5)  col = pc; return col; } ENDCG
}
}
FallBack "Diffuse"
}