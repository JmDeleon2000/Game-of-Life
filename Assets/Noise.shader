Shader "Unlit/Noise"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white" {}
        _Offsetx ("Offset x", Float) = 0
        _Offsety ("Offset y", Float) = 0
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
            sampler2D _Noise;
            float4    _Noise_ST;

            float _Offsetx;
            float _Offsety;

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
                fixed4 col = tex2D(_Noise, i.uv + _Time.zw*10);

                return col;
            }
            ENDCG
        }
    }
}
