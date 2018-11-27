///このしぇーだーは、タッチしている領域に対して、タッチしている地点を中心に、
///くぼみみたいに表現を行うためのものです。
Shader "Unlit/ElasticSkin"
{
	Properties
	{
		//肌テクスチャ
		_SkinTex ("Texture", 2D) = "white" {}
		//ノーマルマップ
		_SkinNormalMap("Normal map",2D) = "bump"{}
		//圧力
		_PressPower("PressPower",FLOAT) = 0
		//押している位置 ()
		_PressMeshPos("TouchScreenPos",Vector)=(0.5,0.5,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;		//メッシュの頂点情報
				float3 normal : NORMAL;			//メッシュのノーマル情報
				float2 uv : TEXCOORD0;			//テクスチャのUVに当たる情報
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;			//テクスチャ座標
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;	//入力された、値の位置
			};

			///肌に当たるテクスチャ
			sampler2D _SkinTex;
			// 肌のノーマルマップ
			sampler2D _SkinNormalMap;
			//圧力
			float _PressPower;
			//メッシュでの抑えた位置
			float4 _PressMeshPos;

			//なんかよくわからんけど必要
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_SkinTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
