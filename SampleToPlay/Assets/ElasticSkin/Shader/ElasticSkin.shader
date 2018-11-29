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
		//押している位置 (最後の方になったら正式に使用する。)
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
				
				o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
				float2 _pres_pos_uv = float2(_PressMeshPos.x, _PressMeshPos.y);
				float _distance = distance(_pres_pos_uv, o.uv);
				float _is_dis = sin(_distance);
				//v.vertex.y = v.vertex.y + _is_dis;

				//v.vertex = UnityObjectToClipPos(v.vertex);
				//o.vertex = v.vertex + float4(0,_is_dis,0,0);
				float amp = 0.5 * sin(_Time * 100 + v.vertex.x * 100);
				v.vertex.xyz = float3(v.vertex.x, v.vertex.y + amp, v.vertex.z);
				o.vertex =  UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			//サーフェスシェーダー
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_SkinTex, i.uv);
				float2 _pres_pos_uv = float2(0.0f ,0.0f);
				col = fixed4(distance(i.uv,_pres_pos_uv), 0, 0, 1);
				return col;
			}
			ENDCG
		}
	}
}
