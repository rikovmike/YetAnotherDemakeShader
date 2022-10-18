Shader "Rikovmike/LimitPaletteRaw" {
	Properties {
		// Рендер-текстура
	 	_MainTex ("RenderTex", 2D) = "white" {}
		// Текстура палитры
	 	_PaletteTex ("Palette", 2D) = "white" {}
		// Количество цветов в палитре
		_ColorCount ("Color Count", Int) = 8

		// Галочка "Юзать дизеринг"
		[MaterialToggle] _addDither("Use Dither", Float) = 0
		// Текстура дизеринга
		_DitherTex("Dither", 2D) = "white" {}
		// Предел рисования дизеринга
		_DitherLevel("Dither Treshold", Range(0,1)) = 0.5

	}

	SubShader {
		// Отключаем все ненужное
		Lighting Off
		ZTest Always
		Cull Off
		ZWrite Off
		Fog { Mode Off }

	 	Pass {
	  		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	  		#include "UnityCG.cginc"

			// Обьявляем переменные
	  		uniform sampler2D _MainTex;
			uniform sampler2D _PaletteTex;
			uniform sampler2D _DitherTex;

	  		uniform int _ColorCount;
			float4 _MainTex_TexelSize;
			float4 _DitherTex_TexelSize;
			float _DitherLevel;
			float _addDither;

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


			half4 frag (v2f i) : COLOR
			{
				// Огиринальный пиксель
				fixed3 original = tex2D(_MainTex, i.uv).rgb;
				// Будущий подменный пиксель. Изначально черен как чернота
				fixed4 col = fixed4(0,0,0,0);
				// Дистанция между векторами цвета. Инициализируем как очень большую.
				fixed dist = 10000.0;


				// Предыдущий пиксель палитры (для дизеринга)
				fixed4 prevcol = fixed4(0, 0, 0, 0);

				// Обходим пиксели палитры
				for (int ii = 0; ii < _ColorCount; ii++) {
					// Выбор пикселя из текстуры палитры
					fixed4 c = tex2D(_PaletteTex,float2(ii,0) / float2(_ColorCount,1));
					// Находим дистанцию между ним и оригинальным пикселем
					fixed d = distance(original, c);
					//Если дистанция меньше предыдущей минимальной, сохраняем ее как минимальную
					//Заодно сохраняем предыдущий пиксель для дизеринга
					if (d < dist) {
						prevcol = col;
						dist = d;
						col = c;
					}
				}


				//Вычисляем координаты нужного нам пикселя на сетке тьекстуры дизеринга. Текстура у нас повторяется и виртуально 
				//заполняет весь экран. Находим мнимые координаты на основе координат текущего оригинального пикселя на экране.
				float2 ditherCoordinate = float2(i.uv[0] * _MainTex_TexelSize.z / _DitherTex_TexelSize.z, i.uv[1] * _MainTex_TexelSize.w / _DitherTex_TexelSize.w);
				
				//Хватаем пиксель дизаринга по координатам.
				fixed dlum = Luminance(tex2D(_DitherTex, ditherCoordinate).rgb);
				//Если галочка в параметрах стоит
				if (_addDither > 0) {
					//Если порог дизерингда нужный
					if (dist > _DitherLevel) {
						//Если пиксель дизеринга черный, то заменяем выбранный ранее цвет на предыдущий
						if (dlum < 0.5)  col = prevcol;
					}
				}

				return col;
	  		}
	  		ENDCG
	 	}
	}
	FallBack "Diffuse"
}