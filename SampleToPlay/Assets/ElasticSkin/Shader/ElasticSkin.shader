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
		_PressMeshPos("TouchScreenPos",Vector) = (0.5,0.5,0,0)
		//押した力の影響具合を受ける距離
		_PressInFrenceDistance("PressInfrenceDistance",Float) = 1
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
				float4 normal:NORMAL;			//法線の方向　圧力を中心にベクトルを変形させる

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

			//圧力の影響を与える距離
			float _PressInFrenceDistance;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
				float2 _pres_pos_uv = float2(_PressMeshPos.x, _PressMeshPos.y);
				float _distance = distance(_pres_pos_uv, o.uv);
				//近いほど　受ける値を大きくする。ためのもの
				float _inv_distance = 1 -_distance;

				//一定の距離内なら　１　に値を入れる
				float _cheak_distance = step(_distance, _PressInFrenceDistance);
				
				v.vertex.y = v.vertex.y  + (_inv_distance * _PressPower) * _cheak_distance;			//高さを出すための5f

				//v.vertex = UnityObjectToClipPos(v.vertex);
				//o.vertex = v.vertex + float4(0,_is_dis,0,0);
				
				v.vertex.xyz = float3(v.vertex.x, v.vertex.y, v.vertex.z);
				o.vertex =  UnityObjectToClipPos(v.vertex);



				o.normal = float4(1, 1, 1, 1);


				return o;
			}
			
			//サーフェスシェーダー
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_SkinTex, i.uv);
				float2 _pres_pos_uv = float2(_PressMeshPos.x, _PressMeshPos.y);
				col = fixed4(distance(i.uv,_pres_pos_uv), 0, 0, 1);
				return col;
			}
			ENDCG
		}
	}
}
