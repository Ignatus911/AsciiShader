Shader "Unlit/AsciiCameraEffect"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		Width("Width", float) = 1024
		Height("Height", float) = 768
		PixelScale("PixelScale", float) = 10
		AddTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

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
			sampler2D AddTex;
			float4 _MainTex_ST;
			float Width;
			float Height;
			float PixelScale;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				PixelScale = ceil(PixelScale);
				fixed4 col = tex2D(_MainTex, i.uv);
				float pixelX = ceil(i.uv.x * Width);
				float pixelY = ceil(i.uv.y * Height);
				float halfCellX = ceil(PixelScale / 2);
				float halfCellY = ceil(PixelScale / 2);
				float xColorPos = (ceil(pixelX / PixelScale) * PixelScale + halfCellX) / Width;
				float yColorPos = (ceil(pixelY / PixelScale) * PixelScale + halfCellY) / Height;
				fixed4 resultCol = tex2D(_MainTex, float2(xColorPos, yColorPos));
				float pixelXIndex = (i.uv.x * Width) % PixelScale;
				float pixelYIndex = (i.uv.y * Height) % PixelScale;
				resultCol.rgb = dot(resultCol.rgb, float3(0.3, 0.59, 0.11));
				float gray = (resultCol.r + resultCol.g + resultCol.b) / 3;
				gray = clamp(gray, 0, 0.9);
				float xOffset = ceil(gray / 0.1) * 0.1;
				float2 percentPosition = i.uv;
				percentPosition.x = pixelXIndex / PixelScale / 10 + xOffset;
				percentPosition.y = pixelYIndex / PixelScale;
				return tex2D(AddTex, percentPosition);
			}
			ENDCG
		}
	}
}
